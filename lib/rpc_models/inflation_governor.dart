/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/serialisable.dart';
import 'package:solana_web3/src/utils/types.dart' show f64;


/// Inflation Governor
/// ------------------------------------------------------------------------------------------------

class InflationGovernor extends Serialisable {
  
  /// Inflation governor.
  const InflationGovernor({
    required this.initial,
    required this.terminal,
    required this.taper,
    required this.foundation,
    required this.foundationTerm,
  });

  /// The initial inflation percentage from time 0.
  final f64 initial;

  /// The terminal inflation percentage.
  final f64 terminal;

  /// The rate per year at which inflation is lowered. Rate reduction is derived using the target 
  /// slot time in the genesis config.
  final f64 taper;
  
  /// The percentage of total inflation allocated to the foundation.
  final f64 foundation;
  
  /// The duration of foundation pool inflation in years.
  final f64? foundationTerm;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// InflationGovernor.fromJson({ '<parameter>': <value> });
  /// ```
  factory InflationGovernor.fromJson(final Map<String, dynamic> json) => InflationGovernor(
    initial: json['initial'],
    terminal: json['terminal'],
    taper: json['taper'],
    foundation: json['foundation'],
    foundationTerm: json['foundationTerm'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// InflationGovernor.tryFromJson({ '<parameter>': <value> });
  /// ```
  static InflationGovernor? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? InflationGovernor.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'initial': initial,
    'terminal': terminal,
    'taper': taper,
    'foundation': foundation,
    'foundationTerm': foundationTerm,
  };
}