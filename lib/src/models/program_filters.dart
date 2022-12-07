/// Imports
/// ------------------------------------------------------------------------------------------------

import 'mem_cmp.dart';
import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/types.dart' show u64;


/// Program Filters
/// ------------------------------------------------------------------------------------------------

class ProgramFilters extends Serializable {

  /// Filter results using a filter objects. The account must meet all filter criteria to be 
  /// included in results.
  const ProgramFilters({
    required this.memcmp,
    required this.dataSize,
  });

  /// Compares a provided series of bytes with the program account data at a particular offset.
  final MemCmp? memcmp;

  /// Compares the program account data length with the provided data size.
  final u64? dataSize;

  // /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  // /// object.
  // /// 
  // /// ```
  // /// ProgramFilters.fromJson({ '<parameter>': <value> });
  // /// ```
  // factory ProgramFilters.fromJson(final Map<String, dynamic> json) => ProgramFilters(
  //   memcmp: MemCmp.fromJson(json['memcmp']), 
  //   dataSize: json['dataSize'],
  // );
  
  // /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  // /// object.
  // /// 
  // /// Returns `null` if [json] is omitted.
  // /// 
  // /// ```
  // /// ProgramFilters.tryFromJson({ '<parameter>': <value> });
  // /// ```
  // static ProgramFilters? tryFromJson(final Map<String, dynamic>? json) {
  //   return json == null ? null : ProgramFilters.fromJson(json);
  // }

  @override
  Map<String, dynamic> toJson() => {
    'memcmp': memcmp?.toJson(),
    'dataSize': dataSize,
  };

  List<Map<String, dynamic>> toJsonList() => [
    { 'memcmp': memcmp?.toJson() },
    { 'dataSize': dataSize }
  ];

  List<Map<String, dynamic>> toJsonListCleaned() => [
    if (memcmp != null)
      { 'memcmp': memcmp!.toJson() },
    if (dataSize != null)
      { 'dataSize': dataSize }
  ];
}