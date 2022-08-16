/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/serialisable.dart';
import 'package:solana_web3/src/utils/types.dart' show u64;


/// Epoch Schedule
/// ------------------------------------------------------------------------------------------------

class EpochSchedule extends Serialisable {
  
  /// Epoch schedule information from a cluster's genesis config.
  const EpochSchedule({
    required this.slotsPerEpoch,
    required this.leaderScheduleSlotOffset,
    required this.warmup,
    required this.firstNormalEpoch,
    required this.firstNormalSlot,
  });

  /// The maximum number of slots in each epoch.
  final u64 slotsPerEpoch;

  /// The number of slots before beginning an epoch to calculate a leader schedule for that epoch.
  final u64 leaderScheduleSlotOffset;

  /// Whether epochs start short and grow.
  final bool warmup;
  
  /// The first normal-length epoch, log2(slotsPerEpoch) - log2(MINIMUM_SLOTS_PER_EPOCH).
  final u64 firstNormalEpoch;
  
  /// MINIMUM_SLOTS_PER_EPOCH * (2.pow(firstNormalEpoch) - 1).
  final u64? firstNormalSlot;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// EpochSchedule.fromJson({ '<parameter>': <value> });
  /// ```
  factory EpochSchedule.fromJson(final Map<String, dynamic> json) => EpochSchedule(
    slotsPerEpoch: json['slotsPerEpoch'],
    leaderScheduleSlotOffset: json['leaderScheduleSlotOffset'],
    warmup: json['warmup'],
    firstNormalEpoch: json['firstNormalEpoch'],
    firstNormalSlot: json['firstNormalSlot'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// EpochSchedule.tryFromJson({ '<parameter>': <value> });
  /// ```
  static EpochSchedule? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? EpochSchedule.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'slotsPerEpoch': slotsPerEpoch,
    'leaderScheduleSlotOffset': leaderScheduleSlotOffset,
    'warmup': warmup,
    'firstNormalEpoch': firstNormalEpoch,
    'firstNormalSlot': firstNormalSlot,
  };
}