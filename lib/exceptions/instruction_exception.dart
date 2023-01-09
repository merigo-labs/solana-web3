/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/exceptions/solana_exception.dart';


/// Instruction Exception
/// ------------------------------------------------------------------------------------------------

class InstructionException extends SolanaException {

  /// Creates an exception for an invalid instruction.
  const InstructionException(
    super.message, {
    super.code,
  });

  /// {@macro solana_common.SolanaException.fromJson}
  factory InstructionException.fromJson(final Map<String, dynamic> json) => InstructionException(
    json['message'],
    code: json['code'],
  );
}