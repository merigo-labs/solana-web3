/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/types.dart' show u64;


/// Slot Notification
/// ------------------------------------------------------------------------------------------------

class SlotNotification extends Serializable {
  
  /// Slot notification.
  const SlotNotification({
    required this.parent,
    required this.root,
    required this.slot,
  });

  /// The parent slot.
  final u64 parent;

  /// The current slot.
  final u64 root;

  /// The newly set slot.
  final u64 slot;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// SlotNotification.fromJson({ '<parameter>': <value> });
  /// ```
  static SlotNotification fromJson(final Map<String, dynamic> json) => SlotNotification(
    parent: json['parent'],
    root: json['root'],
    slot: json['slot'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// SlotNotification.tryFromJson({ '<parameter>': <value> });
  /// ```
  static SlotNotification? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? SlotNotification.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'parent': parent,
    'root': root,
    'slot': slot,
  };
}