/// Imports
/// ------------------------------------------------------------------------------------------------

import 'rpc_request_config.dart';


/// RPC Unsubscribe Config
/// ------------------------------------------------------------------------------------------------

class RpcUnsubscribeConfig extends RpcRequestConfig {

  /// Defines the configurations for JSON-RPC `unsubscribe` requests.
  const RpcUnsubscribeConfig({
    super.id,
    super.timeout,
  }): super(headers: null);

  @override
  Map<String, Object> object() => {};
}