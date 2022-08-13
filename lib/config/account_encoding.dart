/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/data_encoding.dart';


/// Account Encodings
/// ------------------------------------------------------------------------------------------------

/// An alias of [DataEncoding].
/// 
/// Use [DataEncoding.isAccount] to check that the provided encoding is valid for account data.
/// 
/// ```
/// assert(encoding.isAccount)
/// ```
typedef AccountEncoding = DataEncoding;