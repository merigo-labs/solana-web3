/// Imports
/// ------------------------------------------------------------------------------------------------

import '../src/utils/types.dart' show u64;
import '../types/method.dart';
import 'rpc_request_config.dart';


/// RPC Unsubscribe Config
/// ------------------------------------------------------------------------------------------------

class RpcUnsubscribeConfig extends RpcRequestConfig {

  /// Defines the configurations for JSON-RPC `unsubscribe` requests.
  RpcUnsubscribeConfig({
    super.headers,
    super.timeout,
    required this.method,
    required this.subscriptionId,
  }): super(id: null);

  /// The unsubscribe method to invoke.
  final Method method;

  /// The subscription id to cancel.
  final u64 subscriptionId;

  @override
  Map<String, dynamic> object() => {
    'method': method.name,
    'params': [subscriptionId],
  };
}