/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/rpc/rpc_subscribe_config.dart';


/// Logs Subscribe Config
/// ------------------------------------------------------------------------------------------------

class LogsSubscribeConfig extends RpcSubscribeConfig {

  /// Defines the configurations for JSON-RPC `logsSubscribe` requests.
  LogsSubscribeConfig({
    super.timeout,
    this.commitment = Commitment.finalized,
  });

  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment commitment;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment.name,
  };
}