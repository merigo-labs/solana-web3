/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/protocol/json_rpc_request_config.dart';


/// Empty Request Config
/// ------------------------------------------------------------------------------------------------

class EmptyRequestConfig extends JsonRpcRequestConfig {

  /// JSON-RPC configuration object with no additional properties.
  const EmptyRequestConfig({
    super.id,
    super.headers,
    super.timeout,
  });

  @override
  Map<String, dynamic> object() => {};
}