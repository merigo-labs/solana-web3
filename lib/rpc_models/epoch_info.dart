/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/types.dart' show u64;


/// Epoch Info
/// ------------------------------------------------------------------------------------------------

class EpochInfo extends Serializable {
  
  /// Information about an epoch.
  const EpochInfo({
    required this.absoluteSlot,
    required this.blockHeight,
    required this.epoch,
    required this.slotIndex,
    required this.slotsInEpoch,
    required this.transactionCount,
  });

  /// The epoch slot.
  final u64 absoluteSlot;

  /// The epoch block height.
  final u64 blockHeight;

  /// The epoch.
  final u64 epoch;

  /// The slot relative to the start of [epoch].
  final u64 slotIndex;
  
  /// The number of slots in [epoch].
  final u64 slotsInEpoch;
  
  /// The total number of transactions processed without error since genesis up to [epoch].
  final u64? transactionCount;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// EpochInfo.fromJson({ '<parameter>': <value> });
  /// ```
  factory EpochInfo.fromJson(final Map<String, dynamic> json) => EpochInfo(
    absoluteSlot: json['absoluteSlot'],
    blockHeight: json['blockHeight'],
    epoch: json['epoch'],
    slotIndex: json['slotIndex'],
    slotsInEpoch: json['slotsInEpoch'],
    transactionCount: json['transactionCount'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// EpochInfo.tryFromJson({ '<parameter>': <value> });
  /// ```
  static EpochInfo? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? EpochInfo.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'absoluteSlot': absoluteSlot,
    'blockHeight': blockHeight,
    'epoch': epoch,
    'slotIndex': slotIndex,
    'slotsInEpoch': slotsInEpoch,
    'transactionCount': transactionCount,
  };
}