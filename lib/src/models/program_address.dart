/// Imports
/// ------------------------------------------------------------------------------------------------

import '../public_key.dart';


/// Program Address
/// ------------------------------------------------------------------------------------------------

class ProgramAddress {

  /// Defines a program address ([publicKey] + [bump]).
  const ProgramAddress(this.publicKey, this.bump);

  /// The public key.
  final PublicKey publicKey;

  /// The bump seed.
  final int bump;
}