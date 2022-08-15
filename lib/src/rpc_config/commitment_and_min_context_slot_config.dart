/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';
import 'package:solana_web3/src/rpc_config/commitment_config.dart';


/// Commitment And MinContext Slot Config
/// ------------------------------------------------------------------------------------------------

class CommitmentAndMinContextSlotConfig extends CommitmentConfig {

  /// JSON-RPC configurations for `commitment` and `minContextSlot`.
  const CommitmentAndMinContextSlotConfig({
    super.id,
    super.headers,
    super.timeout,
    super.commitment,
    this.minContextSlot,
  });

  /// The minimum slot that the request can be evaluated at.
  final num? minContextSlot;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'minContextSlot': minContextSlot,
  };
}