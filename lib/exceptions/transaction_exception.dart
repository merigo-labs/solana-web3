/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/exceptions/solana_exception.dart';


/// Transaction Exception
/// ------------------------------------------------------------------------------------------------

class TransactionException extends SolanaException {

  /// Creates an exception for an invalid transaction.
  const TransactionException(
    super.message, {
    super.code,
  });

  /// {@macro solana_common.SolanaException.fromJson}
  factory TransactionException.fromJson(final Map<String, dynamic> json) => TransactionException(
    json['message'],
    code: json['code'],
  );
}