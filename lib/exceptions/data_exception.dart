/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/exceptions/solana_exception.dart';
import '../src/models/data.dart';


/// Data Exception
/// ------------------------------------------------------------------------------------------------

class DataException extends SolanaException {

  /// Creates an exception for invalid [Data].
  const DataException(
    super.message, {
    super.code,
  });
}