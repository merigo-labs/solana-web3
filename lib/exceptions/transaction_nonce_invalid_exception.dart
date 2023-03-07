/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/exceptions/solana_exception.dart';


/// Transaction Nonce Invalid Exception
/// ------------------------------------------------------------------------------------------------

class TransactionNonceInvalidException extends SolanaException {

  /// Creates an exception for an invalid nonce.
  const TransactionNonceInvalidException(
    super.message, {
    this.slot,
  });

  /// 
  final int? slot;

  /// {@macro solana_common.SolanaException.fromJson}
  factory TransactionNonceInvalidException.fromJson(final Map<String, dynamic> json) 
    => TransactionNonceInvalidException(
      json['message'],
      slot: json['slot'],
    );
}