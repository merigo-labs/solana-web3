/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/protocol/json_rpc_request.dart';
import 'package:solana_common/protocol/json_rpc_request_config.dart';
import '../types/commitment.dart';


/// JSON RPC Subscribe Config
/// ------------------------------------------------------------------------------------------------

abstract class JsonRpcSubscribeConfig extends JsonRpcRequestConfig {

  /// Defines the configurations for JSON-RPC `subscribe` requests.
  /// 
  /// The [id] property is used internally to map requests to responses.
  const JsonRpcSubscribeConfig({
    super.timeout,
  }): super(id: null, headers: null);

  /// Returns the `configuration object` passed to a method call as the last item in the `params` 
  /// list.
  /// 
  /// ```
  /// {
  ///   'jsonrpc': '2.0',
  ///   ...,
  ///   'params': [
  ///     '3C4iYswhNe7Z2LJvxc9qQmF55rsKDUGdiuKVUGpTbRsK',
  ///     // The value returned by this object() call
  ///     {
  ///       'commitment': 'processed',
  ///     }
  ///   ]
  /// }
  /// ```
  /// 
  /// Classes derived from [JsonRpcSubscribeConfig] cannot contain `null` valued properties. This is 
  /// required to ensure that all JSON-RPC requests produce the same [JsonRpcRequest.hash].
  /// 
  /// For example:
  /// 
  ///   * A JSON-RPC method call may assign a default commitment value of [Commitment.finalized].
  /// 
  /// ```
  ///   { 'commitment': null } == { 'commitment': 'finalized' }
  /// ```
  /// 
  ///   * However, allowing `null` valued properties produces two different [JsonRpcRequest.hash] 
  ///     values for the same request.
  /// 
  /// ```
  ///   { 'commitment': null }        -> "{ commitment: null }"
  ///   { 'commitment': 'finalized' } -> "{ commitment: finalized }"
  /// ```
  @override
  Map<String, dynamic> object();
}