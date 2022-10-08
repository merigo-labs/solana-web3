/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/convert.dart';
import 'account_encoding.dart';
import '../src/public_key.dart';


/// Accounts Filter
/// ------------------------------------------------------------------------------------------------

class AccountsFilter extends Serializable {

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