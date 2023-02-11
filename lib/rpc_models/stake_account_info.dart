/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert' show base64;
import 'package:solana_common/borsh/borsh.dart';
import 'package:solana_web3/programs/stake.dart';
import 'account_info.dart';


/// Stake Account Info
/// ------------------------------------------------------------------------------------------------

class StakeAccountInfo extends BorshSerializable {
  
  /// Stake Account Information.
  const StakeAccountInfo({
    required this.meta,
    required this.stake,
  });

  /// The mint address (base-58) associated with this account.
  final StakeMeta meta;

  /// The owner address (base-58) of this account.
  final Stake stake;

  @override
  BorshSchema get schema => codec.schema;

  /// {@macro solana_common.BorshSerializable.codec}
  static final BorshStructSizedCodec codec = borsh.structSized({
    'meta': StakeMeta.codec,
    'stake': Stake.codec,
  });

  /// {@macro solana_common.BorshSerializable.deserialize}
  static StakeAccountInfo deserialize(final Iterable<int> buffer) {
    return borsh.deserialize(codec.schema, buffer, StakeAccountInfo.fromJson);
  }

  /// {@macro solana_common.BorshSerializable.tryDeserialize}
  static StakeAccountInfo? tryDeserialize(final Iterable<int>? buffer)
    => buffer != null ? StakeAccountInfo.deserialize(buffer) : null;

  /// {@macro solana_common.BorshSerializable.fromBase64}
  factory StakeAccountInfo.fromBase64(final String encoded) 
    => StakeAccountInfo.deserialize(base64.decode(encoded));

  /// {@macro solana_common.BorshSerializable.tryFromBase64}
  static StakeAccountInfo? tryFromBase64(final String? encoded)
    => encoded != null ? StakeAccountInfo.fromBase64(encoded) : null;

  /// Creates an instance of `this` class from an account [info].
  /// 
  /// ```
  /// StakeAccountInfo.fromAccountInfo('AA==');
  /// ```
  factory StakeAccountInfo.fromAccountInfo(final AccountInfo info) {
    return info.isBinary 
      ? StakeAccountInfo.fromBase64(info.binaryData[0]) 
      : StakeAccountInfo.fromJson(info.jsonData);
  }

  /// Creates an instance of `this` class from an account [info].
  /// 
  /// Returns `null` if [info] is omitted.
  /// 
  /// ```
  /// StakeAccountInfo.tryFromAccountInfo('AA==');
  /// ```
  static StakeAccountInfo? tryFromAccountInfo(final AccountInfo? info)
    => info != null ? StakeAccountInfo.fromAccountInfo(info) : null;

  /// {@macro solana_common.Serializable.fromJson}
  factory StakeAccountInfo.fromJson(final Map<String, dynamic> json) => StakeAccountInfo(
    meta: StakeMeta.fromJson(json['meta']),
    stake: Stake.fromJson(json['stake']),
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static StakeAccountInfo? tryFromJson(final Map<String, dynamic>? json)
    => json != null ? StakeAccountInfo.fromJson(json) : null;

  @override
  Map<String, dynamic> toJson() => {
    'meta': meta.toJson(),
    'stake': stake.toJson(),
  };
}