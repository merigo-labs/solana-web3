/// Imports
/// ------------------------------------------------------------------------------------------------

import 'account_encoding.dart';
import '../src/models/serialisable.dart';
import '../src/public_key.dart';
import '../src/utils/convert.dart';


/// Accounts Filter
/// ------------------------------------------------------------------------------------------------

class AccountsFilter extends Serialisable {

  /// JSON-RPC parameters for `simulateTransaction` methods.
  AccountsFilter({
    this.encoding,
    this.addresses = const [],
  }): assert(encoding == null || (encoding.isAccount && encoding != AccountEncoding.base58));

  /// The returned account data's encoding (default: [AccountEncoding.base64]).
  final AccountEncoding? encoding;

  /// An array of accounts to return.
  final List<PublicKey> addresses;
  
  @override
  Map<String, dynamic> toJson() => {
    'encoding': encoding?.name,
    'addresses': list.encode(addresses),
  };
}