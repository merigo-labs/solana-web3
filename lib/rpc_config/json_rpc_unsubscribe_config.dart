/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/protocol/json_rpc_request_config.dart';


/// JSON RPC Unsubscribe Config
/// ------------------------------------------------------------------------------------------------

class JsonRpcUnsubscribeConfig extends JsonRpcRequestConfig {

  /// Defines the configurations for JSON-RPC `unsubscribe` requests.
  const JsonRpcUnsubscribeConfig({
    super.id,
    super.timeout,
  }): super(headers: null);

  @override
  Map<String, Object> object() => {};
}