/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/account_encoding.dart';
import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/public_key.dart';
import 'package:solana_web3/utils/convert.dart';


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