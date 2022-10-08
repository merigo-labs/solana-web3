/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/utils/types.dart' show u64;
import 'commitment_config.dart';


/// Get Inflation Reward Config
/// ------------------------------------------------------------------------------------------------

class GetInflationRewardConfig extends CommitmentConfig {

  /// JSON-RPC configurations for `getInflationReward` methods.
  const GetInflationRewardConfig({
    super.id,
    super.headers,
    super.timeout,
    super.commitment,
    this.epoch,
    this.minContextSlot,
  }): assert(minContextSlot == null || minContextSlot >= 0);

  /// The epoch for which the reward occurs. If omitted, the previous epoch will be used.
  final u64? epoch;

  /// The minimum slot that the request can be evaluated at.
  final u64? minContextSlot;
  
  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'epoch': epoch,
    'minContextSlot': minContextSlot,
  };
}