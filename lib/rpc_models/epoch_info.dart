/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert' show base64;
import 'package:solana_common/borsh/borsh.dart';
import 'package:solana_common/utils/types.dart' show u64;


/// Epoch Info
/// ------------------------------------------------------------------------------------------------

class EpochInfo extends BorshSerializable {
  
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

  @override
  BorshSchema get schema => codec.schema;

  /// {@macro solana_common.BorshSerializable.codec}
  static final BorshStructCodec codec = borsh.struct({
    'absoluteSlot': borsh.i64,
    'blockHeight': borsh.i64,
    'epoch': borsh.i64,
    'slotIndex': borsh.i64,
    'slotsInEpoch': borsh.i64,
    'transactionCount': borsh.i64,
  });

  /// {@macro solana_common.BorshSerializable.deserialize}
  static EpochInfo deserialize(final Iterable<int> buffer) {
    return borsh.deserialize(codec.schema, buffer, EpochInfo.fromJson);
  }

  /// {@macro solana_common.BorshSerializable.tryDeserialize}
  static EpochInfo? tryDeserialize(final Iterable<int>? buffer)
    => buffer != null ? EpochInfo.deserialize(buffer) : null;

  /// {@macro solana_common.BorshSerializable.fromBase64}
  factory EpochInfo.fromBase64(final String encoded) 
    => EpochInfo.deserialize(base64.decode(encoded));

  /// {@macro solana_common.BorshSerializable.tryFromBase64}
  static EpochInfo? tryFromBase64(final String? encoded)
    => encoded != null ? EpochInfo.fromBase64(encoded) : null;

  /// {@macro solana_common.Serializable.fromJson}
  factory EpochInfo.fromJson(final Map<String, dynamic> json) => EpochInfo(
    absoluteSlot: json['absoluteSlot'],
    blockHeight: json['blockHeight'],
    epoch: json['epoch'],
    slotIndex: json['slotIndex'],
    slotsInEpoch: json['slotsInEpoch'],
    transactionCount: json['transactionCount'],
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static EpochInfo? tryFromJson(final Map<String, dynamic>? json)
    => json != null ? EpochInfo.fromJson(json) : null;

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