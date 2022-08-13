/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/commitment.dart';
import 'package:solana_web3/rpc/rpc_request_config.dart';


/// Commitment And MinContext Slot Config
/// ------------------------------------------------------------------------------------------------

class CommitmentAndMinContextSlotConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `commitment` and `minContextSlot`.
  const CommitmentAndMinContextSlotConfig({
    super.id,
    super.headers,
    super.timeout,
    this.commitment = Commitment.finalized,
    this.minContextSlot,
  });

  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment commitment;

  /// The minimum slot that the request can be evaluated at.
  final num? minContextSlot;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment.name,
    'minContextSlot': minContextSlot,
  };
}