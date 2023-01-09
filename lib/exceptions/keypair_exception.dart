/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/exceptions/solana_exception.dart';


/// Keypair Exception
/// ------------------------------------------------------------------------------------------------

class KeypairException extends SolanaException {

  /// Creates an exception for an invalid keypair.
  const KeypairException(
    super.message, {
    super.code,
  });

  /// {@macro solana_common.SolanaException.fromJson}
  factory KeypairException.fromJson(final Map<String, dynamic> json) => KeypairException(
    json['message'],
    code: json['code'],
  );
}