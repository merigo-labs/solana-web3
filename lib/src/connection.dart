/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import 'package:solana_common/config/cluster.dart';
import 'package:solana_common/extensions/future.dart';
import 'package:solana_common/exceptions/json_rpc_exception.dart';
import 'package:solana_common/protocol/json_rpc_context_response.dart';
import 'package:solana_common/protocol/json_rpc_context_result.dart';
import 'package:solana_common/protocol/json_rpc_http_headers.dart';
import 'package:solana_common/protocol/json_rpc_notification_response.dart';
import 'package:solana_common/protocol/json_rpc_request.dart';
import 'package:solana_common/protocol/json_rpc_request_config.dart';
import 'package:solana_common/protocol/json_rpc_response.dart';
import 'package:solana_common/protocol/json_rpc_subscribe_response.dart';
import 'package:solana_common/protocol/json_rpc_unsubscribe_response.dart';
import 'package:solana_common/utils/buffer.dart';
import 'package:solana_common/utils/convert.dart' as convert show base58, list;
import 'package:solana_common/utils/library.dart' as utils show cast, check;
import 'package:solana_common/utils/types.dart' show JsonRpcListParser, JsonRpcMapParser, 
  JsonRpcParser, i64, u64, usize;
import 'package:solana_common/web_socket/solana_web_socket_connection.dart';
import 'package:solana_common/web_socket/web_socket_exchange_manager.dart';
import 'package:solana_common/web_socket/web_socket_subscription_manager.dart';

import 'nacl.dart' as nacl show signatureLength;
import 'keypair.dart';
import 'message/message.dart';
import 'models/logs_filter.dart';
import 'public_key.dart';
import 'transaction/transaction.dart';
import '../exceptions/transaction_exception.dart';
import '../rpc_config/index.dart';
import '../rpc_models/index.dart';
import '../types/accounts_filter.dart';
import '../types/commitment.dart';
import '../types/health_status.dart';
import '../types/method.dart';
import '../types/notification_method.dart';
import '../types/token_accounts_filter.dart';
import '../types/transaction_encoding.dart';


/// Connection
/// ------------------------------------------------------------------------------------------------

class Connection extends SolanaWebSocketConnection {

