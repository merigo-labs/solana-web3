/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/serialisable.dart';


/// Data Slice
/// ------------------------------------------------------------------------------------------------

class DataSlice extends Serialisable {

  /// Defines a range to query a subset of account data.
  const DataSlice({
    required this.offset,
    required this.length,
  }): assert(offset >= 0 && length >= 0);

  /// The start position.
  final int offset;

  /// The data length.
  final int length;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// DataSlice.fromJson({ '<parameter>': <value> });
  /// ```
  factory DataSlice.fromJson(final Map<String, dynamic> json) => DataSlice(
    offset: json['offset'], 
    length: json['length'],
  );
  
  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// DataSlice.fromJson({ '<parameter>': <value> });
  /// ```
  static DataSlice? tryFromJson(final Map<String, dynamic>? json) {
    return json == null ? null : DataSlice.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
    'offset': offset,
    'length': length,
  };
}