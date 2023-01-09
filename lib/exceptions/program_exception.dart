/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/exceptions/solana_exception.dart';


/// Program Exception
/// ------------------------------------------------------------------------------------------------

class ProgramException extends SolanaException {

  /// Creates an exception for a program error.
  const ProgramException(
    super.message, {
    super.code,
  });

  /// {@macro solana_common.SolanaException.fromJson}
  factory ProgramException.fromJson(final Map<String, dynamic> json) => ProgramException(
    json['message'],
    code: json['code'],
  );
}