/// Imports
/// ------------------------------------------------------------------------------------------------

import 'library_exception.dart';


/// Instruction Exception
/// ------------------------------------------------------------------------------------------------

class InstructionException extends LibraryException {

  /// Creates an exception for an invalid keypair.
  const InstructionException(
    super.message, {
    super.code,
  });

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// InstructionException.fromJson({ '<parameter>': <value> });
  /// ```
  factory InstructionException.fromJson(final Map<String, dynamic> json) => InstructionException(
    json['message'],
    code: json['code'],
  );
}