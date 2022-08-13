/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/public_key.dart';
import 'package:solana_web3/utils/types.dart' show u64;


/// Large Account
/// ------------------------------------------------------------------------------------------------

class LargeAccount extends Serialisable {

  /// A large account (by lamport balance).
  const LargeAccount({
    required this.address,
    required this.lamports,
  });

  /// The address of the account.
  final PublicKey address;

  /// The number of lamports in the account.
  final u64? lamports;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// LargeAccount.fromJson({ '<parameter>': <value> });
  /// ```
  factory LargeAccount.fromJson(final Map<String, dynamic> json) => LargeAccount(
    address: PublicKey.fromString(json['address']), 
    lamports: json['lamports'],
  );
  
  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// LargeAccount.fromJson({ '<parameter>': <value> });
  /// ```
  static LargeAccount? tryFromJson(final Map<String, dynamic>? json) {
    return json == null ? null : LargeAccount.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => {
    'address': address,
    'lamports': lamports,
  };
}