/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_web3/src/public_key.dart';
import 'package:solana_common/utils/types.dart' show u64;


/// Large Account
/// ------------------------------------------------------------------------------------------------

class LargeAccount extends Serializable {

  /// A large account (by lamport balance).
  const LargeAccount({
    required this.address,
    required this.lamports,
  });

  /// The address of the account.
  final PublicKey address;

  /// The number of lamports in the account.
  final u64? lamports;

  /// {@macro solana_common.Serializable.fromJson}
  factory LargeAccount.fromJson(final Map<String, dynamic> json) => LargeAccount(
    address: PublicKey.fromBase58(json['address']), 
    lamports: json['lamports'],
  );
  
  /// {@macro solana_common.Serializable.tryFromJson}
  static LargeAccount? tryFromJson(final Map<String, dynamic>? json)
    => json == null ? null : LargeAccount.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
    'address': address,
    'lamports': lamports,
  };
}