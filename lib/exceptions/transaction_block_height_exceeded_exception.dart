/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/exceptions/solana_exception.dart';


/// Transaction Block Height Exceeded Exception
/// ------------------------------------------------------------------------------------------------

class TransactionBlockHeightExceededException extends SolanaException {

  /// Creates an exception for block height expiration.
  const TransactionBlockHeightExceededException(
    super.message, {
    super.code,
  });

  /// {@macro solana_common.SolanaException.fromJson}
  factory TransactionBlockHeightExceededException.fromJson(final Map<String, dynamic> json) 
    => TransactionBlockHeightExceededException(
      json['message'],
      code: json['code'],
    );
}