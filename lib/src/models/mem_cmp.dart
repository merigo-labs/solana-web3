/// Imports
/// ------------------------------------------------------------------------------------------------

import 'serialisable.dart';
import '../utils/types.dart';


/// Memory Comparison
/// ------------------------------------------------------------------------------------------------

class MemCmp extends Serialisable {

  /// Compares a provided series of [bytes] with program account data at a particular [offset].
  const MemCmp({
    required this.offset,
    required this.bytes,
  });

  /// The offset into program account data to start comparison.
  final usize offset;

  /// The data to match as a base-58 encoded string and limited to less than `129 bytes`.
  final String bytes;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// MemCmp.fromJson({ '<parameter>': <value> });
  /// ```
  factory MemCmp.fromJson(final Map<String, dynamic> json) => MemCmp(
    offset: json['offset'], 
    bytes: json['bytes'],
  );
  
  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// MemCmp.tryFromJson({ '<parameter>': <value> });
  /// ```
  static MemCmp? tryFromJson(final Map<String, dynamic>? json) {
    return json == null ? null : MemCmp.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
    'offset': offset,
    'bytes': bytes,
  };
}