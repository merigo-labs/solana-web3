/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';


/// Version
/// ------------------------------------------------------------------------------------------------

class Version extends Serializable {
  
  /// The solana version running on a node.
  const Version({
    required this.solanaCore,
    required this.featureSet,
  });

  /// The software version of solana-core.
  final String solanaCore;

  /// The unique identifier of the current software's feature set.
  final int? featureSet;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// Version.fromJson({ '<parameter>': <value> });
  /// ```
  factory Version.fromJson(final Map<String, dynamic> json) => Version(
    solanaCore: json['solana-core'],
    featureSet: json['feature-set'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// Version.tryFromJson({ '<parameter>': <value> });
  /// ```
  static Version? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? Version.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'solana-core': solanaCore,
    'feature-set': featureSet,
  };
}