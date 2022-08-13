/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/rpc/rpc_request_config.dart';


/// RPC Bulk Request Config
/// ------------------------------------------------------------------------------------------------

class RpcBulkRequestConfig extends RpcRequestConfig {
  
  /// Defines the configurations for JSON-RPC `bulk` requests.
  const RpcBulkRequestConfig({
    super.headers,
    super.timeout,
  }): super(id: null);

  @override
  Map<String, dynamic> object() => {};
}