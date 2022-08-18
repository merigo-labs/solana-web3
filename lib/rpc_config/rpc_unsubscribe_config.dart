/// Imports
/// ------------------------------------------------------------------------------------------------

import 'rpc_request_config.dart';


/// RPC Unsubscribe Config
/// ------------------------------------------------------------------------------------------------

class RpcUnsubscribeConfig extends RpcRequestConfig {

  /// Defines the configurations for JSON-RPC `unsubscribe` requests.
  const RpcUnsubscribeConfig({
    super.timeout,
  }): super(id: null, headers: null);

  @override
  Map<String, Object> object() => {};
}