/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:solana_web3/src/buffer.dart';
import 'package:solana_web3/src/config/cluster.dart';
import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/config/health_status.dart';
import 'package:solana_web3/src/config/method.dart';
import 'package:solana_web3/src/config/transaction_encoding.dart';
import 'package:solana_web3/src/exceptions/rpc_exception.dart';
import 'package:solana_web3/src/models/logs_filter.dart';
import 'package:solana_web3/src/nacl.dart' show signatureLength;
import 'package:solana_web3/src/rpc/rpc_notification_response.dart';
import 'package:solana_web3/src/rpc/rpc_subscribe_config.dart';
import 'package:solana_web3/src/rpc/rpc_subscribe_response.dart';
import 'package:solana_web3/src/rpc/rpc_unsubscribe_config.dart';
import 'package:solana_web3/src/rpc/rpc_unsubscribe_response.dart';
import 'package:solana_web3/src/rpc_config/account_subscribe_config.dart';
import 'package:solana_web3/src/rpc_config/account_unsubscribe_config.dart';
import 'package:solana_web3/src/rpc_config/accounts_filter.dart';
import 'package:solana_web3/src/rpc_config/confirm_transaction_config.dart';
import 'package:solana_web3/src/rpc_config/get_block_commitment_config.dart';
import 'package:solana_web3/src/rpc_config/get_block_production_config.dart';
import 'package:solana_web3/src/rpc_config/get_block_time_config.dart';
import 'package:solana_web3/src/rpc_config/get_blocks_config.dart';
import 'package:solana_web3/src/rpc_config/get_blocks_with_limit_config.dart';
import 'package:solana_web3/src/rpc_config/get_cluster_nodes_config.dart';
import 'package:solana_web3/src/rpc_config/get_epoch_info_config.dart';
import 'package:solana_web3/src/rpc_config/get_epoch_schedule_config.dart';
import 'package:solana_web3/src/rpc_config/get_first_available_block_config.dart';
import 'package:solana_web3/src/rpc_config/get_health_config.dart';
import 'package:solana_web3/src/rpc_config/get_highest_snapshot_slot_config.dart';
import 'package:solana_web3/src/rpc_config/get_identity_config.dart';
import 'package:solana_web3/src/rpc_config/get_inflation_governor_config.dart';
import 'package:solana_web3/src/rpc_config/get_inflation_rate_config.dart';
import 'package:solana_web3/src/rpc_config/get_inflation_reward_config.dart';
import 'package:solana_web3/src/rpc_config/get_largest_accounts_config.dart';
import 'package:solana_web3/src/rpc_config/get_leader_schedule_config.dart';
import 'package:solana_web3/src/rpc_config/get_max_retransmit_slot_config.dart';
import 'package:solana_web3/src/rpc_config/get_max_shred_insert_slot_config.dart';
import 'package:solana_web3/src/rpc_config/get_multiple_accounts_config.dart';
import 'package:solana_web3/src/rpc_config/get_program_accounts_config.dart';
import 'package:solana_web3/src/rpc_config/get_recent_performance_samples_config.dart';
import 'package:solana_web3/src/rpc_config/get_signature_statuses_config.dart';
import 'package:solana_web3/src/rpc_config/get_signatures_for_address_config.dart';
import 'package:solana_web3/src/rpc_config/get_slot_config.dart';
import 'package:solana_web3/src/rpc_config/get_slot_leader_config.dart';
import 'package:solana_web3/src/rpc_config/get_slot_leaders_config.dart';
import 'package:solana_web3/src/rpc_config/get_stake_activation_config.dart';
import 'package:solana_web3/src/rpc_config/get_supply_config.dart';
import 'package:solana_web3/src/rpc_config/get_token_account_balance_config.dart';
import 'package:solana_web3/src/rpc_config/get_token_accounts_by_delegate_config.dart';
import 'package:solana_web3/src/rpc_config/get_token_accounts_by_owner_config.dart';
import 'package:solana_web3/src/rpc_config/get_token_largest_accounts_config.dart';
import 'package:solana_web3/src/rpc_config/get_token_supply_config.dart';
import 'package:solana_web3/src/rpc_config/get_transaction_config.dart';
import 'package:solana_web3/src/rpc_config/get_transaction_count_config.dart';
import 'package:solana_web3/src/rpc_config/get_version_config.dart';
import 'package:solana_web3/src/rpc_config/get_vote_accounts_config.dart';
import 'package:solana_web3/src/rpc_config/is_blockhash_valid_config.dart';
import 'package:solana_web3/src/rpc_config/logs_subscribe_config.dart';
import 'package:solana_web3/src/rpc_config/logs_unsubscribe_config.dart';
import 'package:solana_web3/src/rpc_config/minimum_ledger_slot.dart';
import 'package:solana_web3/src/rpc_config/program_subscribe_config.dart';
import 'package:solana_web3/src/rpc_config/program_unsubscribe_config.dart';
import 'package:solana_web3/src/rpc_config/root_subscribe_config.dart';
import 'package:solana_web3/src/rpc_config/root_unsubscribe_config.dart';
import 'package:solana_web3/src/rpc_config/send_and_confirm_transaction_config.dart';
import 'package:solana_web3/src/rpc_config/get_block_height_config.dart';
import 'package:solana_web3/src/rpc_config/get_fee_for_message_config.dart';
import 'package:solana_web3/src/rpc_config/get_latest_blockhash_config.dart';
import 'package:solana_web3/src/rpc_config/get_minimum_balance_for_rent_exemption_config.dart';
import 'package:solana_web3/src/rpc_config/request_airdrop_config.dart';
import 'package:solana_web3/src/rpc_config/send_transaction_config.dart';
import 'package:solana_web3/src/rpc_config/signature_subscribe_config.dart';
import 'package:solana_web3/src/rpc_config/signature_unsubscribe_config.dart';
import 'package:solana_web3/src/rpc_config/simulate_transaction_config.dart';
import 'package:solana_web3/src/rpc_config/slot_subscribe_config.dart';
import 'package:solana_web3/src/rpc_config/slot_unsubscribe_config.dart';
import 'package:solana_web3/src/rpc_config/token_accounts_filter.dart';
import 'package:solana_web3/src/rpc_data/block.dart';
import 'package:solana_web3/src/public_key.dart';
import 'package:solana_web3/src/rpc/rpc_bulk_request_config.dart';
import 'package:solana_web3/src/rpc_config/get_account_info_config.dart';
import 'package:solana_web3/src/rpc_data/account_info.dart';
import 'package:solana_web3/src/exceptions/transaction_exception.dart';
import 'package:solana_web3/src/keypair.dart';
import 'package:solana_web3/src/message/message.dart';
import 'package:http/http.dart' as http;
import 'package:solana_web3/src/rpc/rpc_context_response.dart';
import 'package:solana_web3/src/rpc/rpc_context_result.dart';
import 'package:solana_web3/src/rpc/rpc_http_headers.dart';
import 'package:solana_web3/src/rpc/rpc_request.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';
import 'package:solana_web3/src/rpc/rpc_response.dart';
import 'package:solana_web3/src/rpc_config/get_balance_config.dart';
import 'package:solana_web3/src/rpc_config/get_block_config.dart';
import 'package:solana_web3/src/rpc_data/block_commitment.dart';
import 'package:solana_web3/src/rpc_data/block_production.dart';
import 'package:solana_web3/src/rpc_data/blockhash_cache.dart';
import 'package:solana_web3/src/rpc_data/blockhash_with_expiry_block_height.dart';
import 'package:solana_web3/src/rpc_data/cluster_node.dart';
import 'package:solana_web3/src/rpc_data/confirmed_signature_info.dart';
import 'package:solana_web3/src/rpc_data/epoch_info.dart';
import 'package:solana_web3/src/rpc_data/epoch_schedule.dart';
import 'package:solana_web3/src/rpc_data/highest_snapshot_slot.dart';
import 'package:solana_web3/src/rpc_data/identity.dart';
import 'package:solana_web3/src/rpc_data/inflation_governor.dart';
import 'package:solana_web3/src/rpc_data/inflation_rate.dart';
import 'package:solana_web3/src/rpc_data/inflation_reward.dart';
import 'package:solana_web3/src/rpc_data/large_account.dart';
import 'package:solana_web3/src/rpc_data/performance_sample.dart';
import 'package:solana_web3/src/rpc_data/program_account.dart';
import 'package:solana_web3/src/rpc_data/signature_status.dart';
import 'package:solana_web3/src/rpc_data/stake_activation.dart';
import 'package:solana_web3/src/rpc_data/supply.dart';
import 'package:solana_web3/src/rpc_data/token_account.dart';
import 'package:solana_web3/src/rpc_data/token_amount.dart';
import 'package:solana_web3/src/rpc_data/transaction_info.dart';
import 'package:solana_web3/src/rpc_data/transaction_status.dart';
import 'package:solana_web3/src/rpc_data/version.dart';
import 'package:solana_web3/src/rpc_data/vote_account_status.dart';
import 'package:solana_web3/src/transaction/transaction.dart';
import 'package:solana_web3/src/utils/convert.dart' as convert show base58, list;
import 'package:solana_web3/src/utils/library.dart' as utils show cast, require;
import 'package:solana_web3/src/utils/library.dart';
import 'package:solana_web3/src/utils/types.dart' show RpcJsonParser, RpcListParser, RpcParser, u64, i64, usize;
import 'package:solana_web3/src/web_socket_connection.dart';
import 'package:solana_web3/src/web_socket_exchange_manager.dart';
import 'package:solana_web3/src/web_socket_subscription_manager.dart';


