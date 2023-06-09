/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_jsonrpc/types.dart' show SubscriptionId;
import 'package:solana_web3/src/rpc/models/logs_filter.dart';
import '../configs/logs_subscribe_config.dart';
import '../interfaces/json_rpc_type_method.dart';


/// Logs Subscribe
/// ------------------------------------------------------------------------------------------------

/// A method handler for `logsSubscribe`.
class LogsSubscribe extends JsonRpcTypeMethod<SubscriptionId> {
  
  /// Creates a method handler for `logsSubscribe`.
  LogsSubscribe(
    final LogsFilter filter, {
    final LogsSubscribeConfig? config,
  }): super(
    'logsSubscribe', 
    values: [filter.toJson()], 
    config: config ?? const LogsSubscribeConfig(),
  );
}