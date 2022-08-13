/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/mem_cmp.dart';
import 'package:solana_web3/src/models/serialisable.dart';
import 'package:solana_web3/src/utils/types.dart' show u64;


/// Program Filter
/// ------------------------------------------------------------------------------------------------

class ProgramFilter extends Serialisable {

  /// Filter results using a filter objects. The account must meet all filter criteria to be 
  /// included in results.
  const ProgramFilter({
    required this.memcmp,
    required this.dataSize,
  });

  /// Compares a provided series of bytes with the program account data at a particular offset.
  final MemCmp memcmp;

  /// Compares the program account data length with the provided data size.
  final u64 dataSize;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// ProgramFilter.fromJson({ '<parameter>': <value> });
  /// ```
  factory ProgramFilter.fromJson(final Map<String, dynamic> json) => ProgramFilter(
    memcmp: MemCmp.fromJson(json['memcmp']), 
    dataSize: json['dataSize'],
  );
  
  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// ProgramFilter.fromJson({ '<parameter>': <value> });
  /// ```
  static ProgramFilter? tryFromJson(final Map<String, dynamic>? json) {
    return json == null ? null : ProgramFilter.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
    'memcmp': memcmp.toJson(),
    'dataSize': dataSize,
  };
}