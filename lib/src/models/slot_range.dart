/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/types.dart';


/// Slot Range
/// ------------------------------------------------------------------------------------------------

class SlotRange extends Serializable {

  /// Defines the slot range to return block production for.
  const SlotRange({
    required this.firstSlot,
    this.lastSlot,
  }): assert(firstSlot >= 0 && (lastSlot == null || lastSlot >= 0));

  /// The first slot to return block production information for (inclusive).
  final u64 firstSlot;

  /// The last slot to return block production information for (inclusive). If omitted, it defaults 
  /// to the highest slot.
  final u64? lastSlot;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// SlotRange.fromJson({ '<parameter>': <value> });
  /// ```
  factory SlotRange.fromJson(final Map<String, dynamic> json) => SlotRange(
    firstSlot: json['firstSlot'], 
    lastSlot: json['lastSlot'],
  );
  
  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// SlotRange.tryFromJson({ '<parameter>': <value> });
  /// ```
  static SlotRange? tryFromJson(final Map<String, dynamic>? json) {
    return json == null ? null : SlotRange.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
    'firstSlot': firstSlot,
    'lastSlot': lastSlot,
  };
}