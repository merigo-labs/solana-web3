/// Imports
/// ------------------------------------------------------------------------------------------------

import 'rpc_subscribe_config.dart';
import '../types/commitment.dart';


/// Commitment Subscribe Config
/// ------------------------------------------------------------------------------------------------

class CommitmentSubscribeConfig extends RpcSubscribeConfig {

  /// JSON-RPC PubSub configurations for `subscribe` methods.
  const CommitmentSubscribeConfig({
    super.timeout,
    this.commitment,
  });

  /// The type of block to query for the request.
  final Commitment? commitment;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
  };
}