/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/rpc/rpc_request_config.dart';


/// Empty Request Config
/// ------------------------------------------------------------------------------------------------

class EmptyRequestConfig extends RpcRequestConfig {

  /// JSON-RPC configuration object with no additional properties.
  const EmptyRequestConfig({
    super.id,
    super.headers,
    super.timeout,
  });

  @override
  Map<String, dynamic> object() => {};
}