/// Future Extension
/// ------------------------------------------------------------------------------------------------

/// Future extensions for [RpcResponse]s.
extension FutureRpcResponse<T> on Future<RpcResponse<T>> {

  /// Returns a new future that completes with the [RpcResponse.result].
  /// 
  /// The caller must ensure that [RpcResponse.result] will `not be null`.
  Future<T> unwrap() => then((final RpcResponse<T> value) => value.result!);

  /// Returns a new future that completes with the [RpcResponse.result].
  Future<T?> optional() => then((final RpcResponse<T> value) => value.result);
}

/// Future extensions for [RpcContextResponse]s.
extension FutureRpcContextResponse<T> on Future<RpcContextResponse<T>> {

  /// Returns a new future that completes with the [RpcContextResult.value].
  /// 
  /// The caller must ensure that [RpcContextResult.value] will `not be null`.
  Future<T> unwrap() => then((final RpcContextResponse<T> value) => value.result!.value!);

  /// Returns a new future that completes with the [RpcContextResult.value].
  Future<T?> optional() => then((final RpcContextResponse<T> value) => value.result?.value);
}


/// Connection
/// ------------------------------------------------------------------------------------------------

class Connection {

  /// Creates a connection to the [cluster].
  /// 
  /// Web socket method calls are made to [wsCluster], which defaults to [cluster].
  Connection(
    this.cluster, { 
    final Cluster? wsCluster, 
  }) {
    socket = WebSocketConnection(
      wsCluster ?? cluster, 
      _onWebSocketData,
      onError: _onWebSocketError,
      onConnect: _onWebSocketConnect,
      onDisconnect: _onWebSocketDisconnect,
    );
  }

  /// The cluster to connect to.
  final Cluster cluster;

  /// The websocket connection.
  late final WebSocketConnection socket;

  /// The latest blockhash.
  final BlockhashCache _blockhashCache = BlockhashCache();

  /// Maps [RpcRequest]s to their corresponding [RpcResponse].
  final WebSocketExchangeManager _webSocketExchangeManager = WebSocketExchangeManager();

  /// Adds and removes stream listeners for a web socket subscription.
  final WebSocketSubscriptionManager _webSocketSubscriptionManager = WebSocketSubscriptionManager();

  /// Disposes of all the acquired resources.
  void disconnect() {
    socket.disconnect().ignore();
    _webSocketExchangeManager.dispose();
    _webSocketSubscriptionManager.dispose();
  }

  void _onWebSocketData(final Map<String, dynamic> json)  async {
    
    print('[ON SOCKET DATA] $json');

    if (RpcResponse.isType<int>(json)) {
      final RpcSubscribeResponse response = RpcResponse.parse(json, cast<int>);
      return _webSocketExchangeManager.onResponse(response);
    }

    if (RpcResponse.isType<bool>(json)) {
      final RpcUnsubscribeResponse response = RpcResponse.parse(json, cast<bool>);
      return _webSocketExchangeManager.onResponse(response);
    }

    final RpcResponse? response = RpcResponse.tryParse(json, cast<dynamic>);
    if (response != null && response.isError) {
      return _webSocketExchangeManager.onResponse(response);
    }

    final RpcNotificationResponse? notification = RpcNotificationResponse.tryParse(json);
    if (notification != null) {
      return _webSocketSubscriptionManager.onNotification(notification);
    }
  }

  void _onWebSocketError(final Object error, [final StackTrace? stackTrace]) {
    print("\n--------------------------------------------------------------------------------");
    print("[ON SOCKET ERROR]        $error");
    print("--------------------------------------------------------------------------------\n");
  }

  void _onWebSocketConnect(final WebSocket connection) {
    print("\n--------------------------------------------------------------------------------");
    print("[ON SOCKET CONNECT]");
    print("--------------------------------------------------------------------------------\n");
    for(final WebSocketExchange exchange in _webSocketExchangeManager.values) {
      print('Resubscribing $exchange');
      resubscribe(exchange).ignore();
    }
  }

  void _onWebSocketDisconnect() {
    print("\n--------------------------------------------------------------------------------");
    print("[ON SOCKET DISCONNECT]");
    print("--------------------------------------------------------------------------------\n");
  }

  /// Prints the contents of a JSON-RPC request.
  Object _debugRequest(final Object request) {
    print("\n--------------------------------------------------------------------------------");
    print("[REQUEST BODY]:          $request");
    print("--------------------------------------------------------------------------------\n");
    return request;
  }

