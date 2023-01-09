/// Imports
/// ------------------------------------------------------------------------------------------------

import 'program_account.dart';
import '../rpc_models/account_info.dart';


/// Token Account
/// ------------------------------------------------------------------------------------------------

class TokenAccount extends ProgramAccount {
  
  /// An SPL token account.
  const TokenAccount({
    required super.pubkey,
    required super.account,
  });

  /// {@macro solana_common.Serializable.fromJson}
  factory TokenAccount.fromJson(final Map<String, dynamic> json) => TokenAccount(
    pubkey: json['pubkey'],
    account: AccountInfo.fromJson(json['account']),
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static TokenAccount? tryFromJson(final Map<String, dynamic>? json)
    => json != null ? TokenAccount.fromJson(json) : null;
}