/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert' show base64;
import 'package:solana_common/borsh/borsh.dart';
import 'package:solana_web3/programs/stake.dart';
import 'package:solana_web3/rpc_models/index.dart';


/// Stake Account
/// ------------------------------------------------------------------------------------------------

class StakeAccount extends BorshSerializable {
  
  /// Stake Account Information.
  const StakeAccount({
    required this.type,
    required this.info,
  });

  final StakeAccountType type;

  final StakeAccountInfo? info;

  @override
  BorshSchema get schema => codec.schema;

  /// {@macro solana_common.BorshSerializable.codec}
  static final BorshStructCodec codec = borsh.struct({
    'meta': borsh.enumeration(StakeAccountType.values),
    'info': StakeAccountInfo.codec.option(),
  });

  /// {@macro solana_common.BorshSerializable.deserialize}
  static StakeAccount deserialize(final Iterable<int> buffer) {
    return borsh.deserialize(codec.schema, buffer, StakeAccount.fromJson);
  }

  /// {@macro solana_common.BorshSerializable.tryDeserialize}
  static StakeAccount? tryDeserialize(final Iterable<int>? buffer)
    => buffer != null ? StakeAccount.deserialize(buffer) : null;

  /// {@macro solana_common.BorshSerializable.fromBase64}
  factory StakeAccount.fromBase64(final String encoded) 
    => StakeAccount.deserialize(base64.decode(encoded));

  /// {@macro solana_common.BorshSerializable.tryFromBase64}
  static StakeAccount? tryFromBase64(final String? encoded)
    => encoded != null ? StakeAccount.fromBase64(encoded) : null;

  /// Creates an instance of `this` class from an account [info].
  /// 
  /// ```
  /// StakeAccount.fromAccountInfo('AA==');
  /// ```
  factory StakeAccount.fromAccountInfo(final AccountInfo info) {
    return info.isBinary 
      ? StakeAccount.fromBase64(info.binaryData[0]) 
      : StakeAccount.fromJson(info.jsonData);
  }

  /// Creates an instance of `this` class from an account [info].
  /// 
  /// Returns `null` if [info] is omitted.
  /// 
  /// ```
  /// StakeAccount.tryFromAccountInfo('AA==');
  /// ```
  static StakeAccount? tryFromAccountInfo(final AccountInfo? info)
    => info != null ? StakeAccount.fromAccountInfo(info) : null;

  /// {@macro solana_common.Serializable.fromJson}
  factory StakeAccount.fromJson(final Map<String, dynamic> json) => StakeAccount(
    type: json['type'],
    info: StakeAccountInfo.fromJson(json['stake']),
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static StakeAccount? tryFromJson(final Map<String, dynamic>? json)
    => json != null ? StakeAccount.fromJson(json) : null;

  @override
  Map<String, dynamic> toJson() => {
    'type': type,
    'info': info?.toJson(),
  };
}