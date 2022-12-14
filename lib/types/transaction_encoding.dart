/// Imports
/// ------------------------------------------------------------------------------------------------

import 'data_encoding.dart';


/// Transaction Encodings
/// ------------------------------------------------------------------------------------------------

/// An alias of [DataEncoding].
/// 
/// Use [DataEncoding.isTransaction] to check that the provided encoding is valid for transaction 
/// data.
/// 
/// ```
/// assert(encoding.isTransaction)
/// ```
typedef TransactionEncoding = DataEncoding;