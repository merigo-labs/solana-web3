/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/exceptions/solana_exception.dart';


/// Transaction Signature Exception
/// ------------------------------------------------------------------------------------------------

class TransactionSignatureException extends SolanaException {

  /// Creates an exception for block height expiration.
  const TransactionSignatureException(
    super.message, {
    super.code,
  });

  /// {@macro solana_common.SolanaException.fromJson}
  factory TransactionSignatureException.fromJson(final Map<String, dynamic> json) 
    => TransactionSignatureException(
      json['message'],
      code: json['code'],
    );
}