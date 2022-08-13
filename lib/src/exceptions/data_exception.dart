/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/exceptions/library_exception.dart';
import 'package:solana_web3/src/models/data.dart';


/// Data Exception
/// ------------------------------------------------------------------------------------------------

class DataException extends LibraryException {

  /// Creates an exception for invalid [Data].
  const DataException(
    super.message, {
    super.code,
  });
}