  /// Prints the contents of a JSON-RPC response.
  http.Response _debugResponse(final http.Response response) {
    final Map<String, dynamic>? body = json.decode(response.body);
    print("\n--------------------------------------------------------------------------------");
    print("[RESPONSE BODY]:           $body");
    print("[RESPONSE RESULT TYPE]:    ${(body ?? {})['result']?.runtimeType}");
    // print("[RESPONSE HEADERS]:        ${response.headers}");
    print("[RESPONSE STATUS CODE]:    ${response.statusCode}");
    print("[RESPONSE REASON PHRASE]:  ${response.reasonPhrase}");
    print("--------------------------------------------------------------------------------\n");
    return response;
  }

  /// Creates a callback function that converts a [http.Response] into an [RpcResponse].
  /// 
  /// The [parse] callback function converts [http.Response]'s `result` value from type `U` into 
  /// `T`.
  FutureOr<RpcResponse<T>> Function(http.Response) _responseParser<T, U>(
    final RpcParser<T, U> parse,
  ) {
    return (final http.Response response) {
      _debugResponse(response);
      final Map<String, dynamic> body = json.decode(response.body);
      final RpcResponse<T> rpc = RpcResponse.parse<T, U>(body, parse);
      return rpc.isSuccess ? Future.value(rpc) : Future.error(rpc.error!);
    };
  }

  /// Creates a callback function that converts a bulk [http.Response] into a [List] of 
  /// [RpcResponse].
  /// 
  /// The [parsers] callback functions convert each [http.Response] `result` value from type `U` 
  /// into `T`.
  List<RpcResponse> Function(http.Response) _bulkResponseParser(
    final List<RpcParser> parsers,
  ) {
    return (final http.Response response) {
      final List<Map<String, dynamic>> body = json.decode(response.body);
      return List.generate(body.length, (final int i) => RpcResponse.parse(body[i], parsers[i]));
    };
  }

  /// Creates a callback function that converts the `body` of a `context response` into an 
  /// [RpcContextResult].
  /// 
  /// The [parse] method converts context result's `value` property from type `U` into `T`.
  RpcJsonParser<RpcContextResult<T>> _contextParser<T, U>(final RpcParser<T, U> parse) {
    return (final Map<String, dynamic> body) => RpcContextResult.parse(body, parse);
  }

