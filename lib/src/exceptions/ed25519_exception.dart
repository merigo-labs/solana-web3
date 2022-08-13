/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/exceptions/library_exception.dart';


/// ED25519 Exception
/// ------------------------------------------------------------------------------------------------

class ED25519Exception extends LibraryException {

  /// Creates an exception for the `ed25519` public key signature system.
  const ED25519Exception(
    super.message, {
    super.code,
  });

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// ED25519Exception.fromJson({ '<parameter>': <value> });
  /// ```
  factory ED25519Exception.fromJson(final Map<String, dynamic> json) => ED25519Exception(
    json['message'],
    code: json['code'],
  );
}