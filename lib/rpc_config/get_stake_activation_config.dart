/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/utils/types.dart' show u64;
import 'commitment_and_min_context_slot_config.dart';


/// Get Stake Activation Config
/// ------------------------------------------------------------------------------------------------

class GetStakeActivationConfig extends CommitmentAndMinContextSlotConfig {

  /// JSON-RPC configurations for `getStakeActivation` methods.
  const GetStakeActivationConfig({
    super.id,
    super.headers,
    super.timeout,
    super.commitment,
    this.epoch,
    super.minContextSlot,
  }): assert(minContextSlot == null || minContextSlot >= 0);

  /// The epoch for which to calculate activation details. If omitted, defaults to current epoch.
  final u64? epoch;
  
  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'epoch': epoch,
    'minContextSlot': minContextSlot,
  };
}