/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/serialisable.dart';


/// Library Exception
/// ------------------------------------------------------------------------------------------------

abstract class LibraryException extends Serialisable implements Exception {

  /// Defines the format of an exception, which contains a short descriptive [message] of the error
  /// and an optional error [code].
  const LibraryException(
    this.message, {
    this.code,
  });

  /// A short description of the error.
  final String message;

  /// The error type.
  final int? code;

  @override
  Map<String, dynamic> toJson() => {
    'message': message,
    'code': code,
  };

  @override
  String toString() {
    return '[$runtimeType] ${code != null ? "$code : " : ""}$message';
  }
}