  /// Creates a callback function that converts a list returned by a [http.Response]'s into a list 
  /// of type T.
  /// 
  /// The [parse] method converts each item in the list from type `U` into `T`.
  RpcListParser<T> _listParser<T, U>(final RpcParser<T, U> parse) {
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
  /// The [config] object can be used to set the request's [RpcRequestConfig.headers] and 
  /// [RpcRequestConfig.timeout] duration.
  Future<http.Response> _post<T, U>(final Object body, { final RpcRequestConfig? config }) {
    _debugRequest(body);
    final Future<http.Response> request = http.post(
      cluster.http(),
      body: json.encode(body).codeUnits,
      headers: (config?.headers ?? const RpcHttpHeaders()).toJson(),
    );
    final Duration? timeout = config?.timeout;
    return timeout != null ? request.timeout(timeout) : request;
  }

  /// Makes a JSON-RPC POST request to the [cluster], invoking a single [method].
  /// 
  /// The [method] is invoked with the provided [params] and configurations (
  /// [RpcRequestConfig.id] and [RpcRequestConfig.objectClean]).
  /// 
  /// The [parse] callback function is applied to the `result` value of a `success` response.
  /// 
  /// Additional request configurations can be set using the [config] object's 
  /// [RpcRequestConfig.headers] and [RpcRequestConfig.timeout] properties.
  Future<RpcResponse<T>> _request<T, U>(
    final Method method, 
    final List<Object> params, 
    final RpcParser<T, U> parse, {
    final RpcRequestConfig? config,
  }) {
    final RpcRequest request = RpcRequest.build(method, params, config);
    return _post(request.toJson(), config: config).then(_responseParser(parse));
  }
  
  /// Makes a JSON-RPC POST request to the [cluster], invoking multiple methods in a single request.
  /// 
  /// Each of the [requests] defines a method to be invoked and their responses are handled by the 
  /// provided [parsers]. The number of [requests] must match the number of [parsers].
  /// 
  /// Additional request configurations can be set using the [config] object's 
  /// [RpcRequestConfig.headers] and [RpcRequestConfig.timeout] properties.
  /// 
  /// ```
  /// _bulkRequest(
  ///   [RpcRequest(...), RpcRequest(...)], // The requests. 
  ///   [(Map) => int, (String) => List]    // The corresponding parsers.
  /// )
  /// ```
  Future<List<RpcResponse>> _bulkRequest(
    final List<RpcRequest> requests, 
    final List<RpcParser> parsers, {
    final RpcBulkRequestConfig? config,
  }) {
    assert(requests.length == parsers.length);
    return _post(convert.list.encode(requests), config: config).then(_bulkResponseParser(parsers));
  }

  /// Get the [cluster]'s health status.
  Future<HealthStatus> health() {
    return http.get(cluster.http('health'))
      .then((final http.Response response) => HealthStatus.fromName(response.body));
  }

  /// Returns all information associated with the account of the provided [publicKey].
  Future<RpcContextResponse<AccountInfo?>> getAccountInfoRaw(
    final PublicKey publicKey, {
    final GetAccountInfoConfig? config,
  }) {
    final parse = _contextParser(AccountInfo.tryParse);
    return _request(Method.getAccountInfo, [publicKey.toBase58()], parse, config: config);
  }

  /// Returns all information associated with the account of the provided [publicKey].
  Future<AccountInfo?> getAccountInfo(
    final PublicKey publicKey, {
    final GetAccountInfoConfig? config,
  }) {
    return getAccountInfoRaw(publicKey, config: config).optional();
  }

  /// Returns the `lamports` balance of the account for the provided [publicKey].
  Future<RpcContextResponse<u64>> getBalanceRaw(
    final PublicKey publicKey, {
    final GetBalanceConfig? config,
  }) {
    final parse = _contextParser(cast<u64>);
    return _request(Method.getBalance, [publicKey.toBase58()], parse, config: config);
  }

  /// Returns the `lamports` balance of the account for the provided [publicKey].
  Future<u64> getBalance(
    final PublicKey publicKey, {
    final GetBalanceConfig? config,
  }) {
    return getBalanceRaw(publicKey, config: config).unwrap();
  }

  /// Returns identity and transaction information about a confirmed block at [slot] in the ledger.
  Future<RpcResponse<Block?>> getBlockRaw(
    final u64 slot, {
    final GetBlockConfig? config,
  }) {
    assert(slot >= 0);
    return _request(Method.getBlock, [slot], Block.tryFromJson, config: config);
  }

  /// Returns identity and transaction information about a confirmed block at [slot] in the ledger.
  Future<Block?> getBlock(
    final u64 slot, {
    final GetBlockConfig? config,
  }) {
    return getBlockRaw(slot, config: config).optional();
  }

  /// Returns the current block height of the node.
  Future<RpcResponse<u64>> getBlockHeightRaw({ final GetBlockHeightConfig? config }) {
    return _request(Method.getBlockHeight, [], utils.cast<u64>, config: config);
  }

  /// Returns the current block height of the node.
  Future<u64> getBlockHeight({ final GetBlockHeightConfig? config }) {
    return getBlockHeightRaw(config: config).unwrap();
  }

  /// Returns the recent block production information from the current or previous epoch.
  Future<RpcContextResponse<BlockProduction>> getBlockProductionRaw({ 
    final GetBlockProductionConfig? config, 
  }) {
    final parse = _contextParser(BlockProduction.fromJson);
    return _request(Method.getBlockProduction, [], parse, config: config);
  }

  /// Returns the recent block production information from the current or previous epoch.
  Future<BlockProduction> getBlockProduction({ final GetBlockProductionConfig? config }) {
    return getBlockProductionRaw(config: config).unwrap();
  }

  /// Returns the commitment for a particular block (slot).
  Future<RpcResponse<BlockCommitment>> getBlockCommitmentRaw(
    final u64 slot, { 
    final GetBlockCommitmentConfig? config, 
  }) {
    return _request(Method.getBlockCommitment, [slot], BlockCommitment.fromJson, config: config);
  }

  /// Returns the commitment for a particular block (slot).
  Future<BlockCommitment> getBlockCommitment(
    final u64 slot, { 
    final GetBlockCommitmentConfig? config, 
  }) {
    return getBlockCommitmentRaw(slot, config: config).unwrap();
  }

  /// Returns a list of confirmed blocks between two slots.
  Future<RpcResponse<List<u64>>> getBlocksRaw(
    final u64 startSlot, { 
    final u64? endSlot,
    final GetBlocksConfig? config, 
  }) {
    final List<u64> params = endSlot != null ? [startSlot, endSlot] : [startSlot];
    return _request(Method.getBlocks, params, convert.list.cast<u64>, config: config);
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
  Future<RpcResponse<List<u64>>> getBlocksWithLimitRaw(
    final u64 slot, { 
    required final u64 limit,
    final GetBlocksWithLimitConfig? config, 
  }) {
    return _request(Method.getBlocksWithLimit, [slot, limit], convert.list.cast<u64>, config: config);
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
  Future<RpcResponse<i64?>> getBlockTimeRaw(
    final u64 slot, {
    final GetBlockTimeConfig? config,
  }) {
    return _request(Method.getBlockTime, [slot], cast<i64?>, config: config);
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
  Future<RpcResponse<List<ClusterNode>>> getClusterNodesRaw({ 
    final GetClusterNodesConfig? config, 
  }) {
    final parse = _listParser(ClusterNode.fromJson);
    return _request(Method.getClusterNodes, [], parse, config: config);
  }

  /// Returns information about all the nodes participating in the cluster.
  Future<List<ClusterNode>> getClusterNodes({ final GetBlockTimeConfig? config }) {
    return getClusterNodesRaw(config: config).unwrap();
  }

  /// Returns information about the current epoch.
  Future<RpcResponse<EpochInfo>> getEpochInfoRaw({ 
    final GetEpochInfoConfig? config, 
  }) {
    return _request(Method.getEpochInfo, [], EpochInfo.fromJson, config: config);
  }

  /// Returns information about the current epoch.
  Future<EpochInfo> getEpochInfo({ final GetEpochInfoConfig? config }) {
    return getEpochInfoRaw(config: config).unwrap();
  }

  /// Returns the epoch schedule information from the cluster's genesis config.
  Future<RpcResponse<EpochSchedule>> getEpochScheduleRaw({ 
    final GetEpochScheduleConfig? config, 
  }) {
    return _request(Method.getEpochSchedule, [], EpochSchedule.fromJson, config: config);
  }

  /// Returns the epoch schedule information from the cluster's genesis config.
  Future<EpochSchedule> getEpochSchedule({ final GetEpochScheduleConfig? config }) {
    return getEpochScheduleRaw(config: config).unwrap();
  }

  /// Returns the network fee that will be charged to send [message].
  /// 
  /// TODO: Find out if `null` means zero.
  Future<RpcContextResponse<u64?>> getFeeForMessageRaw(
    final Message message, {
    final GetFeeForMessageConfig? config,
  }) {
    final parse = _contextParser(utils.cast<u64?>);
    final String encoded = message.serialise().getString(BufferEncoding.base64);
    return _request(Method.getFeeForMessage, [encoded], parse, config: config);
  }

  /// Returns the network fee that will be charged to send [message].
  Future<u64> getFeeForMessage(
    final Message message, {
    final GetFeeForMessageConfig? config,
  }) async {
    final u64? fee = await getFeeForMessageRaw(message, config: config).unwrap();
    return fee != null ? Future.value(fee) : Future.error(const RpcException('Invalid fee.'));
  }

  /// Returns the slot of the lowest confirmed block that has not been purged from the ledger.
  Future<RpcResponse<u64>> getFirstAvailableBlockRaw({ 
    final GetFirstAvailableBlockConfig? config, 
  }) {
    return _request(Method.getFirstAvailableBlock, [], utils.cast<u64>, config: config);
  }

  /// Returns the slot of the lowest confirmed block that has not been purged from the ledger.
  Future<u64> getFirstAvailableBlock({ 
    final GetFirstAvailableBlockConfig? config, 
  }) {
    return getFirstAvailableBlockRaw(config: config).unwrap();
  }

  /// Returns the genesis hash.
  Future<RpcResponse<String>> getGenesisHashRaw({ 
    final GetFirstAvailableBlockConfig? config, 
  }) {
    return _request(Method.getGenesisHash, [], utils.cast<String>, config: config);
  }

  /// Returns the genesis hash.
  Future<String> getGenesisHash({ 
    final GetFirstAvailableBlockConfig? config, 
  }) {
    return getGenesisHashRaw(config: config).unwrap();
  }

  /// Returns the current health of the node.
  /// 
  /// If one or more --known-validator arguments are provided to solana-validator, "ok" is returned 
  /// when the node has within HEALTH_CHECK_SLOT_DISTANCE slots of the highest known validator, 
  /// otherwise an error is returned. "ok" is always returned if no known validators are provided.
  Future<RpcResponse<HealthStatus>> getHealthRaw({ 
    final GetHealthConfig? config, 
  }) {
    return _request(Method.getHealth, [], HealthStatus.fromName, config: config);
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
  Future<RpcResponse<HighestSnapshotSlot>> getHighestSnapshotSlotRaw({ 
    final GetHighestSnapshotSlotConfig? config, 
  }) {
    return _request(Method.getHighestSnapshotSlot, [], HighestSnapshotSlot.fromJson, config: config);
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
  Future<RpcResponse<Identity>> getIdentityRaw({ 
    final GetIdentityConfig? config, 
  }) {
    return _request(Method.getIdentity, [], Identity.fromJson, config: config);
  }

  /// Returns the identity pubkey for the current node.
  Future<Identity> getIdentity({ 
    final GetIdentityConfig? config, 
  }) {
    return getIdentityRaw(config: config).unwrap();
  }

  /// Returns the current inflation governor.
  Future<RpcResponse<InflationGovernor>> getInflationGovernorRaw({ 
    final GetInflationGovernorConfig? config, 
  }) {
    return _request(Method.getInflationGovernor, [], InflationGovernor.fromJson, config: config);
  }

  /// Returns the current inflation governor.
  Future<InflationGovernor> getInflationGovernor({ 
    final GetInflationGovernorConfig? config, 
  }) {
    return getInflationGovernorRaw(config: config).unwrap();
  }

  /// Returns the specific inflation values for the current epoch.
  Future<RpcResponse<InflationRate>> getInflationRateRaw({ 
    final GetInflationRateConfig? config, 
  }) {
    return _request(Method.getInflationRate, [], InflationRate.fromJson, config: config);
  }

  /// Returns the specific inflation values for the current epoch.
  Future<InflationRate> getInflationRate({ 
    final GetInflationRateConfig? config, 
  }) {
    return getInflationRateRaw(config: config).unwrap();
  }

  /// Returns the inflation / staking reward for a list of [addresses] for an epoch.
  Future<RpcResponse<List<InflationReward?>>> getInflationRewardRaw(
    final Iterable<PublicKey> addresses, { 
    final GetInflationRewardConfig? config, 
  }) {
    final pubKeys = addresses.map((final PublicKey address) => address.toBase58()).toList(growable: false);
    final parse = _listParser(InflationReward.tryFromJson);
    return _request(Method.getInflationReward, [pubKeys], parse, config: config);
  }

  /// Returns the inflation / staking reward for a list of [addresses] for an epoch.
  Future<List<InflationReward?>> getInflationReward(
    final Iterable<PublicKey> addresses, { 
    final GetInflationRewardConfig? config, 
  }) {
    return getInflationRewardRaw(addresses, config: config).unwrap();
  }

  /// Returns the 20 largest accounts, by lamport balance (results may be cached up to two hours).
  Future<RpcContextResponse<List<LargeAccount>>> getLargestAccountsRaw({ 
    final GetLargestAccountsConfig? config, 
  }) {
    parse(result) => RpcContextResult.parse(result, _listParser(LargeAccount.fromJson));
    return _request(Method.getLargestAccounts, [], parse, config: config);
  }

  /// Returns the 20 largest accounts, by lamport balance (results may be cached up to two hours).
  Future<List<LargeAccount>> getLargestAccounts({ 
    final GetLargestAccountsConfig? config, 
  }) {
    return getLargestAccountsRaw(config: config).unwrap();
  }

  /// Returns the latest blockhash.
  Future<RpcContextResponse<BlockhashWithExpiryBlockHeight>> getLatestBlockhashRaw({
    final GetLatestBlockhashConfig? config,
  }) {
    final parser = _contextParser(BlockhashWithExpiryBlockHeight.fromJson);
    return _request(Method.getLatestBlockhash, [], parser, config: config);
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
  Future<RpcResponse<Map<String, List>?>> getLeaderScheduleRaw({
    final u64? slot,
    final GetLeaderScheduleConfig? config,
  }) {
    final List<Object> params = slot != null ? [slot] : [];
    Map<String, List>? parse(final Map? result) => result != null ? Map.castFrom(result) : null;
    return _request(Method.getLeaderSchedule, params, parse, config: config);
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
  Future<RpcResponse<u64>> getMaxRetransmitSlotRaw({
    final GetMaxRetransmitSlotConfig? config,
  }) {
    return _request(Method.getMaxRetransmitSlot, [], utils.cast<u64>, config: config);
  }

  /// Returns the max slot seen from retransmit stage.
  Future<u64> getMaxRetransmitSlot({
    final GetMaxRetransmitSlotConfig? config,
  }) {
    return getMaxRetransmitSlotRaw(config: config).unwrap();
  }

  /// Returns the max slot seen from after shred insert.
  Future<RpcResponse<u64>> getMaxShredInsertSlotRaw({
    final GetMaxShredInsertSlotConfig? config,
  }) {
    return _request(Method.getMaxShredInsertSlot, [], utils.cast<u64>, config: config);
  }

  /// Returns the max slot seen from after shred insert.
  Future<u64> getMaxShredInsertSlot({
    final GetMaxShredInsertSlotConfig? config,
  }) {
    return getMaxShredInsertSlotRaw(config: config).unwrap();
  }

  /// Returns the minimum balance required to make an account of size [length] rent exempt.
  Future<RpcResponse<u64>> getMinimumBalanceForRentExemptionRaw(
    final int length, {
    final GetMinimumBalanceForRentExemptionConfig? config,
  }) {
    return _request(
      Method.getMinimumBalanceForRentExemption, 
      [length], cast<u64>, config: config,
    );
  }

  /// Returns the minimum balance required to make an account of size [length] rent exempt.
  Future<u64> getMinimumBalanceForRentExemption(
    final int length, {
    final GetMinimumBalanceForRentExemptionConfig? config,
  }) {
    return getMinimumBalanceForRentExemptionRaw(length, config: config).unwrap();
  }

  /// Returns the account information for a list of Pubkeys.
  Future<RpcContextResponse<List<AccountInfo?>>> getMultipleAccountsRaw(
    final List<PublicKey> accounts, {
    final GetMultipleAccountsConfig? config,
  }) {
    require(accounts.length <= 100, 'getMultipleAccounts() can fetch up to a maximum of 100.');
    parse(result) => RpcContextResult.parse(result, _listParser(AccountInfo.tryParse));
    final pubKeys = accounts.map((final PublicKey account) => account.toBase58()).toList(growable: false);
    return _request(Method.getMultipleAccounts, [pubKeys], parse, config: config);
  }

  /// Returns the account information for a list of Pubkeys.
  Future<List<AccountInfo?>> getMultipleAccounts(
    final List<PublicKey> accounts, {
    final GetMultipleAccountsConfig? config,
  }) {
    return getMultipleAccountsRaw(accounts, config: config).unwrap();
  }

  /// Returns all accounts owned by the provided program Pubkey.
  Future<RpcResponse<List<ProgramAccount>>> getProgramAccountsRaw(
    final PublicKey program, {
    final GetProgramAccountsConfig? config,
  }) {
    final parse = _listParser(ProgramAccount.fromJson);
    return _request(Method.getProgramAccounts, [program.toBase58()], parse, config: config);
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
  Future<RpcResponse<List<PerformanceSample>>> getRecentPerformanceSamplesRaw({
    final usize? limit,
    final GetRecentPerformanceSamplesConfig? config,
  }) {
    final List<Object> params = limit != null ? [limit] : [];
    final parse = _listParser(PerformanceSample.fromJson);
    return _request(Method.getRecentPerformanceSamples, params, parse, config: config);
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
  Future<RpcResponse<List<ConfirmedSignatureInfo>>> getSignaturesForAddressRaw(
    final PublicKey address, {
    final GetSignaturesForAddressConfig? config,
  }) {
    final parse = _listParser(ConfirmedSignatureInfo.fromJson);
    return _request(Method.getSignaturesForAddress, [address.toBase58()], parse, config: config);
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
  Future<RpcContextResponse<List<SignatureStatus?>>> getSignatureStatusesRaw(
    final List<String> signatures, {
    final GetSignatureStatusesConfig? config,
  }) {
    parse(result) => RpcContextResult.parse(result, _listParser(SignatureStatus.tryFromJson));
    return _request(Method.getSignatureStatuses, [signatures], parse, config: config);
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
  Future<RpcResponse<u64>> getSlotRaw({ final GetSlotConfig? config }) {
    return _request(Method.getSlot, [], utils.cast<u64>, config: config);
  }

  /// Returns the slot that has reached the given or default [GetSlotConfig.commitment] level.
  Future<u64> getSlot({ final GetSlotConfig? config }) {
    return getSlotRaw(config: config).unwrap();
  }

  /// Returns the current slot leader.
  Future<RpcResponse<PublicKey>> getSlotLeaderRaw({ final GetSlotLeaderConfig? config }) {
    return _request(Method.getSlotLeader, [], PublicKey.fromString, config: config);
  }

  /// Returns the current slot leader.
  Future<PublicKey> getSlotLeader({ final GetSlotLeaderConfig? config }) {
    return getSlotLeaderRaw(config: config).unwrap();
  }

  /// Returns the slot leaders for a given slot range.
  Future<RpcResponse<List<PublicKey>>> getSlotLeadersRaw({ 
    required final u64 start,
    required final u64 limit,
    final GetSlotLeadersConfig? config }) {
    final parse = _listParser(PublicKey.fromString);
    return _request(Method.getSlotLeaders, [start, limit], parse, config: config);
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
  Future<RpcResponse<StakeActivation>> getStakeActivationRaw(
    final PublicKey account, {
    final GetStakeActivationConfig? config, 
  }) {
    return _request(Method.getStakeActivation, [account.toBase58()], StakeActivation.fromJson, config: config);
  }

  /// Returns epoch activation information for a stake account.
  Future<StakeActivation> getStakeActivation(
    final PublicKey account, {
    final GetStakeActivationConfig? config, 
  }) {
    return getStakeActivationRaw(account, config: config).unwrap();
  }

  /// Returns information about the current supply.
  Future<RpcContextResponse<Supply>> getSupplyRaw({
    final GetSupplyConfig? config, 
  }) {
    parse(result) => RpcContextResult.parse(result, Supply.fromJson);
    return _request(Method.getSupply, [], parse, config: config);
  }

  /// Returns information about the current supply.
  Future<Supply> getSupply({
    final GetSupplyConfig? config, 
  }) {
    return getSupplyRaw(config: config).unwrap();
  }

  /// Returns the token balance of an SPL Token [account].
  Future<RpcContextResponse<TokenAmount>> getTokenAccountBalanceRaw(
    final PublicKey account, {
    final GetTokenAccountBalanceConfig? config, 
  }) {
    parse(result) => RpcContextResult.parse(result, TokenAmount.fromJson);
    return _request(Method.getTokenAccountBalance, [account.toBase58()], parse, config: config);
  }

  /// Returns the token balance of an SPL Token [account].
  Future<TokenAmount> getTokenAccountBalance(
    final PublicKey account, {
    final GetTokenAccountBalanceConfig? config, 
  }) {
    return getTokenAccountBalanceRaw(account, config: config).unwrap();
  }

  /// Returns all SPL Token accounts approved by [delegate].
  Future<RpcContextResponse<List<TokenAccount>>> getTokenAccountsByDelegateRaw(
    final PublicKey delegate, {
    required final TokenAccountsFilter filter,
    final GetTokenAccountsByDelegateConfig? config, 
  }) {
    final params = [delegate.toBase58(), filter.toJson()];
    parse(result) => RpcContextResult.parse(result, _listParser(TokenAccount.fromJson));
    return _request(Method.getTokenAccountsByDelegate, params, parse, config: config ?? GetTokenAccountsByDelegateConfig());
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
  Future<RpcContextResponse<List<TokenAccount>>> getTokenAccountsByOwnerRaw(
    final PublicKey account, {
    required final TokenAccountsFilter filter,
    final GetTokenAccountsByOwnerConfig? config, 
  }) {
    final params = [account.toBase58(), filter.toJson()];
    parse(result) => RpcContextResult.parse(result, _listParser(TokenAccount.fromJson));
    return _request(Method.getTokenAccountsByOwner, params, parse, config: config ?? GetTokenAccountsByOwnerConfig());
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
  Future<RpcContextResponse<List<TokenAmount>>> getTokenLargestAccountsRaw(
    final PublicKey mint, {
    final GetTokenLargestAccountsConfig? config, 
  }) {
    parse(result) => RpcContextResult.parse(result, _listParser(TokenAmount.fromJson));
    return _request(Method.getTokenLargestAccounts, [mint.toBase58()], parse, config: config);
  }

  /// Returns the 20 largest accounts of a particular SPL Token type.
  Future<List<TokenAmount>> getTokenLargestAccounts(
    final PublicKey mint, {
    final GetTokenLargestAccountsConfig? config, 
  }) {
    return getTokenLargestAccountsRaw(mint, config: config).unwrap();
  }

  /// Returns the total supply of an SPL Token type.
  Future<RpcContextResponse<TokenAmount>> getTokenSupplyRaw(
    final PublicKey mint, {
    final GetTokenSupplyConfig? config, 
  }) {
    parse(result) => RpcContextResult.parse(result, TokenAmount.fromJson);
    return _request(Method.getTokenSupply, [mint.toBase58()], parse, config: config);
  }

  /// Returns the total supply of an SPL Token type.
  Future<TokenAmount> getTokenSupply(
    final PublicKey mint, {
    final GetTokenSupplyConfig? config, 
  }) {
    return getTokenSupplyRaw(mint, config: config).unwrap();
  }

  /// Returns transaction details for a confirmed transaction signature (base-58).
  Future<RpcResponse<TransactionInfo?>> getTransactionRaw(
    final String signature, {
    final GetTransactionConfig? config, 
  }) {
    return _request(Method.getTransaction, [signature], TransactionInfo.tryParse, config: config);
  }

  /// Returns transaction details for a confirmed transaction signature (base-58).
  Future<TransactionInfo?> getTransaction(
    final String signature, {
    final GetTransactionConfig? config, 
  }) {
    return getTransactionRaw(signature, config: config).unwrap();
  }

  /// Returns the current [Transaction] count from the ledger.
  Future<RpcResponse<u64>> getTransactionCountRaw({
    final GetTransactionCountConfig? config, 
  }) {
    return _request(Method.getTransactionCount, [], utils.cast<u64>, config: config);
  }

  /// Returns the current [Transaction] count from the ledger.
  Future<u64> getTransactionCount({
    final GetTransactionCountConfig? config, 
  }) {
    return getTransactionCountRaw(config: config).unwrap();
  }

  /// Returns the current solana versions running on the node.
  Future<RpcResponse<Version>> getVersionRaw({
    final GetVersionConfig? config, 
  }) {
    return _request(Method.getVersion, [], Version.fromJson, config: config);
  }

  /// Returns the current solana versions running on the node.
  Future<Version> getVersion({
    final GetVersionConfig? config, 
  }) {
    return getVersionRaw(config: config).unwrap();
  }

  /// Returns the account info and associated stake for all the voting accounts in the current bank.
  Future<RpcResponse<VoteAccountStatus>> getVoteAccountsRaw({
    final GetVoteAccountsConfig? config, 
  }) {
    return _request(Method.getVoteAccounts, [], VoteAccountStatus.fromJson, config: config);
  }

  /// Returns the account info and associated stake for all the voting accounts in the current bank.
  Future<VoteAccountStatus> getVoteAccounts({
    final GetVoteAccountsConfig? config, 
  }) {
    return getVoteAccountsRaw(config: config).unwrap();
  }

  /// Returns whether a [blockhash] (base-58) is still valid or not.
  Future<RpcContextResponse<bool>> isBlockhashValidRaw(
    final String blockhash, {
    final IsBlockhashValidConfig? config, 
  }) {
    parse(result) => RpcContextResult.parse(result, utils.cast<bool>);
    return _request(Method.isBlockhashValid, [blockhash], parse, config: config);
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
  Future<RpcResponse<u64>> minimumLedgerSlotRaw({
    final MinimumLedgerSlotConfig? config, 
  }) {
    return _request(Method.minimumLedgerSlot, [], utils.cast<u64>, config: config);
  }

  /// Returns the lowest slot that the node has information about in its ledger. This value may 
  /// increase over time if the node is configured to purge older ledger data.
  Future<u64> minimumLedgerSlot({
    final MinimumLedgerSlotConfig? config, 
  }) {
    return minimumLedgerSlotRaw(config: config).unwrap();
  }

  /// Requests an airdrop of [lamports] to [publicKey].
  Future<RpcResponse<String>> requestAirdropRaw(
    final PublicKey publicKey, 
    final u64 lamports, {
    final RequestAirdropConfig? config,
  }) {
    return _request(
      Method.requestAirdrop, 
      [publicKey.toBase58(), lamports], utils.cast<String>, config: config,
    );
  }

  /// Requests an airdrop of [lamports] to [publicKey].
  Future<String> requestAirdrop(
    final PublicKey publicKey, 
    final u64 lamports, {
    final RequestAirdropConfig? config,
  }) {
    return requestAirdropRaw(publicKey, lamports, config: config).unwrap();
  }

  /// Sign and send a [transaction] to the cluster for processing.
  Future<RpcResponse<TransactionSignature>> sendTransactionRaw(
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

    final String signedTransaction = transaction.serialise().getString(BufferEncoding.base64);
    config ??= SendTransactionConfig(encoding: TransactionEncoding.base64);
    return _request(Method.sendTransaction, [signedTransaction], utils.cast<String>, config: config);
  }

  /// Sign and send a [transaction] to the cluster for processing.
  Future<TransactionSignature> sendTransaction(
    final Transaction transaction, {
    final List<Signer> signers = const [],
    final SendTransactionConfig? config,
  }) async {
    return sendTransactionRaw(transaction, signers: signers, config: config).unwrap();
  }

  /// Simulates sending a transaction.
  Future<RpcContextResponse<TransactionStatus>> simulateTransactionRaw(
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

        if (signers == null) break;

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

    final String signedTransaction = transaction.serialise().getString(BufferEncoding.base64);
    parse(result) => RpcContextResult.parse(result, TransactionStatus.fromJson);
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

  /// 
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

  /// 
  Future<dynamic> confirmTransaction(
    final TransactionSignature signature, {
    final List<Signer> signers = const [],
    final ConfirmTransactionConfig? config,
  }) async {

    late Uint8List decodedSignature;

    try {
      decodedSignature = convert.base58.decode(signature);
    } catch (error) {
      throw TransactionException('Failed to decode base58 signature $signature');
    }

    utils.require(decodedSignature.length == signatureLength, 'Invalid signature length.');

    final Commitment commitment = config?.commitment ?? Commitment.finalized;
    final Completer completer = Completer.sync();

    try {

      final WebSocketSubscription subscription = await signatureSubscribe(
        signature, 
        config: SignatureSubscribeConfig(
          commitment: commitment,
          timeout: Duration(seconds: commitment == Commitment.finalized ? 60 : 30),
        ),
      );

      subscription.on(
        (data) { 
          print('SIGNATURE CONFIRMATION: $data');
          completer.complete(data);
        },
        onDone: () {
          completer.completeError('Subscription closed.');
        }
      );

    } catch (error) {
      return completer.completeError('Woops');
    }

    return completer.future;
  }


  /// Creates an `onTimeout` callback function for a [_webSocketExchange].
  Future<RpcResponse<T>> Function() _onWebSocketExchangeTimeout<T>() => () {
    return Future.error(TimeoutException('The web socket request has timed out.'));
  };

  /// Removes the [ids] and their associated values from [_webSocketExchangeManager].
  void _webSocketExchangeRemove(List<int?> ids) {
    for (final int? id in ids) {
      if (id != null) {
        _webSocketExchangeManager.remove(id);
      }
    }
  }

  /// Makes a JSON-RPC data request to the web [socket] server.
  /// 
  /// The request's `timeout` duration can be set using the [config] object's 
  /// [RpcRequestConfig.timeout] property. 
  /// 
  /// All other configurations are ignored.
  Future<RpcResponse<T>> _webSocketExchange<T>(
    final RpcRequest request, {
    final RpcRequestConfig? config,
  }) async {

    // The subscription's request/response cycle.
    WebSocketExchange<T>? exchange;

    try {
      // Get the web socket connection.
      final WebSocket connection = await socket.connect();

      // Get the timestamp at which the current connection was established.
      final DateTime? connectedAt = socket.connectedAt;
      if (connectedAt == null) {
        throw const WebSocketException('[WebSocketConnection.connectedAt] is null.');
      }
      
      // Get the existing request/response cycle (if it exists).
      exchange = _webSocketExchangeManager.get(request.hash());

      // If an exchange created using the current connection exists, return the response (which may 
      // still be pending).
      if (exchange != null) {
        if (exchange.createdAt.isBefore(connectedAt)) {
          if (exchange.isCompleted) {
            await _webSocketSubscriptionManager.close(exchangeId: exchange.id);
          } else {
            throw const WebSocketException('The exchange request expired.');
          }
        } else {
          return exchange.response;
        }
      }

      // 
      assert(
        exchange == null ? request.id == null : request.id == exchange.id, 
        'A [WebSocketExchange] must be initialised with a new or existing exchange request.',
      );

      // Create a WebSocketExchange for the subscription's request/response cycle.
      exchange = WebSocketExchange<T>(request);

      // Store the exchange (request/response) to be used for future subscriptions or cancellation.
      _webSocketExchangeManager.set(exchange);

      // Send the request to the JSON-RPC web socket server (the response will be recevied by 
      // `onSocketData`).
      connection.add(json.encode(exchange.request.toJson()));

      // Return the pending subscription that completes when a success response is received from the 
      // web socket server (onSocketData) or the request times out.
      final Duration timeLimit = config?.timeout ?? const Duration(seconds: 60);
      return await exchange.response.timeout(timeLimit, onTimeout: _onWebSocketExchangeTimeout());

    } catch (error, stackTrace) {
      print('_webSocketRequest() Error : $error');
      _webSocketExchangeRemove([exchange?.id]);
      exchange?.completeError(error, stackTrace);
      return Future.error(error, stackTrace);
    }
  }

  ///
  Future<WebSocketSubscription> resubscribe(
    final WebSocketExchange exchange, {
    final RpcRequestConfig? config,
  }) async {
    final RpcRequest request = exchange.request;
    final RpcSubscribeResponse response = await _webSocketExchange<int>(request, config: config);
    return _webSocketSubscriptionManager.subscribe(response);
  }

  /// Subscribes to the JSON-RPC PubSub [method] to receive notifications sent by the web socket 
  /// server.
  /// 
  /// Returns a [WebSocketSubscription] that can be used to attach notification handlers.
  /// 
  /// The subscription [method] is invoked with the provided [params].
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
  Future<WebSocketSubscription> subscribe(
    final Method method,
    final List<Object> params, {
    final RpcSubscribeConfig? config,
  }) async {
    final RpcRequest request = RpcRequest.build(method, params, config);
    final RpcSubscribeResponse response = await _webSocketExchange<int>(request, config: config);
    final x = _webSocketSubscriptionManager.subscribe(response);
    print('WSEM SUBSCRIBE $_webSocketExchangeManager');
    print('WSSM SUBSCRIBE $_webSocketSubscriptionManager');
    return x;
  }

  /// Unsubscribes from the JSON-RPC PubSub [method] to stop receiving notifications sent by the web 
  /// socket server.
  /// 
  /// Returns a `success` response ([RpcUnsubscribeResponse.result] == `true`) for invalid 
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
  /// final RpcUnsubscribeResponse response = await connection.unsubscribe(
  ///   method,
  ///   subscription,
  /// );
  /// 
  /// print(response.result); // true
  /// ```
  Future<RpcUnsubscribeResponse> unsubscribe(
    final Method method,
    final WebSocketSubscription subscription, {
    final RpcUnsubscribeConfig? config,
  }) async {

    // Cancel the stream listener.
    await _webSocketSubscriptionManager.unsubscribe(subscription);

    // Create the return response (default to `success`).
    RpcUnsubscribeResponse response = RpcUnsubscribeResponse.fromResult(true);

    // If the stream has no more listeners, cancel the web socket subscription.
    if (!_webSocketSubscriptionManager.hasListener(subscription.id)) {
      try {
        final RpcRequest request = RpcRequest.build(method, [subscription.id], config);
        response = await _webSocketExchange<bool>(request, config: config);
        _webSocketExchangeRemove([subscription.exchangeId, response.id]);
        
      } catch(error, stackTrace) {
        // Ignore errors related to subscription ids that do not exist.
        //
        // For example, if a user calls unsubscribe twice for a [subscription] with a single 
        // listener, an invalid subscription id error will be thrown for the second invocation.
        if (RpcException.isType(error, RpcExceptionCode.invalidSubscriptionId)) {
          _webSocketExchangeRemove([subscription.exchangeId]);
        } else {
          return Future.error(error, stackTrace);
        }
      }
    }

    print('WSEM UNSUBSCRIBE $_webSocketExchangeManager');
    print('WSSM UNSUBSCRIBE $_webSocketSubscriptionManager');
    return response;
  }

  /// Subscribes to an account to receive notifications when the lamports or data for a given 
  /// account's [publicKey] changes.
  Future<WebSocketSubscription> accountSubscribe(
    final PublicKey publicKey, {
    final AccountSubscribeConfig? config,
  }) async {
    return subscribe(Method.accountSubscribe, [publicKey.toBase58()], config: config);
  }

  /// Unsubscribes from account change notifications.
  Future<RpcUnsubscribeResponse> accountUnsubscribe(
    final WebSocketSubscription subscription, {
    final AccountUnsubscribeConfig? config,
  }) async {
    return unsubscribe(Method.accountUnsubscribe, subscription, config: config);
  }

  /// Subscribe to transaction logging.
  Future<WebSocketSubscription> logsSubscribe(
    final LogsFilter filter, {
    final LogsSubscribeConfig? config,
  }) async {
    return subscribe(Method.logsSubscribe, [filter.value], config: config);
  }

  /// Unsubscribes from transaction logging.
  Future<RpcUnsubscribeResponse> logsUnsubscribe(
    final WebSocketSubscription subscription, {
    final LogsUnsubscribeConfig? config,
  }) async {
    return unsubscribe(Method.logsUnsubscribe, subscription, config: config);
  }

  /// Subscribes to a program to receive notifications when the lamports or data for a given account 
  /// owned by the program changes.
  Future<WebSocketSubscription> programSubscribe(
    final PublicKey programId, {
    final ProgramSubscribeConfig? config,
  }) async {
    return subscribe(Method.programSubscribe, [programId.toBase58()], config: config);
  }

  /// Unsubscribes from program changes.
  Future<RpcUnsubscribeResponse> programUnsubscribe(
    final WebSocketSubscription subscription, {
    final ProgramUnsubscribeConfig? config,
  }) async {
    return unsubscribe(Method.programUnsubscribe, subscription, config: config);
  }

  /// Subscribes to a transaction signature to receive a `signatureNotification` when the 
  /// transaction is confirmed, the subscription is automatically cancelled.
  /// 
  /// TODO: Cancel stream if there are no other listeners.
  Future<WebSocketSubscription> signatureSubscribe(
    final TransactionSignature signature, {
    final SignatureSubscribeConfig? config,
  }) async {
    final WebSocketSubscription subscription = await subscribe(
      Method.signatureSubscribe, 
      [signature], 
      config: config,
    );
    _webSocketExchangeRemove([subscription.exchangeId]);
    print('WSEM UNSUBSCRIBE $_webSocketExchangeManager');
    print('WSSM UNSUBSCRIBE $_webSocketSubscriptionManager');
    return subscription;
  }

  /// Unsubscribes from signature confirmation notifications.
  Future<RpcUnsubscribeResponse> signatureUnsubscribe(
    final WebSocketSubscription subscription, {
    final SignatureUnsubscribeConfig? config,
  }) async {
    return unsubscribe(Method.signatureUnsubscribe, subscription, config: config);
  }

  /// Subscribes to receive notifications anytime a slot is processed by the validator.
  Future<WebSocketSubscription> slotSubscribe({
    final SlotSubscribeConfig? config,
  }) async {
    return subscribe(Method.slotSubscribe, [], config: config);
  }

  /// Unsubscribes from slot updates.
  Future<RpcUnsubscribeResponse> slotUnsubscribe(
    final WebSocketSubscription subscription, {
    final SlotUnsubscribeConfig? config,
  }) async {
    return unsubscribe(Method.slotUnsubscribe, subscription, config: config);
  }

  /// Subscribes to receive notifications anytime a new root is set by the validator.
  Future<WebSocketSubscription> rootSubscribe({
    final RootSubscribeConfig? config,
  }) async {
    return subscribe(Method.rootSubscribe, [], config: config);
  }

  /// Unsubscribes from root changes.
  Future<RpcUnsubscribeResponse> rootUnsubscribe(
    final WebSocketSubscription subscription, {
    final RootUnsubscribeConfig? config,
  }) async {
    return unsubscribe(Method.rootUnsubscribe, subscription, config: config);
  }
}