/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/public_key.dart';


/// Program Address
/// ------------------------------------------------------------------------------------------------

class ProgramAddress {

  /// Defines a program address ([pubKey] + [bump]).
  const ProgramAddress(this.pubKey, this.bump);

  /// The public key.
  final PublicKey pubKey;

  /// The bump seed.
  final int bump;
}