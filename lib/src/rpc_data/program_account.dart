/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/serialisable.dart';
import 'package:solana_web3/src/public_key.dart';
import 'package:solana_web3/src/rpc_data/account_info.dart';


/// ProgramAccount
/// ------------------------------------------------------------------------------------------------

class ProgramAccount extends Serialisable {
  
  /// The ProgramAccount public key for a node.
  const ProgramAccount({
    required this.pubkey,
    required this.account,
  });

  /// the account Pubkey as a base-58 encoded string.
  final PublicKey pubkey;

  /// The account information.
  final AccountInfo account;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// ProgramAccount.fromJson({ '<parameter>': <value> });
  /// ```
  factory ProgramAccount.fromJson(final Map<String, dynamic> json) => ProgramAccount(
    pubkey: PublicKey.fromString(json['pubkey']),
    account: AccountInfo.fromJson(json['account']),
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// ProgramAccount.fromJson({ '<parameter>': <value> });
  /// ```
  static ProgramAccount? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? ProgramAccount.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'pubkey': pubkey.toBase58(),
    'account': account.toJson(),
  };
}