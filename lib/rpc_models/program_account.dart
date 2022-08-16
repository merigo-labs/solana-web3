/// Imports
/// ------------------------------------------------------------------------------------------------

import '../rpc_models/account_info.dart';
import '../src/models/serialisable.dart';
import '../src/public_key.dart';


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
  /// ProgramAccount.tryFromJson({ '<parameter>': <value> });
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