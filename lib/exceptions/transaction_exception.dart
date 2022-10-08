/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/exceptions/solana_exception.dart';


/// Transaction Exception
/// ------------------------------------------------------------------------------------------------

class TransactionException extends SolanaException {

  /// Creates an exception for an invalid keypair.
  const TransactionException(
    super.message, {
    super.code,
  });

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// TransactionException.fromJson({ '<parameter>': <value> });
  /// ```
  factory TransactionException.fromJson(final Map<String, dynamic> json) => TransactionException(
    json['message'],
    code: json['code'],
  );
}