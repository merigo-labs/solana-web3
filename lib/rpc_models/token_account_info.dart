/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert' show base64;
import 'package:solana_common/borsh/borsh.dart';
import 'account_info.dart';
import '../types/account_state.dart';


/// Token Account Info
/// ------------------------------------------------------------------------------------------------

class TokenAccountInfo extends BorshSerializable {
  
  /// Token Account Information.
  const TokenAccountInfo({
    required this.mint,
    required this.owner,
    required this.amount,
    required this.delegate,
    required this.state,
    required this.isNative,
    required this.delegatedAmount,
    required this.closeAuthority,
  });

  /// The mint address (base-58) associated with this account.
  final String mint;

  /// The owner address (base-58) of this account.
  final String owner;
  
  /// The amount of tokens this account holds.
  final BigInt amount;
  
  /// If `delegate` is not-null then `delegatedAmount` represents the amount authorized by the 
  /// delegate (base-58 address).
  final String? delegate;

  /// The account's state.
  final AccountState state;

  /// If not-null, this is a native token, and the value logs the rent-exempt reserve. An Account
  /// is required to be rent-exempt, so the value is used by the Processor to ensure that wrapped
  /// SOL accounts do not drop below this threshold.
  final BigInt? isNative;

  /// The amount delegated.
  final BigInt delegatedAmount;
  
  /// The authority address (base-58) to close the account.
  final String? closeAuthority;

  @override
  BorshSchema get schema => codec.schema;

  /// {@macro solana_common.BorshSerializable.codec}
  static final BorshStructCodec codec = borsh.struct({
    'mint': borsh.publicKey,
    'owner': borsh.publicKey,
    'amount': borsh.u64,
    'delegate': borsh.publicKey.cOption(),
    'state': borsh.enumeration(AccountState.values),
    'isNative': borsh.u64.cOption(),
    'delegatedAmount': borsh.u64,
    'closeAuthority': borsh.publicKey.cOption(),
  });

  /// {@macro solana_common.BorshSerializable.deserialize}
  static TokenAccountInfo deserialize(final Iterable<int> buffer) {
    return borsh.deserialize(codec.schema, buffer, TokenAccountInfo.fromJson);
  }

  /// {@macro solana_common.BorshSerializable.tryDeserialize}
  static TokenAccountInfo? tryDeserialize(final Iterable<int>? buffer)
    => buffer != null ? TokenAccountInfo.deserialize(buffer) : null;

  /// {@macro solana_common.BorshSerializable.fromBase64}
  factory TokenAccountInfo.fromBase64(final String encoded) 
    => TokenAccountInfo.deserialize(base64.decode(encoded));

  /// {@macro solana_common.BorshSerializable.tryFromBase64}
  static TokenAccountInfo? tryFromBase64(final String? encoded)
    => encoded != null && encoded.isNotEmpty ? TokenAccountInfo.fromBase64(encoded) : null;

  /// Creates an instance of `this` class from an account [info].
  /// 
  /// ```
  /// TokenAccountInfo.fromAccountInfo('AA==');
  /// ```
  factory TokenAccountInfo.fromAccountInfo(final AccountInfo info) {
    return info.isBinary 
      ? TokenAccountInfo.fromBase64(info.binaryData[0]) 
      : TokenAccountInfo.fromJson(info.jsonData);
  }

  /// Creates an instance of `this` class from an account [info].
  /// 
  /// Returns `null` if [info] is omitted.
  /// 
  /// ```
  /// TokenAccountInfo.tryFromAccountInfo('AA==');
  /// ```
  static TokenAccountInfo? tryFromAccountInfo(final AccountInfo? info)
    => info != null ? TokenAccountInfo.fromAccountInfo(info) : null;

  /// {@macro solana_common.Serializable.fromJson}
  factory TokenAccountInfo.fromJson(final Map<String, dynamic> json) => TokenAccountInfo(
    mint: json['mint'],
    owner: json['owner'],
    amount: json['amount'],
    delegate: json['delegate'],
    state: json['state'],
    isNative: json['isNative'],
    delegatedAmount: json['delegatedAmount'],
    closeAuthority: json['closeAuthority'],
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static TokenAccountInfo? tryFromJson(final Map<String, dynamic>? json)
    => json != null ? TokenAccountInfo.fromJson(json) : null;

  @override
  Map<String, dynamic> toJson() => {
    'mint': mint,
    'owner': owner,
    'amount': amount,
    'delegate': delegate,
    'state': state,
    'isNative': isNative,
    'delegatedAmount': delegatedAmount,
    'closeAuthority': closeAuthority,
  };
}