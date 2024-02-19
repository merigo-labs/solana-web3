/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert';

import 'package:solana_borsh/borsh.dart';
import 'package:solana_borsh/codecs.dart';
import 'package:solana_borsh/models.dart';
import 'package:solana_borsh/types.dart';
import 'package:solana_common/types.dart' show u64;
import 'package:solana_web3/src/rpc/utils/json_utils.dart';

import '../mixins/data_serializable_mixin.dart';

/// Account Info
/// ------------------------------------------------------------------------------------------------

class AccountInfo<T> extends BorshObject with DataSerializableMixin {
  /// Account Information.
  const AccountInfo({
    required this.lamports,
    required this.owner,
    required this.data,
    required this.executable,
    required this.rentEpoch,
  });

  /// The number of lamports assigned to this account, as a u64.
  final u64 lamports;

  /// The base-58 encoded Pubkey of the program this account has been assigned to.
  final String owner;

  /// The data associated with the account, either as encoded binary data (string, encoding) or
  /// JSON format ({<program>: <state>}).
  final T? data;

  /// Indicates if the account contains a program (and is strictly read-only)
  final bool executable;

  /// The epoch at which this account will next owe rent, as a u64.
  final u64 rentEpoch;

  @override
  T? get rawData => data;

  @override
  BorshSchema get borshSchema {
    assert(isBinary, 'Borsh serialization can only be applied to binary account info [data].');
    return binaryCodec.schema;
  }

  /// {@macro solana_borsh.BorshObject.borshCodec}
  static BorshStructCodec get binaryCodec {
    return borsh.struct({
      'lamports': borsh.u64,
      'owner': borsh.string(),
      'data': borsh.array(borsh.string(), 2),
      'executable': borsh.boolean,
      'rentEpoch': borsh.u64,
    });
  }

  /// {@macro solana_borsh.BorshObject.fromBorsh}
  static AccountInfo fromBorsh(final Iterable<int> buffer) {
    return borsh.deserialize(binaryCodec.schema, buffer, AccountInfo.fromJson);
  }

  /// {@macro solana_borsh.BorshObject.tryFromBorsh}
  static AccountInfo? tryFromBorsh(final Iterable<int>? buffer) =>
      buffer != null ? AccountInfo.fromBorsh(buffer) : null;

  /// {@macro solana_borsh.BorshObject.fromBorshBase64}
  static AccountInfo fromBorshBase64(final String encoded) =>
      AccountInfo.fromBorsh(base64.decode(encoded));

  /// {@macro solana_borsh.BorshObject.tryFromBorshBase64}
  static AccountInfo? tryFromBorshBase64(final String? encoded) =>
      encoded != null ? AccountInfo.fromBorshBase64(encoded) : null;

  /// {@macro solana_common.Serializable.fromJson}
  factory AccountInfo.fromJson(final Map<String, dynamic> json) => AccountInfo(
        lamports: parseInt(json['lamports']),
        owner: parseString(json['owner']),
        data: DataSerializableMixin.decode(json['data']),
        executable: parseBool(json['executable']),
        rentEpoch: parseInt(json['rentEpoch']),
      );

  /// {@macro solana_common.Serializable.tryFromJson}
  static AccountInfo? tryFromJson(final Map<String, dynamic>? json) =>
      json != null ? AccountInfo.fromJson(json) : null;

  @override
  Map<String, dynamic> toJson() => {
        'lamports': lamports,
        'owner': owner,
        'data': data,
        'executable': executable,
        'rentEpoch': rentEpoch,
      };
}
