/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/exceptions/library_exception.dart';
import 'package:solana_web3/models/data.dart';


/// Data Exception
/// ------------------------------------------------------------------------------------------------

class DataException extends LibraryException {

  /// Creates an exception for invalid [Data].
  const DataException(
    super.message, {
    super.code,
  });
}