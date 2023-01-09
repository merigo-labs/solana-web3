/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert' show base64;
import 'package:solana_web3/solana_web3.dart';
import 'package:solana_web3/types/account_state.dart';


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

  /// Borsh serialization codec.
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

  /// Creates an instance of `this` class from a buffer.
  static TokenAccountInfo deserialize<T>(final Iterable<int> buffer) {
    return borsh.deserialize(codec.schema, buffer, TokenAccountInfo.fromJson);
  }

  /// Creates an instance of `this` class from a buffer.
  /// 
  /// Returns `null` if [buffer] is omitted.
  static TokenAccountInfo? tryDeserialize<T>(final Iterable<int>? buffer)
    => buffer != null ? TokenAccountInfo.deserialize(buffer) : null;

  /// Creates an instance of `this` class from a base-64 encoded string.
  /// 
  /// ```
  /// TokenAccountInfo.fromBase64('AA==');
  /// ```
  factory TokenAccountInfo.fromBase64(final String encoded) 
    => TokenAccountInfo.deserialize(base64.decode(encoded));

  /// Creates an instance of `this` class from a base-64 encoded string.
  /// 
  /// Returns `null` if [encoded] is omitted.
  /// 
  /// ```
  /// TokenAccountInfo.tryFromJson('AA==');
  /// ```
  static TokenAccountInfo? tryFromBase64(final String? encoded)
    => encoded != null ? TokenAccountInfo.fromBase64(encoded) : null;

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