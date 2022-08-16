/// Imports
/// ------------------------------------------------------------------------------------------------

import 'library_exception.dart';
import '../src/models/data.dart';


/// Data Exception
/// ------------------------------------------------------------------------------------------------

class DataException extends LibraryException {

  /// Creates an exception for invalid [Data].
  const DataException(
    super.message, {
    super.code,
  });
}