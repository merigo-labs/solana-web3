/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/serialisable.dart';
import 'package:solana_web3/src/utils/types.dart' show f64, u64;


/// Inflation Rate
/// ------------------------------------------------------------------------------------------------

class InflationRate extends Serialisable {
  
  /// Inflation Rate.
  const InflationRate({
    required this.total,
    required this.validator,
    required this.foundation,
    required this.epoch,
  });

  /// The total inflation.
  final f64 total;

  /// The inflation allocated to validators.
  final f64 validator;

  /// The inflation allocated to the foundation.
  final f64 foundation;
  
  /// The epoch for which these values are valid.
  final u64 epoch;
  

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// InflationRate.fromJson({ '<parameter>': <value> });
  /// ```
  factory InflationRate.fromJson(final Map<String, dynamic> json) => InflationRate(
    total: json['total'],
    validator: json['validator'],
    foundation: json['foundation'],
    epoch: json['epoch'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// InflationRate.fromJson({ '<parameter>': <value> });
  /// ```
  static InflationRate? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? InflationRate.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'total': total,
    'validator': validator,
    'foundation': foundation,
    'epoch': epoch,
  };
}