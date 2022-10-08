/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import '../rpc_models/account_info.dart';
import '../src/public_key.dart';


/// Token Account
/// ------------------------------------------------------------------------------------------------

class TokenAccount extends Serializable {
  
  /// An SPL token account.
  const TokenAccount({
    required this.pubkey,
    required this.account,
  });

  /// The account's public key.
  final PublicKey pubkey;

  /// The account data.
  final AccountInfo account;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// TokenAccount.fromJson({ '<parameter>': <value> });
  /// ```
  factory TokenAccount.fromJson(final Map<String, dynamic> json) => TokenAccount(
    pubkey: PublicKey.fromBase58(json['pubkey']),
    account: AccountInfo.parse(json['account']),
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// TokenAccount.tryFromJson({ '<parameter>': <value> });
  /// ```
  static TokenAccount? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? TokenAccount.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'pubkey': pubkey.toBase58(),
    'account': account.toJson(),
  };
}