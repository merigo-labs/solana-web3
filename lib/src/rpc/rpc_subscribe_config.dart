/// Imports
/// ------------------------------------------------------------------------------------------------

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
}