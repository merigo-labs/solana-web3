/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/exceptions/solana_exception.dart';
import '../src/nacl.dart' as nacl show publicKeyLength;


/// Public Key Exception
/// ------------------------------------------------------------------------------------------------

class PublicKeyException extends SolanaException {

  /// Creates an exception for an invalid public key.
  const PublicKeyException(
    super.message, {
    super.code,
  });
  
  /// Creates an exception for an invalid public key length.
  /// 
  /// The error [message] is constructed from the invalid key's [length] and the [maxLength] of a 
  /// public key.
  /// 
  /// ```
  ///   /// [message] = 'Invalid public key length of 16, expected <= 32.'
  ///   throw PublicKeyException.length(16, maxLength: 32);
  /// ```
  factory PublicKeyException.length(
    final int length, { 
    final int maxLength = nacl.publicKeyLength, 
  }) {
    return PublicKeyException('Invalid public key length of $length, expected <= $maxLength.');
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// PublicKeyException.fromJson({ '<parameter>': <value> });
  /// ```
  factory PublicKeyException.fromJson(final Map<String, dynamic> json) => PublicKeyException(
    json['message'],
    code: json['code'], 
  );
}