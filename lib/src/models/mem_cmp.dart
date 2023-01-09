/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/types.dart';


/// Memory Comparison
/// ------------------------------------------------------------------------------------------------

class MemCmp extends Serializable {

  /// Compares a provided series of [bytes] with program account data at a particular [offset].
  const MemCmp({
    required this.offset,
    required this.bytes,
  });

  /// The offset into program account data to start comparison.
  final usize offset;

  /// The data to match as a base-58 encoded string and limited to less than `129 bytes`.
  final String bytes;

  /// {@macro solana_common.Serializable.fromJson}
  factory MemCmp.fromJson(final Map<String, dynamic> json) => MemCmp(
    offset: json['offset'], 
    bytes: json['bytes'],
  );
  
  /// {@macro solana_common.Serializable.tryFromJson}
  static MemCmp? tryFromJson(final Map<String, dynamic>? json) {
    return json == null ? null : MemCmp.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
    'offset': offset,
    'bytes': bytes,
  };
}