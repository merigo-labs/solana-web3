/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/rpc/rpc_request.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';


/// RPC Subscribe Config
/// ------------------------------------------------------------------------------------------------

abstract class RpcSubscribeConfig extends RpcRequestConfig {

  /// Defines the configurations for JSON-RPC `subscribe` requests.
  /// 
  /// The [id] property is used internally to map requests to responses.
  const RpcSubscribeConfig({
    super.timeout,
  }): super(id: null, headers: null);

  /// Returns the result of [object].
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
  Map<String, dynamic> objectClean() {
    final Map<String, dynamic> object = this.object();
    assert(object.values.every((value) => value != null));
    return object;
  }
}