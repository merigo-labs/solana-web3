/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/public_key.dart';


/// Identity
/// ------------------------------------------------------------------------------------------------

class Identity extends Serialisable {
  
  /// The identity public key for a node.
  const Identity({
    required this.identity,
  });

  /// The identity public key of a node.
  final PublicKey identity;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// Identity.fromJson({ '<parameter>': <value> });
  /// ```
  factory Identity.fromJson(final Map<String, dynamic> json) => Identity(
    identity: PublicKey.fromString(json['identity']),
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// Identity.fromJson({ '<parameter>': <value> });
  /// ```
  static Identity? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? Identity.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'identity': identity.toBase58(),
  };
}