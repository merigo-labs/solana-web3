/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert';
import 'package:solana_common/borsh/borsh.dart';
import 'package:solana_common/utils/types.dart' show u64;
import '../src/mixins/data_serializable_mixin.dart';


/// Account Info
/// ------------------------------------------------------------------------------------------------

class AccountInfo<T extends Object> extends BorshSerializable with DataSerializableMixin {
  
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

  /// The data associated with the account, either as encoded binary data ([string, encoding]) or 
  /// JSON format ({<program>: <state>}).
  final T? data;

  /// Indicates if the account contains a program (and is strictly read-only)
  final bool executable;

  /// The epoch at which this account will next owe rent, as a u64.
  final u64 rentEpoch;

  // /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  // /// object.
  // /// 
  // /// [AccountInfo.data] is set to the return value of `Data.parse(json['data'])`.
  // /// 
  // /// ```
  // /// AccountInfo.parse({ '<parameter>': <value> }, (Object) => T);
  // /// ```
  // static AccountInfo parse<T>(final Map<String, dynamic> json)
  //   => AccountInfo.fromJson(json);

  // /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  // /// object.
  // /// 
  // /// [AccountInfo.data] is set to the return value of `parse(json['data'])`.
  // /// 
  // /// Returns `null` if [json] is omitted.
  // /// 
  // /// ```
  // /// AccountInfo.tryParse({ '<parameter>': <value> }, (Object) => T);
  // /// ```
  // static AccountInfo? tryParse<T>(final Map<String, dynamic>? json)
  //   => json != null ? AccountInfo.parse(json) : null;

  @override
  T? get rawData => data;
  
  @override
  BorshSchema get schema {
    assert(isBinary, 'Borsh serialization can only be applied to binary account info [data].');
    return binaryCodec.schema;
  }

  /// {@macro solana_common.BorshSerializable.codec}
  static BorshStructCodec get binaryCodec {
    return borsh.struct({
      'lamports': borsh.i64,
      'owner': borsh.string,
      'data': borsh.array(borsh.string, 2),
      'executable': borsh.boolean,
      'rentEpoch': borsh.i64,
    });
  }

  /// {@macro solana_common.BorshSerializable.deserialize}
  static AccountInfo deserialize(final Iterable<int> buffer) {
    return borsh.deserialize(binaryCodec.schema, buffer, AccountInfo.fromJson);
  }

  /// {@macro solana_common.BorshSerializable.tryDeserialize}
  static AccountInfo? tryDeserialize(final Iterable<int>? buffer)
    => buffer != null ? AccountInfo.deserialize(buffer) : null;

  /// {@macro solana_common.BorshSerializable.fromBase64}
  static AccountInfo fromBase64(final String encoded) 
    => AccountInfo.deserialize(base64.decode(encoded));

  /// {@macro solana_common.BorshSerializable.tryFromBase64}
  static AccountInfo? tryFromBase64(final String? encoded)
    => encoded != null ? AccountInfo.fromBase64(encoded) : null;

  /// {@macro solana_common.Serializable.fromJson}
  factory AccountInfo.fromJson(final Map<String, dynamic> json) => AccountInfo(
    lamports: json['lamports'],
    owner: json['owner'],
    data: DataSerializableMixin.normalize(json['data']),
    executable: json['executable'],
    rentEpoch: json['rentEpoch'],
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static AccountInfo? tryFromJson(final Map<String, dynamic>? json)
    => json != null ? AccountInfo.fromJson(json) : null;

  @override
  Map<String, dynamic> toJson() => {
    'lamports': lamports,
    'owner': owner,
    'data': data,
    'executable': executable,
    'rentEpoch': rentEpoch,
  };
}