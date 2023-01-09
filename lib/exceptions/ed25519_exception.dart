/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/exceptions/solana_exception.dart';


/// ED25519 Exception
/// ------------------------------------------------------------------------------------------------

class ED25519Exception extends SolanaException {

  /// Creates an exception for the `ed25519` public key signature system.
  const ED25519Exception(
    super.message, {
    super.code,
  });

  /// {@macro solana_common.SolanaException.fromJson}
  factory ED25519Exception.fromJson(final Map<String, dynamic> json) => ED25519Exception(
    json['message'],
    code: json['code'],
  );
}