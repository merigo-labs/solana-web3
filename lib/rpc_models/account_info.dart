/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/utils/types.dart' show u64;
import '../src/models/data_serializable.dart';


/// Account Info
/// ------------------------------------------------------------------------------------------------

class AccountInfo<T extends Object> extends DataSerializable {
  
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

  /// {@macro solana_common.Serializable.fromJson}
  factory AccountInfo.fromJson(final Map<String, dynamic> json) => AccountInfo(
    lamports: json['lamports'],
    owner: json['owner'],
    data: DataSerializable.normalize(json['data']),
    executable: json['executable'],
    rentEpoch: json['rentEpoch'],
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static AccountInfo? tryFromJson(final Map<String, dynamic>? json)
    => json != null ? AccountInfo.fromJson(json) : null;

  @override
  T? get rawData => data;

  @override
  Map<String, dynamic> toJson() => {
    'lamports': lamports,
    'owner': owner,
    'data': data,
    'executable': executable,
    'rentEpoch': rentEpoch,
  };
}