/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_web3/src/public_key.dart';


/// Node Identity
/// ------------------------------------------------------------------------------------------------

class NodeIdentity extends Serializable {
  
  /// The identity public key for a node.
  const NodeIdentity({
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
  factory NodeIdentity.fromJson(final Map<String, dynamic> json) => NodeIdentity(
    identity: PublicKey.fromBase58(json['identity']),
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// NodeIdentity.tryFromJson({ '<parameter>': <value> });
  /// ```
  static NodeIdentity? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? NodeIdentity.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'identity': identity.toBase58(),
  };
}