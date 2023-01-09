/// Imports
/// ------------------------------------------------------------------------------------------------

import '../../../programs/program.dart';
import '../../public_key.dart';


/// Token Metadata Program
/// ------------------------------------------------------------------------------------------------

class TokenMetadataProgram extends Program {

  /// Metaplex Token metadata program.
  TokenMetadataProgram._()
    : super(PublicKey.fromBase58('metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s'));

  /// Internal singleton instance.
  static final TokenMetadataProgram _instance = TokenMetadataProgram._();

  /// The program id.
  static PublicKey get programId => _instance.publicKey;
}