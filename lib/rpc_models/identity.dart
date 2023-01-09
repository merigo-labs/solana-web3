/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_web3/src/public_key.dart';


/// Identity
/// ------------------------------------------------------------------------------------------------

class Identity extends Serializable {
  
  /// The identity public key for a node.
  const Identity({
    required this.identity,
  });

  /// The identity public key of a node.
  final PublicKey identity;

  /// {@macro solana_common.Serializable.fromJson}
  factory Identity.fromJson(final Map<String, dynamic> json) => Identity(
    identity: PublicKey.fromBase58(json['identity']),
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static Identity? tryFromJson(final Map<String, dynamic>? json)
    => json != null ? Identity.fromJson(json) : null;

  @override
  Map<String, dynamic> toJson() => {
    'identity': identity.toBase58(),
  };
}