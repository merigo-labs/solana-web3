/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert' show base64;
import 'package:solana_common/borsh/borsh.dart';
import 'account_info.dart';


/// Mint Account Info
/// ------------------------------------------------------------------------------------------------

class MintAccountInfo extends BorshSerializable {
  
  /// Mint Account Information.
  const MintAccountInfo({
    required this.mintAuthority,
    required this.supply,
    required this.decimals,
    required this.isInitialized,
    required this.freezeAuthority,
  });

  /// Optional authority (base-58) used to mint new tokens. The mint authority may only be provided 
  /// during mint creation. If no mint authority is present then the mint has a fixed supply and no 
  /// further tokens may be minted.
  final String? mintAuthority;

  /// Total supply of tokens.
  final BigInt supply;

  /// Number of base 10 digits to the right of the decimal place.
  final int decimals;

  /// Is this mint initialized.
  final bool isInitialized;

  /// Optional authority (base-58) to freeze token accounts.
  final String? freezeAuthority;
  
  @override
  BorshSchema get schema => codec.schema;

  /// {@macro solana_common.BorshSerializable.codec}
  static final BorshStructCodec codec = borsh.struct({
    'mintAuthority': borsh.publicKey.cOption(),
    'supply': borsh.u64,
    'decimals': borsh.u8,
    'isInitialized': borsh.boolean,
    'isNative': borsh.u64.cOption(),
    'freezeAuthority': borsh.publicKey.cOption(),
  });

  /// {@macro solana_common.BorshSerializable.deserialize}
  static MintAccountInfo deserialize(final Iterable<int> buffer) {
    return borsh.deserialize(codec.schema, buffer, MintAccountInfo.fromJson);
  }

  /// {@macro solana_common.BorshSerializable.tryDeserialize}
  static MintAccountInfo? tryDeserialize(final Iterable<int>? buffer)
    => buffer != null ? MintAccountInfo.deserialize(buffer) : null;

  /// {@macro solana_common.BorshSerializable.fromBase64}
  factory MintAccountInfo.fromBase64(final String encoded) 
    => MintAccountInfo.deserialize(base64.decode(encoded));

  /// {@macro solana_common.BorshSerializable.tryFromBase64}
  static MintAccountInfo? tryFromBase64(final String? encoded)
    => encoded != null && encoded.isNotEmpty ? MintAccountInfo.fromBase64(encoded) : null;

  /// Creates an instance of `this` class from an account [info].
  /// 
  /// ```
  /// MintAccountInfo.fromAccountInfo('AA==');
  /// ```
  factory MintAccountInfo.fromAccountInfo(final AccountInfo info) {
    return info.isBinary 
      ? MintAccountInfo.fromBase64(info.binaryData[0]) 
      : MintAccountInfo.fromJson(info.jsonData);
  }

  /// Creates an instance of `this` class from an account [info].
  /// 
  /// Returns `null` if [info] is omitted.
  /// 
  /// ```
  /// MintAccountInfo.tryFromAccountInfo('AA==');
  /// ```
  static MintAccountInfo? tryFromAccountInfo(final AccountInfo? info)
    => info != null ? MintAccountInfo.fromAccountInfo(info) : null;

  /// {@macro solana_common.Serializable.fromJson}
  factory MintAccountInfo.fromJson(final Map<String, dynamic> json) => MintAccountInfo(
    mintAuthority: json['mintAuthority'], 
    supply: json['supply'], 
    decimals: json['decimals'], 
    isInitialized: json['isInitialized'], 
    freezeAuthority: json['freezeAuthority'],
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static MintAccountInfo? tryFromJson(final Map<String, dynamic>? json)
    => json != null ? MintAccountInfo.fromJson(json) : null;

  @override
  Map<String, dynamic> toJson() => {
    'mintAuthority': mintAuthority,
    'supply': supply,
    'decimals': decimals,
    'isInitialized': isInitialized,
    'freezeAuthority': freezeAuthority,
  };
}