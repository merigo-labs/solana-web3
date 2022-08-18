/// Imports
/// ------------------------------------------------------------------------------------------------

import 'rpc_request_config.dart';
import '../rpc/rpc_request.dart';
import '../types/commitment.dart';


/// RPC Subscribe Config
/// ------------------------------------------------------------------------------------------------

abstract class RpcSubscribeConfig extends RpcRequestConfig {

  /// Defines the configurations for JSON-RPC `subscribe` requests.
  /// 
  /// The [id] property is used internally to map requests to responses.
  const RpcSubscribeConfig({
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
  /// Classes derived from [RpcSubscribeConfig] cannot contain `null` valued properties. This is 
  /// required to ensure that all JSON-RPC requests produce the same [RpcRequest.hash].
  /// 
  /// For example:
  /// 
  ///   * A JSON-RPC method call may assign a default commitment value of [Commitment.finalized].
  /// 
  /// ```
  ///   { 'commitment': null } == { 'commitment': 'finalized' }
  /// ```
  /// 
  ///   * However, allowing `null` valued properties produces two different [RpcRequest.hash] values 
  ///     for the same request.
  /// 
  /// ```
  ///   { 'commitment': null }        -> "{ commitment: null }"
  ///   { 'commitment': 'finalized' } -> "{ commitment: finalized }"
  /// ```
  @override
  Map<String, dynamic> object();
}