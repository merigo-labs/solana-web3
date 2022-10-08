/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:math' as math show pow;
import 'package:solana_common/utils/types.dart';
import '../solana_web3.dart';


/// Epoch Schedule
/// ------------------------------------------------------------------------------------------------

/// The minimum number of slots per epoch.
const int minimumSlotPerEpoch = 32;

/// Returns the number of trailing zeros in the binary representation of [n].
int trailingZeros(num n) {
  int trailingZeros = 0;
  while (n > 1) {
    n /= 2;
    ++trailingZeros;
  }
  return trailingZeros;
}

/// Returns the smallest power of two greater than or equal to [n].
int nextPowerOfTwo(int n) {
  if (n == 0) {
    return 1;
  }
  --n;
  n |= n >> 1;
  n |= n >> 2;
  n |= n >> 4;
  n |= n >> 8;
  n |= n >> 16;
  n |= n >> 32;
  return n + 1;
}

/// Epoch schedule
/// (see https://docs.solana.com/terminology#epoch)
/// Can be retrieved with the method [Connection.getEpochSchedule].
class EpochSchedule {

  /// Epoch schedule/
  const EpochSchedule({
    required this.slotsPerEpoch,
    required this.leaderScheduleSlotOffset,
    required this.warmup,
    required this.firstNormalEpoch,
    required this.firstNormalSlot,
  });

  /// The maximum number of slots in each epoch.
  final u64 slotsPerEpoch;

  /// The number of slots before beginning of an epoch to calculate a leader schedule for that epoch.
  final u64 leaderScheduleSlotOffset;
  
  /// Indicates whether epochs start short and grow.
  final bool  warmup;

  /// The first epoch with `slotsPerEpoch` slots.
  final u64 firstNormalEpoch;
  
  /// The first slot of `firstNormalEpoch`.
  final u64 firstNormalSlot;

  u64 getEpoch(final u64 slot) => getEpochAndSlotIndex(slot)[0];

  List<u64> getEpochAndSlotIndex(final u64 slot) {
    if (slot < firstNormalSlot) {
      final epoch =
        trailingZeros(nextPowerOfTwo(slot + minimumSlotPerEpoch + 1)) -
        trailingZeros(minimumSlotPerEpoch) -
        1;
      final epochLen = getSlotsInEpoch(epoch);
      final slotIndex = slot - (epochLen - minimumSlotPerEpoch);
      return [epoch, slotIndex];
    } else {
      final normalSlotIndex = slot - firstNormalSlot;
      final normalEpochIndex = (normalSlotIndex / slotsPerEpoch).floor();
      final epoch = firstNormalEpoch + normalEpochIndex;
      final slotIndex = normalSlotIndex % slotsPerEpoch;
      return [epoch, slotIndex];
    }
  }

  u64 getFirstSlotInEpoch(final u64 epoch) {
    return epoch <= firstNormalEpoch
      ? (math.pow(2, epoch).toInt() - 1) * minimumSlotPerEpoch
      : (epoch - firstNormalEpoch) * slotsPerEpoch + firstNormalSlot;
  }

  u64 getLastSlotInEpoch(final u64 epoch) {
    return getFirstSlotInEpoch(epoch) + getSlotsInEpoch(epoch) - 1;
  }

  u64 getSlotsInEpoch(final u64 epoch) {
    return epoch < firstNormalEpoch
      ? math.pow(2, epoch + trailingZeros(minimumSlotPerEpoch)).toInt()
      : slotsPerEpoch;
  }
}