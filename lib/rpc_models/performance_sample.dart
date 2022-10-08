/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/types.dart' show u16, u64;


/// Performance Sample
/// ------------------------------------------------------------------------------------------------

class PerformanceSample extends Serializable {
  
  /// Performance Sample.
  const PerformanceSample({
    required this.slot,
    required this.numTransactions,
    required this.numSlots,
    required this.samplePeriodSecs,
  });

  /// Slot in which sample was taken at.
  final u64 slot;

  /// Number of transactions in sample.
  final u64 numTransactions;

  /// Number of slots in sample.
  final u64 numSlots;
  
  /// Number of seconds in a sample window.
  final u16 samplePeriodSecs;
  

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// PerformanceSample.fromJson({ '<parameter>': <value> });
  /// ```
  factory PerformanceSample.fromJson(final Map<String, dynamic> json) => PerformanceSample(
    slot: json['slot'],
    numTransactions: json['numTransactions'],
    numSlots: json['numSlots'],
    samplePeriodSecs: json['samplePeriodSecs'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// PerformanceSample.tryFromJson({ '<parameter>': <value> });
  /// ```
  static PerformanceSample? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? PerformanceSample.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'slot': slot,
    'numTransactions': numTransactions,
    'numSlots': numSlots,
    'samplePeriodSecs': samplePeriodSecs,
  };
}