  /// {@template solana_web3.Connection}
  /// Creates a connection to the [cluster].
  /// 
  /// Web socket method calls are made to the [Cluster.wsDomain], which defaults to 
  /// [Cluster.domain]. 
  /// 
  /// The [commitment] configuration will be set as the default value for all methods that accept a 
  /// commitment parameter. Use the `config` parameter of a method call to override the default 
  /// value.
  /// 
  /// ```
  /// final connection = Connection(Cluster.mainnet);
  /// 
  /// final accountInfo = await connection.getAccountInfo(
  ///   PublicKey.fromBase58('Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB'), 
  ///   config: GetAccountInfoConfig(
  ///     commitment: Commitment.finalized, // override default.
  ///   ),
  /// );
  /// 
  /// print('Account Info ${accountInfo?.toJson()}');
  /// ```
  /// {@endtemplate}
  /// 
  /// TODO: Auto connect / resubscribe when the devices connection status changes.
  Connection(
    this.cluster, { 
    this.commitment = Commitment.confirmed,
  }): super() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _onConnectivityChanged
    );
  }

  /// A persistent connection.
  final http.Client client = http.Client();

  /// The cluster to connect to.
  final Cluster cluster;

  /// The default commitment level (applied to a subset of method invocations).
  final Commitment? commitment;

  /// Listen to connectivity changes.
  late final StreamSubscription<ConnectivityResult> _connectivitySubscription;

  /// The latest blockhash.
  final BlockhashCache _blockhashCache = BlockhashCache();

  // /// Maps [JsonRpcRequest]s to their corresponding [JsonRpcResponse].
  // final WebSocketExchangeManager _webSocketExchangeManager = WebSocketExchangeManager();

  // /// Adds and removes stream listeners for a web socket subscription.
  // final WebSocketSubscriptionManager _webSocketSubscriptionManager = WebSocketSubscriptionManager();

  /// Returns true if there's at least one subscriber.
  bool get hasSubscribers => webSocketSubscriptionManager.isNotEmpty;

  /// Disposes of all the acquired resources.
  void disconnect() {
    client.close();
    socket.disconnect().ignore();
    webSocketExchangeManager.dispose();
    webSocketSubscriptionManager.dispose();
    _connectivitySubscription.cancel();
  }

  /// Reconnect the web socket.
  void _onConnectivityChanged(final ConnectivityResult result) {
    if (result == ConnectivityResult.ethernet
      || result == ConnectivityResult.mobile
      || result == ConnectivityResult.wifi) {
      if (!socket.isConnected && hasSubscribers) {
        socket.connect(cluster.ws()).ignore(); // This will call onConnect.
      }
    }
  }
  
  /// Resubscribe all existing subscriptions.
  @override
  void onWebSocketConnect() {
    // TODO: Check or set [WebSocketExchange.id] to the largest id found.
    for(final WebSocketExchange exchange in webSocketExchangeManager.values) {
      resubscribe(exchange).ignore();
    }
  }
  
  @override
  void onWebSocketData(final dynamic data) {
    // print("\n--------------------------------------------------------------------------------");
    // print("[ON SOCKET DATA]         $data");
    // print("--------------------------------------------------------------------------------\n");
    if (data is String && data.isNotEmpty) {
      return _onWebSocketData(json.decode(data));
    }
  }

  void _onWebSocketData(final Map<String, dynamic> data) {

    final Map<String, dynamic> json = Map.castFrom(data);

    if (JsonRpcResponse.isType<int>(json)) {
      final JsonRpcSubscribeResponse response = JsonRpcResponse.parse(json, utils.cast<int>);
      return webSocketExchangeManager.complete(response);
    }

    if (JsonRpcResponse.isType<bool>(json)) {
      final JsonRpcUnsubscribeResponse response = JsonRpcResponse.parse(json, utils.cast<bool>);
      return webSocketExchangeManager.complete(response);
    }

    final JsonRpcResponse? response = JsonRpcResponse.tryParse(json, utils.cast<dynamic>);
    if (response != null && response.isError) {
      return webSocketExchangeManager.complete(response);
    }

    final notification = NotificationMethod.tryFromName(json['method']);
    if (notification != null) {
      switch (notification) {
        case NotificationMethod.accountNotification:
          return _onWebSocketNotification(json, _unwrapValueParser(AccountInfo.parse));
        case NotificationMethod.logsNotification:
          return _onWebSocketNotification(json, _unwrapValueParser(LogsNotification.fromJson));
        case NotificationMethod.programNotification:
          return _onWebSocketNotification(json, _unwrapValueParser(ProgramAccount.parse));
        case NotificationMethod.rootNotification:
          return _onWebSocketNotification(json, utils.cast<u64>);
        case NotificationMethod.signatureNotification:
          return _onWebSocketNotification(json, _unwrapValueParser(SignatureNotification.fromJson));
        case NotificationMethod.slotNotification:
          return _onWebSocketNotification(json, SlotNotification.fromJson);
      }
    }
  }
  
  void _onWebSocketNotification<T, U>(final Map<String, dynamic> json, final JsonRpcParser<T, U> parser) 
    => webSocketSubscriptionManager.notify(JsonRpcNotificationResponse.parse(json, parser));
  
  @override
  void onWebSocketError(Object error, [StackTrace? stackTrace]) {
    print("\n--------------------------------------------------------------------------------");
    print("[ON SOCKET ERROR]        $error");
    print("--------------------------------------------------------------------------------\n");
  }

  @override
  void onWebSocketDisconnect([int? code, String? reason]) {
    // TODO: implement onWebSocketDisconnect
  }

  /// Prints the contents of a JSON-RPC request.
  void _debugRequest(final Object request) {
    print("\n--------------------------------------------------------------------------------");
    print("[REQUEST BODY]:          $request");
    print("--------------------------------------------------------------------------------\n");
  }

  /// Prints the contents of a JSON-RPC response.
  void _debugResponse(final http.Response response) {
    print("\n--------------------------------------------------------------------------------");
    print("[RESPONSE BODY]:           ${response.body}");
    final Map<String, dynamic>? body = json.decode(response.body);
    print("\n--------------------------------------------------------------------------------");
    print("[RESPONSE BODY]:           $body");
    print("[RESPONSE RESULT TYPE]:    ${(body ?? {})['result']?.runtimeType}");
    print("[RESPONSE STATUS CODE]:    ${response.statusCode}");
    print("[RESPONSE REASON PHRASE]:  ${response.reasonPhrase}");
    print("--------------------------------------------------------------------------------\n");
  }

  /// Prints the contents of a web socket data request.
  void _debugWebSocketRequest(final JsonRpcRequest request) {
    print("\n--------------------------------------------------------------------------------");
    print("[WEBSOCKET DATA]:          ${request.toJson()}");
    print("--------------------------------------------------------------------------------\n");
  }

  /// Prints the web socket exchanges and subscriptions.
  void debugWebSocketState() {
    print("\n--------------------------------------------------------------------------------");
    print("[WEBSOCKET EXCHANGES]:     $webSocketExchangeManager");
    print("[WEBSOCKET SUBSCRIPTIONS]: $webSocketSubscriptionManager");
    print("--------------------------------------------------------------------------------\n");
  }

  /// Creates a callback function that converts a [http.Response] into an [JsonRpcResponse].
  /// 
  /// The [parse] callback function converts [http.Response]'s `result` value from type `U` into 
  /// `T`.
  FutureOr<JsonRpcResponse<T>> Function(http.Response) _responseParser<T, U>(
    final JsonRpcParser<T, U> parse,
  ) {
    return (final http.Response response) {
      //_debugResponse(response);
      final Map<String, dynamic> body = json.decode(response.body);
      final JsonRpcResponse<T> rpc = JsonRpcResponse.parse<T, U>(body, parse);
      return rpc.isSuccess ? Future.value(rpc) : Future.error(rpc.error!);
    };
  }

  /// Creates a callback function that converts a bulk [http.Response] into a [List] of 
  /// [JsonRpcResponse].
  /// 
  /// The [parseList] callback functions convert each [http.Response] `result` value from type `U` 
  /// into `T`.
  List<JsonRpcResponse> Function(http.Response) _bulkResponseParser(
    final List<JsonRpcParser> parseList,
  ) {
    assert(parseList.isNotEmpty);
    return (final http.Response response) {
      print('BULK REPONSE ${response.body}');
      final List<Map<String, dynamic>> body = List.from(json.decode(response.body));
      return List.generate(body.length, (final int i) {
        return JsonRpcResponse.parse(body[i], i < parseList.length ? parseList[i] : parseList.last);
      });
    };
  }

  /// Creates a callback function that converts the `body` of a `context response` into an 
  /// [JsonRpcContextResult].
  /// 
  /// The [parse] method converts context result's `value` property from type `U` into `T`.
  JsonRpcMapParser<JsonRpcContextResult<T>> _contextParser<T, U>(final JsonRpcParser<T, U> parse) {
    return (final Map<String, dynamic> body) => JsonRpcContextResult.parse(body, parse);
  }

  /// Creates a callback function that returns the [JsonRpcContextResult.value] of a `context response`.
  /// 
  /// The caller must ensure that [JsonRpcContextResult.value] will `not be null`.
  /// 
  /// The [parse] method converts context result's `value` property from type `U` into `T`.
  JsonRpcMapParser<T> _unwrapValueParser<T, U>(final JsonRpcParser<T, U> parse) {
    return (final Map<String, dynamic> body) => JsonRpcContextResult.parse(body, parse).value!;
  }

  /// Creates a callback function that converts a list returned by a [http.Response]'s into a list 
  /// of type T.
  /// 
  /// The [parse] method converts each item in the list from type `U` into `T`.
  JsonRpcListParser<T> _listParser<T, U>(final JsonRpcParser<T, U> parse) {
    return (final List items) => convert.list.decode(items, parse);
  }

  /// Makes a HTTP POST request to the [cluster].
  /// 
  /// The request's [body] can contain a single or [List] of method calls.
  /// 
  /// ```
  /// { method: 'getAccountInfo', ... }                                   // Single method call.
  /// ...
  /// [{ method: 'getAccountInfo', ... }, { method: 'getBalance', ... }]  // Multiple method calls.
  /// ```
  /// 
  /// The [config] object can be used to set the request's [JsonRpcRequestConfig.headers] and 
  /// [JsonRpcRequestConfig.timeout] duration.
  Future<http.Response> _post<T, U>(final Object body, { final JsonRpcRequestConfig? config }) {
    //_debugRequest(body);
    final Future<http.Response> request = client.post(
      cluster.http(),
      body: json.encode(body).codeUnits,
      headers: (config?.headers ?? const JsonRpcHttpHeaders()).toJson(),
    );
    final Duration? timeout = config?.timeout;
    return timeout != null ? request.timeout(timeout) : request;
  }

  /// Creates a list of ordered parameter values.
  List<Object> _buildParams(
    final List<Object> values,
    final JsonRpcRequestConfig config, [
    final Commitment? commitment,
  ]) {
    final Map<String, dynamic> object = config.object();
    const String commitmentKey = 'commitment';
    if (object.containsKey(commitmentKey)) {
      object[commitmentKey] ??= commitment?.name ?? this.commitment?.name;
      if (object[commitmentKey] == null) {
        object.remove(commitmentKey);
      }
    }
    return object.isEmpty ? values : [...values, object];
  }

  JsonRpcRequest _buildRequest(
    final Method method, 
    final List<Object> values, {
    required final JsonRpcRequestConfig config,
  }) {
    final List<Object> params = _buildParams(values, config);
    return JsonRpcRequest(method.name, params: params, id: config.id);
  }

  /// Makes a JSON-RPC POST request to the [cluster], invoking a single [method].
  /// 
  /// The [method] is invoked with the provided ordered parameter [values] and configurations (
  /// [JsonRpcRequestConfig.id] and [JsonRpcRequestConfig.object]).
  /// 
  /// The [parse] callback function is applied to the `result` value of a `success` response.
  /// 
  /// Additional request configurations can be set using the [config] object's 
  /// [JsonRpcRequestConfig.headers] and [JsonRpcRequestConfig.timeout] properties.
  Future<JsonRpcResponse<T>> _request<T, U>(
    final Method method, 
    final List<Object> values, 
    final JsonRpcParser<T, U> parse, {
    required final JsonRpcRequestConfig config,
  }) {
    final List<Object> params = _buildParams(values, config);
    final JsonRpcRequest request = JsonRpcRequest(method.name, params: params, id: config.id);
    return _post(request.toJson(), config: config).then(_responseParser(parse));
  }
  
  /// Makes a JSON-RPC POST request to the [cluster], invoking multiple methods in a single request.
  /// 
  /// Each of the [requests] defines a method to be invoked and their responses are handled by the 
  /// parser found at the same index position in [parseList]. If the number of [requests] exceeds 
  /// the number of parsers, the final parser in the list is applied.
  /// 
  /// Additional request configurations can be set using the [config] object's 
  /// [JsonRpcRequestConfig.headers] and [JsonRpcRequestConfig.timeout] properties.
  /// 
  /// ```
  /// _bulkRequest(
  ///   [JsonRpcRequest(...), JsonRpcRequest(...)], // The requests. 
  ///   [(Map) => int, (String) => List]            // The corresponding parsers.
  /// )
  /// ```
  Future<List<JsonRpcResponse>> _bulkRequest(
    final Iterable<JsonRpcRequest> requests, 
    final List<JsonRpcParser> parseList, {
    final JsonRpcRequestConfig? config,
  }) {
    assert(requests.isNotEmpty && parseList.isNotEmpty);
    Map<String, dynamic> _mapRequest(final JsonRpcRequest request) => request.toJson();
    final List<Map<String, dynamic>> jsonList = requests.map(_mapRequest).toList(growable: false);
    print('BULK REQUEST $jsonList');
    return _post(jsonList, config: config).then(_bulkResponseParser(parseList));
  }

  /// Get the [cluster]'s health status.
  Future<HealthStatus> health() async {
    final http.Response response = await client.get(cluster.http('health'));
    return HealthStatus.fromName(response.body);
  }

  /// Returns all information associated with the account of the provided [publicKey].
  Future<JsonRpcContextResponse<AccountInfo?>> getAccountInfoRaw(
    final PublicKey publicKey, {
    final GetAccountInfoConfig? config,
  }) {
    final parse = _contextParser(AccountInfo.tryParse);
    final defaultConfig = config ?? GetAccountInfoConfig();
    return _request(Method.getAccountInfo, [publicKey.toBase58()], parse, config: defaultConfig);
  }

  /// Returns all information associated with the account of the provided [publicKey].
  Future<AccountInfo?> getAccountInfo(
    final PublicKey publicKey, {
    final GetAccountInfoConfig? config,
  }) {
    return getAccountInfoRaw(publicKey, config: config).optional();
  }

  /// Returns the `lamports` balance of the account for the provided [publicKey].
  Future<JsonRpcContextResponse<u64>> getBalanceRaw(
    final PublicKey publicKey, {
    final GetBalanceConfig? config,
  }) {
    final parse = _contextParser(utils.cast<u64>);
    final defaultConfig = config ?? const GetBalanceConfig();
    return _request(Method.getBalance, [publicKey.toBase58()], parse, config: defaultConfig);
  }

  /// Returns the `lamports` balance of the account for the provided [publicKey].
  Future<u64> getBalance(
    final PublicKey publicKey, {
    final GetBalanceConfig? config,
  }) {
    return getBalanceRaw(publicKey, config: config).unwrap();
  }

  /// Returns identity and transaction information about a confirmed block at [slot] in the ledger.
  Future<JsonRpcResponse<Block?>> getBlockRaw(
    final u64 slot, {
    final GetBlockConfig? config,
  }) {
    assert(slot >= 0);
    final defaultConfig = config ?? GetBlockConfig(commitment: commitment); // asserts commitment.
    return _request(Method.getBlock, [slot], Block.tryFromJson, config: defaultConfig);
  }

  /// Returns identity and transaction information about a confirmed block at [slot] in the ledger.
  Future<Block?> getBlock(
    final u64 slot, {
    final GetBlockConfig? config,
  }) {
    return getBlockRaw(slot, config: config).optional();
  }

  /// Returns the current block height of the node.
  Future<JsonRpcResponse<u64>> getBlockHeightRaw({ final GetBlockHeightConfig? config }) {
    final defaultConfig = config ?? const GetBlockHeightConfig();
    return _request(Method.getBlockHeight, [], utils.cast<u64>, config: defaultConfig);
  }

  /// Returns the current block height of the node.
  Future<u64> getBlockHeight({ final GetBlockHeightConfig? config }) {
    return getBlockHeightRaw(config: config).unwrap();
  }

  /// Returns the recent block production information from the current or previous epoch.
  Future<JsonRpcContextResponse<BlockProduction>> getBlockProductionRaw({ 
    final GetBlockProductionConfig? config, 
  }) {
    final parse = _contextParser(BlockProduction.fromJson);
    final defaultConfig = config ?? const GetBlockProductionConfig();
    return _request(Method.getBlockProduction, [], parse, config: defaultConfig);
  }

  /// Returns the recent block production information from the current or previous epoch.
  Future<BlockProduction> getBlockProduction({ final GetBlockProductionConfig? config }) {
    return getBlockProductionRaw(config: config).unwrap();
  }

  /// Returns the commitment for a particular block (slot).
  Future<JsonRpcResponse<BlockCommitment>> getBlockCommitmentRaw(
    final u64 slot, { 
    final GetBlockCommitmentConfig? config, 
  }) {
    final defaultConfig = config ?? const GetBlockCommitmentConfig();
    return _request(Method.getBlockCommitment, [slot], BlockCommitment.fromJson, config: defaultConfig);
  }

  /// Returns the commitment for a particular block (slot).
  Future<BlockCommitment> getBlockCommitment(
    final u64 slot, { 
    final GetBlockCommitmentConfig? config, 
  }) {
    return getBlockCommitmentRaw(slot, config: config).unwrap();
  }

  /// Returns a list of confirmed blocks between two slots.
  Future<JsonRpcResponse<List<u64>>> getBlocksRaw(
    final u64 startSlot, { 
    final u64? endSlot,
    final GetBlocksConfig? config, 
  }) {
    final List<u64> params = endSlot != null ? [startSlot, endSlot] : [startSlot];
    final defaultConfig = config ?? GetBlocksConfig(commitment: commitment); // asserts commitment.
    return _request(Method.getBlocks, params, convert.list.cast<u64>, config: defaultConfig);
  }

  /// Returns a list of confirmed blocks between two slots.
  Future<List<u64>> getBlocks(
    final u64 startSlot, { 
    final u64? endSlot,
    final GetBlocksConfig? config, 
  }) {
    return getBlocksRaw(startSlot, endSlot: endSlot, config: config).unwrap();
  }

  /// Returns a list of [limit] confirmed blocks starting at the given [slot].
  Future<JsonRpcResponse<List<u64>>> getBlocksWithLimitRaw(
    final u64 slot, { 
    required final u64 limit,
    final GetBlocksWithLimitConfig? config, 
  }) {
    final defaultConfig = config ?? GetBlocksWithLimitConfig();
    return _request(Method.getBlocksWithLimit, [slot, limit], convert.list.cast<u64>, config: defaultConfig);
  }

  /// Returns a list of [limit] confirmed blocks starting at the given [slot].
  Future<List<u64>> getBlocksWithLimit(
    final u64 slot, { 
    required final u64 limit,
    final GetBlocksWithLimitConfig? config, 
  }) {
    return getBlocksWithLimitRaw(slot, limit: limit, config: config).unwrap();
  }

  /// Returns the estimated production time of a block.
  /// 
  /// Each validator reports their UTC time to the ledger on a regular interval by intermittently 
  /// adding a timestamp to a Vote for a particular block. A requested block's time is calculated 
  /// from the stake-weighted mean of the Vote timestamps in a set of recent blocks recorded on the 
  /// ledger.
  Future<JsonRpcResponse<i64?>> getBlockTimeRaw(
    final u64 slot, {
    final GetBlockTimeConfig? config,
  }) {
    final defaultConfig = config ?? const GetBlockTimeConfig();
    return _request(Method.getBlockTime, [slot], utils.cast<i64?>, config: defaultConfig);
  }

  /// Returns the estimated production time of a block.
  /// 
  /// Each validator reports their UTC time to the ledger on a regular interval by intermittently 
  /// adding a timestamp to a Vote for a particular block. A requested block's time is calculated 
  /// from the stake-weighted mean of the Vote timestamps in a set of recent blocks recorded on the 
  /// ledger.
  Future<i64?> getBlockTime(
    final u64 slot, {
    final GetBlockTimeConfig? config,
  }) {
    return getBlockTimeRaw(slot, config: config).optional();
  }

  /// Returns information about all the nodes participating in the cluster.
  Future<JsonRpcResponse<List<ClusterNode>>> getClusterNodesRaw({ 
    final GetClusterNodesConfig? config, 
  }) {
    final parse = _listParser(ClusterNode.fromJson);
    final defaultConfig = config ?? const GetClusterNodesConfig();
    return _request(Method.getClusterNodes, [], parse, config: defaultConfig);
  }

  /// Returns information about all the nodes participating in the cluster.
  Future<List<ClusterNode>> getClusterNodes({ final GetBlockTimeConfig? config }) {
    return getClusterNodesRaw(config: config).unwrap();
  }

  /// Returns information about the current epoch.
  Future<JsonRpcResponse<EpochInfo>> getEpochInfoRaw({ final GetEpochInfoConfig? config }) {
    final defaultConfig = config ?? const GetEpochInfoConfig();
    return _request(Method.getEpochInfo, [], EpochInfo.fromJson, config: defaultConfig);
  }

  /// Returns information about the current epoch.
  Future<EpochInfo> getEpochInfo({ final GetEpochInfoConfig? config }) {
    return getEpochInfoRaw(config: config).unwrap();
  }

  /// Returns the epoch schedule information from the cluster's genesis config.
  Future<JsonRpcResponse<EpochSchedule>> getEpochScheduleRaw({ final GetEpochScheduleConfig? config }) {
    final defaultConfig = config ?? const GetEpochScheduleConfig();
    return _request(Method.getEpochSchedule, [], EpochSchedule.fromJson, config: defaultConfig);
  }

  /// Returns the epoch schedule information from the cluster's genesis config.
  Future<EpochSchedule> getEpochSchedule({ final GetEpochScheduleConfig? config }) {
    return getEpochScheduleRaw(config: config).unwrap();
  }

  /// Returns the network fee that will be charged to send [message].
  /// 
  /// TODO: Find out if a `null` return value means zero.
  Future<JsonRpcContextResponse<u64?>> getFeeForMessageRaw(
    final Message message, {
    final GetFeeForMessageConfig? config,
  }) {
    final parse = _contextParser(utils.cast<u64?>);
    final String encoded = message.serialize().getString(BufferEncoding.base64);
    final defaultConfig = config ?? const GetFeeForMessageConfig();
    return _request(Method.getFeeForMessage, [encoded], parse, config: defaultConfig);
  }

  /// Returns the network fee that will be charged to send [message].
  Future<u64> getFeeForMessage(
    final Message message, {
    final GetFeeForMessageConfig? config,
  }) async {
    final u64? fee = await getFeeForMessageRaw(message, config: config).unwrap();
    return fee != null ? Future.value(fee) : Future.error(const JsonRpcException('Invalid fee.'));
  }

  /// Returns the slot of the lowest confirmed block that has not been purged from the ledger.
  Future<JsonRpcResponse<u64>> getFirstAvailableBlockRaw({ 
    final GetFirstAvailableBlockConfig? config, 
  }) {
    final defaultConfig = config ?? const GetFirstAvailableBlockConfig();
    return _request(Method.getFirstAvailableBlock, [], utils.cast<u64>, config: defaultConfig);
  }

  /// Returns the slot of the lowest confirmed block that has not been purged from the ledger.
  Future<u64> getFirstAvailableBlock({ 
    final GetFirstAvailableBlockConfig? config, 
  }) {
    return getFirstAvailableBlockRaw(config: config).unwrap();
  }

  /// Returns the genesis hash.
  Future<JsonRpcResponse<String>> getGenesisHashRaw({ 
    final GetGenesisHashConfig? config, 
  }) {
    final defaultConfig = config ?? const GetGenesisHashConfig();
    return _request(Method.getGenesisHash, [], utils.cast<String>, config: defaultConfig);
  }

  /// Returns the genesis hash.
  Future<String> getGenesisHash({ 
    final GetGenesisHashConfig? config, 
  }) {
    return getGenesisHashRaw(config: config).unwrap();
  }

  /// Returns the current health of the node.
  /// 
  /// If one or more --known-validator arguments are provided to solana-validator, "ok" is returned 
  /// when the node has within HEALTH_CHECK_SLOT_DISTANCE slots of the highest known validator, 
  /// otherwise an error is returned. "ok" is always returned if no known validators are provided.
  Future<JsonRpcResponse<HealthStatus>> getHealthRaw({ 
    final GetHealthConfig? config, 
  }) {
    final defaultConfig = config ?? const GetHealthConfig();
    return _request(Method.getHealth, [], HealthStatus.fromName, config: defaultConfig);
  }

  /// Returns the current health of the node.
  /// 
  /// If one or more --known-validator arguments are provided to solana-validator, "ok" is returned 
  /// when the node has within HEALTH_CHECK_SLOT_DISTANCE slots of the highest known validator, 
  /// otherwise an error is returned. "ok" is always returned if no known validators are provided.
  Future<HealthStatus> getHealth({ 
    final GetHealthConfig? config, 
  }) {
    return getHealthRaw(config: config).unwrap();
  }

  /// Returns the highest slot information that the node has snapshots for.
  /// 
  /// This will find the highest full snapshot slot, and the highest incremental snapshot slot based 
  /// on the full snapshot slot, if there is one.
  Future<JsonRpcResponse<HighestSnapshotSlot>> getHighestSnapshotSlotRaw({ 
    final GetHighestSnapshotSlotConfig? config, 
  }) {
    final defaultConfig = config ?? const GetHighestSnapshotSlotConfig();
    return _request(Method.getHighestSnapshotSlot, [], HighestSnapshotSlot.fromJson, config: defaultConfig);
  }

  /// Returns the highest slot information that the node has snapshots for.
  /// 
  /// This will find the highest full snapshot slot, and the highest incremental snapshot slot based 
  /// on the full snapshot slot, if there is one.
  Future<HighestSnapshotSlot> getHighestSnapshotSlot({ 
    final GetHighestSnapshotSlotConfig? config, 
  }) {
    return getHighestSnapshotSlotRaw(config: config).unwrap();
  }

  /// Returns the identity pubkey for the current node.
  Future<JsonRpcResponse<Identity>> getIdentityRaw({ 
    final GetIdentityConfig? config, 
  }) {
    final defaultConfig = config ?? const GetIdentityConfig();
    return _request(Method.getIdentity, [], Identity.fromJson, config: defaultConfig);
  }

  /// Returns the identity pubkey for the current node.
  Future<Identity> getIdentity({ 
    final GetIdentityConfig? config, 
  }) {
    return getIdentityRaw(config: config).unwrap();
  }

  /// Returns the current inflation governor.
  Future<JsonRpcResponse<InflationGovernor>> getInflationGovernorRaw({ 
    final GetInflationGovernorConfig? config, 
  }) {
    final defaultConfig = config ?? const GetInflationGovernorConfig();
    return _request(Method.getInflationGovernor, [], InflationGovernor.fromJson, config: defaultConfig);
  }

  /// Returns the current inflation governor.
  Future<InflationGovernor> getInflationGovernor({ 
    final GetInflationGovernorConfig? config, 
  }) {
    return getInflationGovernorRaw(config: config).unwrap();
  }

  /// Returns the specific inflation values for the current epoch.
  Future<JsonRpcResponse<InflationRate>> getInflationRateRaw({ 
    final GetInflationRateConfig? config, 
  }) {
    final defaultConfig = config ?? const GetInflationRateConfig();
    return _request(Method.getInflationRate, [], InflationRate.fromJson, config: defaultConfig);
  }

  /// Returns the specific inflation values for the current epoch.
  Future<InflationRate> getInflationRate({ 
    final GetInflationRateConfig? config, 
  }) {
    return getInflationRateRaw(config: config).unwrap();
  }

  /// Returns the inflation / staking reward for a list of [addresses] for an epoch.
  Future<JsonRpcResponse<List<InflationReward?>>> getInflationRewardRaw(
    final Iterable<PublicKey> addresses, { 
    final GetInflationRewardConfig? config, 
  }) {
    final pubKeys = addresses.map((final PublicKey address) => address.toBase58()).toList(growable: false);
    final parse = _listParser(InflationReward.tryFromJson);
    final defaultConfig = config ?? const GetInflationRewardConfig();
    return _request(Method.getInflationReward, [pubKeys], parse, config: defaultConfig);
  }

  /// Returns the inflation / staking reward for a list of [addresses] for an epoch.
  Future<List<InflationReward?>> getInflationReward(
    final Iterable<PublicKey> addresses, { 
    final GetInflationRewardConfig? config, 
  }) {
    return getInflationRewardRaw(addresses, config: config).unwrap();
  }

  /// Returns the 20 largest accounts, by lamport balance (results may be cached up to two hours).
  Future<JsonRpcContextResponse<List<LargeAccount>>> getLargestAccountsRaw({ 
    final GetLargestAccountsConfig? config, 
  }) {
    parse(result) => JsonRpcContextResult.parse(result, _listParser(LargeAccount.fromJson));
    final defaultConfig = config ?? const GetLargestAccountsConfig();
    return _request(Method.getLargestAccounts, [], parse, config: defaultConfig);
  }

  /// Returns the 20 largest accounts, by lamport balance (results may be cached up to two hours).
  Future<List<LargeAccount>> getLargestAccounts({ 
    final GetLargestAccountsConfig? config, 
  }) {
    return getLargestAccountsRaw(config: config).unwrap();
  }

  /// Returns the latest blockhash.
  Future<JsonRpcContextResponse<BlockhashWithExpiryBlockHeight>> getLatestBlockhashRaw({
    final GetLatestBlockhashConfig? config,
  }) {
    final parser = _contextParser(BlockhashWithExpiryBlockHeight.fromJson);
    final defaultConfig = config ?? const GetLatestBlockhashConfig();
    return _request(Method.getLatestBlockhash, [], parser, config: defaultConfig);
  }

  /// Returns the latest blockhash.
  Future<BlockhashWithExpiryBlockHeight> getLatestBlockhash({
    final GetLatestBlockhashConfig? config,
  }) {
    return getLatestBlockhashRaw(config: config).unwrap();
  }

  /// Returns the leader schedule for an epoch.
  /// 
  /// The leader schedule with be fetched for the epoch that corresponds to the provided [slot]. If 
  /// omitted, the leader schedule for the current epoch is fetched.
  Future<JsonRpcResponse<Map<String, List>?>> getLeaderScheduleRaw({
    final u64? slot,
    final GetLeaderScheduleConfig? config,
  }) {
    final List<Object> params = slot != null ? [slot] : [];
    Map<String, List>? parse(final Map? result) => result != null ? Map.castFrom(result) : null;
    final defaultConfig = config ?? const GetLeaderScheduleConfig();
    return _request(Method.getLeaderSchedule, params, parse, config: defaultConfig);
  }

  /// Returns the leader schedule for an epoch.
  /// 
  /// The leader schedule with be fetched for the epoch that corresponds to the provided [slot]. If 
  /// omitted, the leader schedule for the current epoch is fetched.
  Future<Map<String, List>?> getLeaderSchedule({
    final u64? slot,
    final GetLeaderScheduleConfig? config,
  }) {
    return getLeaderScheduleRaw(slot: slot, config: config).unwrap();
  }

  /// Returns the max slot seen from retransmit stage.
  Future<JsonRpcResponse<u64>> getMaxRetransmitSlotRaw({
    final GetMaxRetransmitSlotConfig? config,
  }) {
    final defaultConfig = config ?? const GetMaxRetransmitSlotConfig();
    return _request(Method.getMaxRetransmitSlot, [], utils.cast<u64>, config: defaultConfig);
  }

  /// Returns the max slot seen from retransmit stage.
  Future<u64> getMaxRetransmitSlot({
    final GetMaxRetransmitSlotConfig? config,
  }) {
    return getMaxRetransmitSlotRaw(config: config).unwrap();
  }

  /// Returns the max slot seen from after shred insert.
  Future<JsonRpcResponse<u64>> getMaxShredInsertSlotRaw({
    final GetMaxShredInsertSlotConfig? config,
  }) {
    final defaultConfig = config ?? const GetMaxShredInsertSlotConfig();
    return _request(Method.getMaxShredInsertSlot, [], utils.cast<u64>, config: defaultConfig);
  }

  /// Returns the max slot seen from after shred insert.
  Future<u64> getMaxShredInsertSlot({
    final GetMaxShredInsertSlotConfig? config,
  }) {
    return getMaxShredInsertSlotRaw(config: config).unwrap();
  }

  /// Returns the minimum balance required to make an account of size [length] rent exempt.
  Future<JsonRpcResponse<u64>> getMinimumBalanceForRentExemptionRaw(
    final int length, {
    final GetMinimumBalanceForRentExemptionConfig? config,
  }) {
    final defaultConfig = config ?? const GetMinimumBalanceForRentExemptionConfig();
    return _request(Method.getMinimumBalanceForRentExemption, [length], utils.cast<u64>, config: defaultConfig);
  }

  /// Returns the minimum balance required to make an account of size [length] rent exempt.
  Future<u64> getMinimumBalanceForRentExemption(
    final int length, {
    final GetMinimumBalanceForRentExemptionConfig? config,
  }) {
    return getMinimumBalanceForRentExemptionRaw(length, config: config).unwrap();
  }

  /// Returns the account information for a list of Pubkeys.
  Future<JsonRpcContextResponse<List<AccountInfo?>>> getMultipleAccountsRaw(
    final List<PublicKey> accounts, {
    final GetMultipleAccountsConfig? config,
  }) {
    utils.check(accounts.length <= 100, 'getMultipleAccounts() can fetch up to a maximum of 100.');
    parse(result) => JsonRpcContextResult.parse(result, _listParser(AccountInfo.tryParse));
    final pubKeys = accounts.map((final PublicKey account) => account.toBase58()).toList(growable: false);
    final defaultConfig = config ?? GetMultipleAccountsConfig();
    return _request(Method.getMultipleAccounts, [pubKeys], parse, config: defaultConfig);
  }

  /// Returns the account information for a list of Pubkeys.
  Future<List<AccountInfo?>> getMultipleAccounts(
    final List<PublicKey> accounts, {
    final GetMultipleAccountsConfig? config,
  }) {
    return getMultipleAccountsRaw(accounts, config: config).unwrap();
  }

  /// Returns all accounts owned by the provided program Pubkey.
  Future<JsonRpcResponse<List<ProgramAccount>>> getProgramAccountsRaw(
    final PublicKey program, {
    final GetProgramAccountsConfig? config,
  }) {
    final parse = _listParser(ProgramAccount.parse);
    final defaultConfig = config ?? GetProgramAccountsConfig();
    return _request(Method.getProgramAccounts, [program.toBase58()], parse, config: defaultConfig);
  }

  /// Returns all accounts owned by the provided program Pubkey.
  Future<List<ProgramAccount>> getProgramAccounts(
    final PublicKey program, {
    final GetProgramAccountsConfig? config,
  }) {
    return getProgramAccountsRaw(program, config: config).unwrap();
  }

  /// Returns a list of recent performance samples, in reverse slot order. Performance samples are 
  /// taken every 60 seconds and include the number of transactions and slots that occur in a given 
  /// time window.
  Future<JsonRpcResponse<List<PerformanceSample>>> getRecentPerformanceSamplesRaw({
    final usize? limit,
    final GetRecentPerformanceSamplesConfig? config,
  }) {
    final List<Object> params = limit != null ? [limit] : [];
    final parse = _listParser(PerformanceSample.fromJson);
    final defaultConfig = config ?? const GetRecentPerformanceSamplesConfig();
    return _request(Method.getRecentPerformanceSamples, params, parse, config: defaultConfig);
  }

  /// Returns a list of recent performance samples, in reverse slot order. Performance samples are 
  /// taken every 60 seconds and include the number of transactions and slots that occur in a given 
  /// time window.
  Future<List<PerformanceSample>> getRecentPerformanceSamples({
    final usize? limit,
    final GetRecentPerformanceSamplesConfig? config,
  }) {
    return getRecentPerformanceSamplesRaw(limit: limit, config: config).unwrap();
  }

  /// Returns signatures for confirmed transactions that include the given address in their 
  /// accountKeys list. Returns signatures backwards in time from the provided signature or most 
  /// recent confirmed block.
  Future<JsonRpcResponse<List<ConfirmedSignatureInfo>>> getSignaturesForAddressRaw(
    final PublicKey address, {
    final GetSignaturesForAddressConfig? config,
  }) {
    final parse = _listParser(ConfirmedSignatureInfo.fromJson);
    final defaultConfig = config ?? const GetSignaturesForAddressConfig();
    return _request(Method.getSignaturesForAddress, [address.toBase58()], parse, config: defaultConfig);
  }

  /// Returns signatures for confirmed transactions that include the given address in their 
  /// accountKeys list. Returns signatures backwards in time from the provided signature or most 
  /// recent confirmed block.
  Future<List<ConfirmedSignatureInfo>> getSignaturesForAddress(
    final PublicKey address, {
    final GetSignaturesForAddressConfig? config,
  }) {
    return getSignaturesForAddressRaw(address, config: config).unwrap();
  }

  /// Returns the statuses of a list of signatures. 
  /// 
  /// Unless the [GetSignatureStatusesConfig.searchTransactionHistory] configuration parameter is 
  /// set to `true`, this method only searches the recent status cache of signatures, which retains 
  /// statuses for all active slots plus MAX_RECENT_BLOCKHASHES rooted slots.
  Future<JsonRpcContextResponse<List<SignatureStatus?>>> getSignatureStatusesRaw(
    final List<String> signatures, {
    final GetSignatureStatusesConfig? config,
  }) {
    parse(result) => JsonRpcContextResult.parse(result, _listParser(SignatureStatus.tryFromJson));
    final defaultConfig = config ?? const GetSignatureStatusesConfig();
    return _request(Method.getSignatureStatuses, [signatures], parse, config: defaultConfig);
  }

  /// Returns the statuses of a list of signatures. 
  /// 
  /// Unless the [GetSignatureStatusesConfig.searchTransactionHistory] configuration parameter is 
  /// set to `true`, this method only searches the recent status cache of signatures, which retains 
  /// statuses for all active slots plus MAX_RECENT_BLOCKHASHES rooted slots.
  Future<List<SignatureStatus?>> getSignatureStatuses(
    final List<String> signatures, {
    final GetSignatureStatusesConfig? config,
  }) {
    return getSignatureStatusesRaw(signatures, config: config).unwrap();
  }

  /// Returns the slot that has reached the given or default [GetSlotConfig.commitment] level.
  Future<JsonRpcResponse<u64>> getSlotRaw({ final GetSlotConfig? config }) {
    final defaultConfig = config ?? const GetSlotConfig();
    return _request(Method.getSlot, [], utils.cast<u64>, config: defaultConfig);
  }

  /// Returns the slot that has reached the given or default [GetSlotConfig.commitment] level.
  Future<u64> getSlot({ final GetSlotConfig? config }) {
    return getSlotRaw(config: config).unwrap();
  }

  /// Returns the current slot leader.
  Future<JsonRpcResponse<PublicKey>> getSlotLeaderRaw({ final GetSlotLeaderConfig? config }) {
    final defaultConfig = config ?? const GetSlotLeaderConfig();
    return _request(Method.getSlotLeader, [], PublicKey.fromBase58, config: defaultConfig);
  }

  /// Returns the current slot leader.
  Future<PublicKey> getSlotLeader({ final GetSlotLeaderConfig? config }) {
    return getSlotLeaderRaw(config: config).unwrap();
  }

  /// Returns the slot leaders for a given slot range.
  Future<JsonRpcResponse<List<PublicKey>>> getSlotLeadersRaw({ 
    required final u64 start,
    required final u64 limit,
    final GetSlotLeadersConfig? config, 
  }) {
    final parse = _listParser(PublicKey.fromBase58);
    final defaultConfig = config ?? const GetSlotLeadersConfig();
    return _request(Method.getSlotLeaders, [start, limit], parse, config: defaultConfig);
  }

  /// Returns the slot leaders for a given slot range.
  Future<List<PublicKey>> getSlotLeaders({ 
    required final u64 start,
    required final u64 limit,
    final GetSlotLeadersConfig? config, 
  }) {
    return getSlotLeadersRaw(start: start, limit: limit, config: config).unwrap();
  }

  /// Returns epoch activation information for a stake account.
  Future<JsonRpcResponse<StakeActivation>> getStakeActivationRaw(
    final PublicKey account, {
    final GetStakeActivationConfig? config, 
  }) {
    final defaultConfig = config ?? const GetStakeActivationConfig();
    return _request(Method.getStakeActivation, [account.toBase58()], StakeActivation.fromJson, config: defaultConfig);
  }

  /// Returns epoch activation information for a stake account.
  Future<StakeActivation> getStakeActivation(
    final PublicKey account, {
    final GetStakeActivationConfig? config, 
  }) {
    return getStakeActivationRaw(account, config: config).unwrap();
  }

  /// Returns information about the current supply.
  Future<JsonRpcContextResponse<Supply>> getSupplyRaw({
    final GetSupplyConfig? config, 
  }) {
    parse(result) => JsonRpcContextResult.parse(result, Supply.fromJson);
    final defaultConfig = config ?? const GetSupplyConfig();
    return _request(Method.getSupply, [], parse, config: defaultConfig);
  }

  /// Returns information about the current supply.
  Future<Supply> getSupply({
    final GetSupplyConfig? config, 
  }) {
    return getSupplyRaw(config: config).unwrap();
  }

  /// Returns the token balance of an SPL Token [account].
  Future<JsonRpcContextResponse<TokenAmount>> getTokenAccountBalanceRaw(
    final PublicKey account, {
    final GetTokenAccountBalanceConfig? config, 
  }) {
    parse(result) => JsonRpcContextResult.parse(result, TokenAmount.fromJson);
    final defaultConfig = config ?? const GetTokenAccountBalanceConfig();
    return _request(Method.getTokenAccountBalance, [account.toBase58()], parse, config: defaultConfig);
  }

  /// Returns the token balance of an SPL Token [account].
  Future<TokenAmount> getTokenAccountBalance(
    final PublicKey account, {
    final GetTokenAccountBalanceConfig? config, 
  }) {
    return getTokenAccountBalanceRaw(account, config: config).unwrap();
  }

  /// Returns all SPL Token accounts approved by [delegate].
  Future<JsonRpcContextResponse<List<TokenAccount>>> getTokenAccountsByDelegateRaw(
    final PublicKey delegate, {
    required final TokenAccountsFilter filter,
    final GetTokenAccountsByDelegateConfig? config, 
  }) {
    final params = [delegate.toBase58(), filter.toJson()];
    parse(result) => JsonRpcContextResult.parse(result, _listParser(TokenAccount.fromJson));
    final defaultConfig = config ?? GetTokenAccountsByDelegateConfig();
    return _request(Method.getTokenAccountsByDelegate, params, parse, config: defaultConfig);
  }

  /// Returns all SPL Token accounts approved by [delegate].
  Future<List<TokenAccount>> getTokenAccountsByDelegate(
    final PublicKey delegate, {
    required final TokenAccountsFilter filter,
    final GetTokenAccountsByDelegateConfig? config, 
  }) {
    return getTokenAccountsByDelegateRaw(delegate, filter: filter, config: config).unwrap();
  }

  /// Returns the token owner of an SPL Token [account].
  Future<JsonRpcContextResponse<List<TokenAccount>>> getTokenAccountsByOwnerRaw(
    final PublicKey account, {
    required final TokenAccountsFilter filter,
    final GetTokenAccountsByOwnerConfig? config, 
  }) {
    final params = [account.toBase58(), filter.toJson()];
    parse(result) => JsonRpcContextResult.parse(result, _listParser(TokenAccount.fromJson));
    final defaultConfig = config ?? GetTokenAccountsByOwnerConfig();
    return _request(Method.getTokenAccountsByOwner, params, parse, config: defaultConfig);
  }

  /// Returns the token owner of an SPL Token [account].
  Future<List<TokenAccount>> getTokenAccountsByOwner(
    final PublicKey account, {
    required final TokenAccountsFilter filter,
    final GetTokenAccountsByOwnerConfig? config, 
  }) {
    return getTokenAccountsByOwnerRaw(account, filter: filter, config: config).unwrap();
  }

  /// Returns the 20 largest accounts of a particular SPL Token type.
  Future<JsonRpcContextResponse<List<TokenAmount>>> getTokenLargestAccountsRaw(
    final PublicKey mint, {
    final GetTokenLargestAccountsConfig? config, 
  }) {
    parse(result) => JsonRpcContextResult.parse(result, _listParser(TokenAmount.fromJson));
    final defaultConfig = config ?? const GetTokenLargestAccountsConfig();
    return _request(Method.getTokenLargestAccounts, [mint.toBase58()], parse, config: defaultConfig);
  }

  /// Returns the 20 largest accounts of a particular SPL Token type.
  Future<List<TokenAmount>> getTokenLargestAccounts(
    final PublicKey mint, {
    final GetTokenLargestAccountsConfig? config, 
  }) {
    return getTokenLargestAccountsRaw(mint, config: config).unwrap();
  }

  /// Returns the total supply of an SPL Token type.
  Future<JsonRpcContextResponse<TokenAmount>> getTokenSupplyRaw(
    final PublicKey mint, {
    final GetTokenSupplyConfig? config, 
  }) {
    parse(result) => JsonRpcContextResult.parse(result, TokenAmount.fromJson);
    final defaultConfig = config ?? const GetTokenSupplyConfig();
    return _request(Method.getTokenSupply, [mint.toBase58()], parse, config: defaultConfig);
  }

  /// Returns the total supply of an SPL Token type.
  Future<TokenAmount> getTokenSupply(
    final PublicKey mint, {
    final GetTokenSupplyConfig? config, 
  }) {
    return getTokenSupplyRaw(mint, config: config).unwrap();
  }

  /// Returns transaction details for a confirmed transaction signature (base-58).
  Future<JsonRpcResponse<TransactionInfo?>> getTransactionRaw(
    final String signature, {
    final GetTransactionConfig? config, 
  }) {
    final defaultConfig = config ?? GetTransactionConfig();
    return _request(Method.getTransaction, [signature], TransactionInfo.tryParse, config: defaultConfig);
  }

  /// Returns transaction details for a confirmed transaction signature (base-58).
  Future<TransactionInfo?> getTransaction(
    final String signature, {
    final GetTransactionConfig? config, 
  }) {
    return getTransactionRaw(signature, config: config).unwrap();
  }

  /// Returns the current [Transaction] count from the ledger.
  Future<JsonRpcResponse<u64>> getTransactionCountRaw({
    final GetTransactionCountConfig? config, 
  }) {
    final defaultConfig = config ?? GetTransactionCountConfig(commitment: commitment); // asserts commitment.
    return _request(Method.getTransactionCount, [], utils.cast<u64>, config: defaultConfig);
  }

  /// Returns the current [Transaction] count from the ledger.
  Future<u64> getTransactionCount({
    final GetTransactionCountConfig? config, 
  }) {
    return getTransactionCountRaw(config: config).unwrap();
  }

  /// Returns the current solana versions running on the node.
  Future<JsonRpcResponse<Version>> getVersionRaw({
    final GetVersionConfig? config, 
  }) {
    final defaultConfig = config ?? const GetVersionConfig();
    return _request(Method.getVersion, [], Version.fromJson, config: defaultConfig);
  }

  /// Returns the current solana versions running on the node.
  Future<Version> getVersion({
    final GetVersionConfig? config, 
  }) {
    return getVersionRaw(config: config).unwrap();
  }

  /// Returns the account info and associated stake for all the voting accounts in the current bank.
  Future<JsonRpcResponse<VoteAccountStatus>> getVoteAccountsRaw({
    final GetVoteAccountsConfig? config, 
  }) {
    final defaultConfig = config ?? const GetVoteAccountsConfig();
    return _request(Method.getVoteAccounts, [], VoteAccountStatus.fromJson, config: defaultConfig);
  }

  /// Returns the account info and associated stake for all the voting accounts in the current bank.
  Future<VoteAccountStatus> getVoteAccounts({
    final GetVoteAccountsConfig? config, 
  }) {
    return getVoteAccountsRaw(config: config).unwrap();
  }

  /// Returns whether a [blockhash] (base-58) is still valid or not.
  Future<JsonRpcContextResponse<bool>> isBlockhashValidRaw(
    final String blockhash, {
    final IsBlockhashValidConfig? config, 
  }) {
    parse(result) => JsonRpcContextResult.parse(result, utils.cast<bool>);
    final defaultConfig = config ?? const IsBlockhashValidConfig();
    return _request(Method.isBlockhashValid, [blockhash], parse, config: defaultConfig);
  }

  /// Returns whether a [blockhash] (base-58) is still valid or not.
  Future<bool> isBlockhashValid(
    final String blockhash, {
    final IsBlockhashValidConfig? config, 
  }) {
    return isBlockhashValidRaw(blockhash, config: config).unwrap();
  }

  /// Returns the lowest slot that the node has information about in its ledger. This value may 
  /// increase over time if the node is configured to purge older ledger data.
  Future<JsonRpcResponse<u64>> minimumLedgerSlotRaw({
    final MinimumLedgerSlotConfig? config, 
  }) {
    final defaultConfig = config ?? const MinimumLedgerSlotConfig();
    return _request(Method.minimumLedgerSlot, [], utils.cast<u64>, config: defaultConfig);
  }

  /// Returns the lowest slot that the node has information about in its ledger. This value may 
  /// increase over time if the node is configured to purge older ledger data.
  Future<u64> minimumLedgerSlot({
    final MinimumLedgerSlotConfig? config, 
  }) {
    return minimumLedgerSlotRaw(config: config).unwrap();
  }

  /// Requests an airdrop of [lamports] to [publicKey].
  /// 
  /// Returns the transaction signature as a base-58 encoded string.
  Future<JsonRpcResponse<String>> requestAirdropRaw(
    final PublicKey publicKey, 
    final u64 lamports, {
    final RequestAirdropConfig? config,
  }) {
    final defaultConfig = config ?? const RequestAirdropConfig();
    return _request(Method.requestAirdrop, [publicKey.toBase58(), lamports], utils.cast<String>, config: defaultConfig);
  }

  /// Requests an airdrop of [lamports] to [publicKey].
  /// 
  /// Returns the transaction signature as a base-58 encoded string.
  Future<String> requestAirdrop(
    final PublicKey publicKey, 
    final u64 lamports, {
    final RequestAirdropConfig? config,
  }) {
    return requestAirdropRaw(publicKey, lamports, config: config).unwrap();
  }

  /// Requests an airdrop of [lamports] to [publicKey] and wait for transaction confirmation.
  /// 
  /// Returns the transaction signature as a base-58 encoded string.
  Future<TransactionSignature> requestAirdropAndConfirmTransaction(
    final PublicKey publicKey, 
    final u64 lamports, {
    final CommitmentConfig? config,
  }) async {
    final TransactionSignature signature = await requestAirdrop(publicKey, lamports, config: config);
    final SignatureNotification notification = await confirmTransaction(signature, config: config);
    return notification.err != null ? Future.error(notification.err) : Future.value(signature);
  }

  /// Sign and send a [transaction] to the cluster for processing.
  Future<JsonRpcResponse<TransactionSignature>> sendTransactionRaw(
    Transaction transaction, {
    final List<Signer> signers = const [],
    SendTransactionConfig? config,
  }) async {
    if (transaction.nonceInfo != null) {
      transaction.sign(signers);
    } else {
      bool disableCache = false;
      for (;;) {
        final latestBlockhash = await _blockhashCache.get(this, disabled: disableCache);
        transaction = transaction.copyWith(
          recentBlockhash: latestBlockhash.blockhash,
          lastValidBlockHeight: latestBlockhash.lastValidBlockHeight,
        );

        transaction.sign(signers);
        final Uint8List? payerSignature = transaction.signature;
        if (payerSignature == null) {
          throw const TransactionException('No signature.'); // should never happen
        }

        final String signature = base64.encode(payerSignature);
        if (!_blockhashCache.transactionSignatures.contains(signature)) {
          // The signature of this transaction has not been seen before with the current 
          // [latestBlockhash.blockhash], all done. Let's break
          _blockhashCache.transactionSignatures.add(signature);
          break;
        } else {
          // This transaction would be treated as duplicate (its derived signature matched to one of 
          // the already recorded signatures). So, we must fetch a new blockhash for a different 
          // signature by disabling our cache not to wait for the cache expiration 
          // [BlockhashCache.timeout].
          disableCache = true;
        }
      }
    }

    final defaultConfig = config ?? SendTransactionConfig(preflightCommitment: commitment); 
    final BufferEncoding bufferEncoding = BufferEncoding.fromName(defaultConfig.encoding.name);
    final String signedTransaction = transaction.serialize().getString(bufferEncoding);
    return sendSignedTransactionRaw(signedTransaction, config: config);
  }

  /// Sign and send a [transaction] to the cluster for processing.
  Future<TransactionSignature> sendTransaction(
    final Transaction transaction, {
    final List<Signer> signers = const [],
    final SendTransactionConfig? config,
  }) async {
    return sendTransactionRaw(transaction, signers: signers, config: config).unwrap();
  }

  /// Send a signed [Transaction] to the cluster for processing.
  Future<JsonRpcResponse<TransactionSignature>> sendSignedTransactionRaw(
    final String signedTransaction, {
    final SendTransactionConfig? config,
  }) async {
    final defaultConfig = config ?? SendTransactionConfig(preflightCommitment: commitment); 
    return _request(Method.sendTransaction, [signedTransaction], utils.cast<String>, config: defaultConfig);
  }

    /// Send a signed [Transaction] to the cluster for processing.
  Future<TransactionSignature> sendSignedTransaction(
    final String signedTransaction, {
    final SendTransactionConfig? config,
  }) {
    return sendSignedTransactionRaw(signedTransaction, config: config).unwrap();
  }
  
  /// Send the signed [Transaction]s to the cluster for processing.
  Future<List<JsonRpcResponse>> sendSignedTransactionsRaw(
    final List<String> signedTransactions, {
    final SendTransactionConfig? config,
  }) async {
    final defaultConfig = config ?? SendTransactionConfig(preflightCommitment: commitment);
    final List<JsonRpcRequest> requests = signedTransactions.map((final String signedTransaction) {
      return _buildRequest(Method.sendTransaction, [signedTransaction], config: defaultConfig);
    }).toList(growable: false);
    return _bulkRequest(requests, [(r) => r]);
  }

  // Future<List<String>> walletAdapterSerialization(final List<Transaction> transactions) async {
  //   final latestBlockhash = await _blockhashCache.get(this, disabled: true);
  //   return transactions.map(
  //     (final Transaction transaction) => transaction.copyWith(
  //       recentBlockhash: latestBlockhash.blockhash,
  //       lastValidBlockHeight: latestBlockhash.lastValidBlockHeight,
  //     ).serialize(
  //       const SerializeConfig(
  //         requireAllSignatures: false,
  //         verifySignatures: false,
  //       ),
  //     ).getString(
  //       BufferEncoding.base64,
  //     ),
  //   ).toList(
  //     growable: false,
  //   );
  // }

  // Future<List<String>> walletAdapterMessageSerialization(final List<Transaction> transactions) async {
  //   final latestBlockhash = await _blockhashCache.get(this, disabled: true);
  //   return transactions.map(
  //     (final Transaction transaction) => transaction.copyWith(
  //       recentBlockhash: latestBlockhash.blockhash,
  //       lastValidBlockHeight: latestBlockhash.lastValidBlockHeight,
  //     ).serializeMessage(
  //     ).getString(
  //       BufferEncoding.base64,
  //     ),
  //   ).toList(growable: false);
  // }

  // Future<SignTransactionsResult> signTransactions(
  //   final JsonRpcWalletAdapter adapter, {
  //   required final List<Transaction> transactions,
  // }) async {
  //   final List<String> payloads = await walletAdapterSerialization(transactions);
  //   return adapter.signTransactions(payloads);
  // }

  // Future<SignAndSendTransactionsResult> signAndSendTransactions(
  //   final JsonRpcWalletAdapter adapter, {
  //   required final List<Transaction> transactions,
  // }) async {
  //   final List<String> payloads = await walletAdapterSerialization(transactions);
  //   return adapter.signAndSendTransactions(payloads);
  // }

  // Future<SignMessagesResult> signMessages(
  //   final JsonRpcWalletAdapter adapter, {
  //   required final List<Transaction> transactions,
  //   required final List<PublicKey> addresses,
  // }) async {
  //   final List<String> payloads = await walletAdapterMessageSerialization(transactions);
  //   final List<Base64EncodedAddress> encoded = addresses.map((e) => e.toBase64()).toList(growable: false);
  //   return adapter.signMessages(payloads: payloads, addresses: encoded);
  // }

  /// Simulates sending a transaction.
  Future<JsonRpcContextResponse<TransactionStatus>> simulateTransactionRaw(
    Transaction transaction, {
    final List<Signer>? signers,
    final bool includeAccounts = false,
    final Commitment? commitment,
  }) async {
    if (transaction.nonceInfo != null && signers != null) {
      transaction.sign(signers);
    } else {
      bool disableCache = false;
      for (;;) {
        final latestBlockhash = await _blockhashCache.get(this, disabled: disableCache);
        transaction = transaction.copyWith(
          recentBlockhash: latestBlockhash.blockhash,
          lastValidBlockHeight: latestBlockhash.lastValidBlockHeight,
        );

        if (signers == null) {
          break;
        }

        transaction.sign(signers);
        final Uint8List? payerSignature = transaction.signature;
        if (payerSignature == null) {
          throw const TransactionException('No signature.'); // should never happen
        }

        final String signature = base64.encode(payerSignature);
        if (!_blockhashCache.simulatedSignatures.contains(signature) && 
            !_blockhashCache.transactionSignatures.contains(signature)) {
          // The signature of this transaction has not been seen before with the current 
          // [latestBlockhash.blockhash], all done. Let's break
          _blockhashCache.simulatedSignatures.add(signature);
          break;
        } else {
          // This transaction would be treated as duplicate (its derived signature matched to one of 
          // the already recorded signatures). So, we must fetch a new blockhash for a different 
          // signature by disabling our cache not to wait for the cache expiration 
          // [BlockhashCache.timeout].
          disableCache = true;
        }
      }
    }

    final Message message = transaction.compileAndVerifyMessage();
    final SimulateTransactionConfig config = SimulateTransactionConfig(
      sigVerify: signers != null,
      commitment: commitment,
      encoding: TransactionEncoding.base64,
      accounts: includeAccounts 
        ? AccountsFilter(addresses: message.nonProgramIds.toList(growable: false)) 
        : null,
    );

    final String signedTransaction = transaction.serialize().getString(BufferEncoding.base64);
    parse(result) => JsonRpcContextResult.parse(result, TransactionStatus.fromJson);
    return _request(Method.simulateTransaction, [signedTransaction], parse, config: config);
  }

  /// Simulates sending a transaction.
  Future<TransactionStatus> simulateTransaction(
    Transaction transaction, {
    final List<Signer>? signers,
    final bool includeAccounts = false,
    final Commitment? commitment,
  }) async {
    return simulateTransactionRaw(
      transaction, 
      signers: signers, 
      includeAccounts: includeAccounts,
      commitment: commitment,
    ).unwrap();
  }

  /// Sign, send and confirm a [transaction].
  Future<TransactionSignature> sendAndConfirmTransaction(
    final Transaction transaction, {
    final List<Signer> signers = const [],
    final SendAndConfirmTransactionConfig? config,
  }) async {

    final String signature = await sendTransaction(
      transaction, 
      signers: signers, 
      config: config?.toSendTransactionConfig(),
    );

    await confirmTransaction(signature, config: config?.toConfirmTransactionConfig());

    return signature;
  }

  /// Returns an error when [blockhash.lastValidBlockHeight] has been exceeded.
  Future<WebSocketSubscription<SignatureNotification>> _confirmTransactionBlockHeightExceeded(
    final BlockhashWithExpiryBlockHeight blockhash, 
    final Commitment? commitment,
  ) async {
    final config = GetBlockHeightConfig(commitment: commitment);
    u64 blockHeight = await getBlockHeight(config: config).catchError((_) => -1);
    while (blockHeight <= blockhash.lastValidBlockHeight) {
      blockHeight = await getBlockHeight(config: config).catchError((_) => -1);
      await Future.delayed(const Duration(seconds: 1));
    }
    return Future.error('Transaction block height exceeded.');
  }

  /// Returns an error when the timeout duration elapsed.
  Future<WebSocketSubscription<SignatureNotification>> _confirmTransactionTimeout<T>(
    final Commitment? commitment,
  ) {
    final Duration timeLimit = Duration(
      seconds: commitment == null || commitment == Commitment.finalized ? 60 : 30,
    );
    return Future.delayed(
      timeLimit,
      () => Future.error(TimeoutException('Transaction signature confirmation timed out.')),
    );
  }

  /// Confirms a transaction.
  Future<SignatureNotification> confirmTransaction(
    final TransactionSignature signature, { 
    final BlockhashWithExpiryBlockHeight? blockhash, 
    final ConfirmTransactionConfig? config, 
  }) async {

    late Uint8List decodedSignature;

    try {
      decodedSignature = convert.base58.decode(signature);
    } catch (error) {
      throw TransactionException('Failed to decode base58 signature $signature.');
    }

    utils.check(decodedSignature.length == nacl.signatureLength, 'Invalid signature length.');

    final Commitment? commitment = config?.commitment ?? this.commitment;

    final Future<WebSocketSubscription<SignatureNotification>> futureSubscription = signatureSubscribe(
      signature, 
      config: SignatureSubscribeConfig(commitment: commitment),
    );

    final WebSocketSubscription<SignatureNotification> subscription = await Future.any([
      futureSubscription,
      blockhash != null 
        ? _confirmTransactionBlockHeightExceeded(blockhash, commitment)
        : _confirmTransactionTimeout(commitment),
    ]);

    return subscription.asFuture().then(
      (final SignatureNotification notification) {
        return notification.err != null 
          ? Future.error(notification.err) 
          : Future.value(notification);
      }
    );
  }

  // /// Creates an `onTimeout` callback function for a [_webSocketExchange].
  // Future<JsonRpcResponse<T>> Function() _onWebSocketExchangeTimeout<T>() 
  //   => () => Future.error(TimeoutException('Web socket request timed out.'));

  /// Makes a JSON-RPC data request to the web [socket] server.
  /// 
  /// The request's `timeout` duration can be set using the [config] object's 
  /// [JsonRpcRequestConfig.timeout] property. 
  /// 
  /// All other configurations are ignored.
  Future<JsonRpcResponse<T>> _webSocketExchange<T>(
    final JsonRpcRequest request, {
    final JsonRpcRequestConfig? config,
  }) => webSocketRequest(cluster.ws(), request, config: config);
  // async {

  //   // The subscription's request/response cycle.
  //   WebSocketExchange<T>? exchange;

  //   try {
  //     // Get the web socket connection.
  //     final WebSocket connection = await socket.connect(cluster.ws());
      
  //     // Get the existing request/response cycle (if it exists).
  //     exchange = _webSocketExchangeManager.get(request.hash());

  //     // If an exchange created using the current connection exists, return the response (which may 
  //     // still be pending).
  //     if (exchange != null) {
  //       final DateTime? connectedAt = socket.connectedAt;
  //       if (connectedAt == null) {
  //         throw const WebSocketException('[WebSocketConnection.connectedAt] is null.');
  //       }
  //       if (exchange.createdAt.isBefore(connectedAt)) {
  //         if (exchange.isCompleted) {
  //           await _webSocketSubscriptionManager.close(exchangeId: exchange.id);
  //         } else {
  //           throw const WebSocketException('The exchange request has expired.');
  //         }
  //       } else {
  //         return exchange.response;
  //       }
  //     }

  //     // Check that existing requests have an id and new requests do not.
  //     assert(
  //       exchange == null ? request.id == null : request.id == exchange.id, 
  //       'A [WebSocketExchange] must be initialized with a new or existing exchange request.',
  //     );

  //     // Create a WebSocketExchange for the subscription's request/response cycle.
  //     exchange = WebSocketExchange<T>(request);

  //     // Store the exchange (request/response) to be used for future subscriptions or cancellation.
  //     _webSocketExchangeManager.set(exchange);

  //     // Send the request to the JSON-RPC web socket server (the response will be recevied by 
  //     // `onSocketData`).
  //     //_debugWebSocketRequest(exchange.request);
  //     connection.add(json.encode(exchange.request.toJson()));

  //     // Return the pending subscription that completes when a success response is received from the 
  //     // web socket server (onSocketData) or the request times out.
  //     final Duration timeLimit = config?.timeout ?? const Duration(seconds: 60);
  //     return await exchange.response.timeout(timeLimit, onTimeout: _onWebSocketExchangeTimeout());

  //   } catch (error, stackTrace) {
  //     _webSocketExchangeManager.remove(exchange?.id);
  //     exchange?.completeError(error, stackTrace);
  //     return Future.error(error, stackTrace);
  //   }
  // }

  /// Re-subscribe to an existing subscription.
  Future<WebSocketSubscription> resubscribe(
    final WebSocketExchange exchange, {
    final JsonRpcRequestConfig? config,
  }) async {
    final JsonRpcRequest request = exchange.request;
    final JsonRpcSubscribeResponse response = await _webSocketExchange<int>(request, config: config);
    return webSocketSubscriptionManager.subscribe(response);
  }

  /// Check that the subscription [params] contains a configuration object will no null values.
  void _assertSubscribeParams(final List<Object> params) {
    assert(
      params.isEmpty || 
      params.last is! Map || 
      (params.last as Map).values.every((value) => value != null),
    );
  }

  /// Subscribes to the JSON-RPC PubSub [method] to receive notifications sent by the web socket 
  /// server.
  /// 
  /// Returns a [WebSocketSubscription] that can be used to attach notification handlers.
  /// 
  /// The subscription [method] is invoked with the ordered parameter [values].
  /// 
  /// Request configurations can be set using the [config] object.
  /// 
  /// ```
  /// final connection = Connection(Cluster.devnet);
  /// 
  /// final WebSocketSubscription subscription = await connection.subscribe(
  ///   Method.accountSubscribe, 
  ///   ['3C4iYswhNe7Z2LJvxc9qQmF55rsKDUGdiuKVUGpTbRsK'],
  /// );
  /// 
  /// subscription.on(
  ///   (final dynamic data) {
  ///     // Called when the web socket server sends data.
  ///   },
  ///   onError: (final Object error, [final StackTrace? stackTrace]) {
  ///     // Called when the web socket server sends an error.
  ///   },
  ///   onDone: () {
  ///     // Called when the subscription completes, whether by error or cancellation.
  ///   },
  /// );
  /// ```
  /// 
  /// TODO: Create the listener (subscribe) before making the exchange request.
  Future<WebSocketSubscription<T>> _subscribe<T>(
    final Method method,
    final List<Object> values, {
    required final JsonRpcSubscribeConfig config,
  }) async {
    final List<Object> params = _buildParams(values, config, commitment ?? Commitment.finalized);
    _assertSubscribeParams(params);
    final JsonRpcRequest request = JsonRpcRequest(method.name, params: params, id: config.id);
    final JsonRpcSubscribeResponse response = await _webSocketExchange<int>(request, config: config);
    return webSocketSubscriptionManager.subscribe<T>(response);
  }

  /// NOTE: Bulk Subscriptions Are Not Supported.
  // Future<List<WebSocketSubscription<T>>> _bulkSubscribe<T>(
  //   final Method method,
  //   final List<List<Object>>valuesList, {
  //   required final JsonRpcSubscribeConfig config,
  // }) async {
  //   final List<JsonRpcRequest> requests = [];
  //   for (final List<Object> values in valuesList) {
  //     final List<Object> params = _buildParams(values, config, commitment ?? Commitment.finalized);
  //     _assertSubscribeParams(params);
  //     requests.add(JsonRpcRequest(method.name, params: params, id: config.id));
  //   }
  //   final List<JsonRpcSubscribeResponse> responses = await webSocketBulkRequest<int>(
  //     cluster.ws(), requests, config: config, eagerError: true
  //   );
  //   return responses.map((e) => _webSocketSubscriptionManager.subscribe<T>(e)).toList(growable: false);
  // }

  /// Unsubscribes from the JSON-RPC PubSub [method] to stop receiving notifications sent by the web 
  /// socket server.
  /// 
  /// Returns a `success` response ([JsonRpcUnsubscribeResponse.result] == `true`) for invalid 
  /// subscription ids (i.e. subscriptions that do not exist).
  /// 
  /// Request configurations can be set using the [config] object.
  /// 
  /// ```
  /// final connection = Connection(Cluster.devnet);
  /// const Method method = Method.accountSubscribe;
  /// 
  /// final WebSocketSubscription subscription = await connection.subscribe(
  ///   method, 
  ///   ['3C4iYswhNe7Z2LJvxc9qQmF55rsKDUGdiuKVUGpTbRsK'],
  /// );
  /// 
  /// final JsonRpcUnsubscribeResponse response = await connection.unsubscribe(
  ///   method,
  ///   subscription,
  /// );
  /// 
  /// print(response.result); // true
  /// ```
  Future<JsonRpcUnsubscribeResponse> _unsubscribe<T>(
    final Method method,
    final WebSocketSubscription<T> subscription, {
    required final JsonRpcUnsubscribeConfig? config,
  }) async {

    // Cancel the stream listener.
    await webSocketSubscriptionManager.unsubscribe<T>(subscription);

    // Create the return response (default to `success`).
    JsonRpcUnsubscribeResponse response = JsonRpcUnsubscribeResponse.fromResult(true);

    // If the stream has no more listeners, cancel the web socket subscription.
    if (!webSocketSubscriptionManager.hasListener(subscription.id)) {
      try {
        final defaultConfig = config ?? const JsonRpcUnsubscribeConfig();
        final List<Object> params = _buildParams([subscription.id], defaultConfig);
        final JsonRpcRequest request = JsonRpcRequest(method.name, params: params, id: defaultConfig.id);
        response = await _webSocketExchange<bool>(request, config: config);
        webSocketExchangeManager.remove(subscription.exchangeId);
        webSocketExchangeManager.remove(response.id);
        
      } catch(error, stackTrace) {
        // Ignore errors related to subscription ids that do not exist.
        //
        // For example, if a user calls unsubscribe twice for a [subscription] with a single 
        // listener, an invalid subscription id error will be thrown for the second invocation.
        if (JsonRpcException.isType(error, JsonRpcExceptionCode.invalidParams)) {
          webSocketExchangeManager.remove(subscription.exchangeId);
        } else {
          return Future.error(error, stackTrace);
        }
      }
    }

    return response;
  }

  /// Subscribes to an account to receive notifications when the lamports or data for a given 
  /// account's [publicKey] changes.
  Future<WebSocketSubscription<AccountInfo>> accountSubscribe(
    final PublicKey publicKey, {
    final AccountSubscribeConfig? config,
  }) async {
    final defaultConfig = config ?? AccountSubscribeConfig();
    return _subscribe(Method.accountSubscribe, [publicKey.toBase58()], config: defaultConfig);
  }

  /// Unsubscribes from account change notifications.
  Future<JsonRpcUnsubscribeResponse> accountUnsubscribe(
    final WebSocketSubscription subscription, {
    final AccountUnsubscribeConfig? config,
  }) async {
    return _unsubscribe(Method.accountUnsubscribe, subscription, config: config);
  }

  /// Subscribe to transaction logging.
  Future<WebSocketSubscription<LogsNotification>> logsSubscribe(
    final LogsFilter filter, {
    final LogsSubscribeConfig? config,
  }) async {
    final defaultConfig = config ?? const LogsSubscribeConfig();
    return _subscribe(Method.logsSubscribe, [filter.value], config: defaultConfig);
  }

  /// Unsubscribes from transaction logging.
  Future<JsonRpcUnsubscribeResponse> logsUnsubscribe(
    final WebSocketSubscription subscription, {
    final LogsUnsubscribeConfig? config,
  }) async {
    return _unsubscribe(Method.logsUnsubscribe, subscription, config: config);
  }

  /// Subscribes to a program to receive notifications when the lamports or data for a given account 
  /// owned by the program changes.
  Future<WebSocketSubscription<ProgramAccount>> programSubscribe(
    final PublicKey programId, {
    final ProgramSubscribeConfig? config,
  }) async {
    final defaultConfig = config ?? ProgramSubscribeConfig();
    return _subscribe(Method.programSubscribe, [programId.toBase58()], config: defaultConfig);
  }

  /// Unsubscribes from program changes.
  Future<JsonRpcUnsubscribeResponse> programUnsubscribe(
    final WebSocketSubscription subscription, {
    final ProgramUnsubscribeConfig? config,
  }) async {
    return _unsubscribe(Method.programUnsubscribe, subscription, config: config);
  }

  /// Subscribes to a transaction signature to receive a `signatureNotification` when the 
  /// transaction is confirmed, the subscription is automatically cancelled.
  /// 
  /// TODO: Cancel stream if there are no other listeners.
  Future<WebSocketSubscription<SignatureNotification>> signatureSubscribe(
    final TransactionSignature signature, {
    final SignatureSubscribeConfig? config,
  }) async {
    final defaultConfig = config ?? const SignatureSubscribeConfig();
    final WebSocketSubscription<SignatureNotification> subscription = await _subscribe(
      Method.signatureSubscribe, 
      [signature], 
      config: defaultConfig,
    );
    webSocketExchangeManager.remove(subscription.exchangeId);
    return subscription;
  }

  /// Unsubscribes from signature confirmation notifications.
  Future<JsonRpcUnsubscribeResponse> signatureUnsubscribe(
    final WebSocketSubscription subscription, {
    final SignatureUnsubscribeConfig? config,
  }) async {
    return _unsubscribe(Method.signatureUnsubscribe, subscription, config: config);
  }

  /// Subscribes to receive notifications anytime a slot is processed by the validator.
  Future<WebSocketSubscription<SlotNotification>> slotSubscribe({
    final SlotSubscribeConfig? config,
  }) async {
    final defaultConfig = config ?? const SlotSubscribeConfig();
    return _subscribe(Method.slotSubscribe, [], config: defaultConfig);
  }

  /// Unsubscribes from slot updates.
  Future<JsonRpcUnsubscribeResponse> slotUnsubscribe(
    final WebSocketSubscription subscription, {
    final SlotUnsubscribeConfig? config,
  }) async {
    return _unsubscribe(Method.slotUnsubscribe, subscription, config: config);
  }

  /// Subscribes to receive notifications anytime a new root is set by the validator.
  Future<WebSocketSubscription<u64>> rootSubscribe({
    final RootSubscribeConfig? config,
  }) async {
    final defaultConfig = config ?? const RootSubscribeConfig();
    return _subscribe(Method.rootSubscribe, [], config: defaultConfig);
  }

  /// Unsubscribes from root changes.
  Future<JsonRpcUnsubscribeResponse> rootUnsubscribe(
    final WebSocketSubscription subscription, {
    final RootUnsubscribeConfig? config,
  }) async {
    return _unsubscribe(Method.rootUnsubscribe, subscription, config: config);
  }
}