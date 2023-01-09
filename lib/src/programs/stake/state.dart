/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/borsh/borsh.dart';
import 'package:solana_common/utils/types.dart';
import '../../../src/public_key.dart';


/// Authorized
/// ------------------------------------------------------------------------------------------------

class Authorized extends BorshSerializable {

  /// Stake account authority info.
  const Authorized({
    required this.staker,
    required this.withdrawer,
  });

  /// Stake authority.
  final String staker;

  /// Withdraw authority.
  final String withdrawer;
  
  /// {@macro solana_common.Serializable.fromJson}
  factory Authorized.fromJson(final Map<String, dynamic> json) => Authorized(
    staker: json['staker'],
    withdrawer: json['withdrawer'],
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static Authorized? tryFromJson(final Map<String, dynamic>? json) 
    => json != null ? Authorized.fromJson(json) : null;

  /// {@macro solana_common.BorshSerializable.codec}
  static final BorshStructCodec codec = borsh.struct({
    'staker': borsh.publicKey,
    'withdrawer': borsh.publicKey,
  });

  @override
  BorshSchema get schema => codec.schema;
  
  @override
  Map<String, dynamic> toJson() => {
    'staker': staker,
    'withdrawer': withdrawer,
  };
}


/// Stake Authorize
/// ------------------------------------------------------------------------------------------------

enum StakeAuthorize {
  staker,
  withdrawer,
}


/// Lockup
/// ------------------------------------------------------------------------------------------------

class Lockup extends BorshSerializable {

  /// Stake account lockup info.
  const Lockup({
    required this.unixTimestamp,
    required this.epoch,
    required this.custodian,
  });

  /// Unix timestamp of lockup expiration.
  final i64 unixTimestamp;

  /// Epoch of lockup expiration.
  final i64 epoch;

  /// Lockup custodian authority (base-58).
  final String custodian;
  
  /// {@macro solana_common.Serializable.fromJson}
  factory Lockup.fromJson(final Map<String, dynamic> json) => Lockup(
    unixTimestamp: json['unixTimestamp'],
    epoch: json['epoch'],
    custodian: json['custodian'],
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static Lockup? tryFromJson(final Map<String, dynamic>? json) 
    => json != null ? Lockup.fromJson(json) : null;

  /// The default, inactive lockup value.
  static Lockup get inactive => Lockup(
    unixTimestamp: 0, 
    epoch: 0, 
    custodian: PublicKey.zero().toBase58(),
  );
  
  /// {@macro solana_common.BorshSerializable.codec}
  static final BorshStructCodec codec = borsh.struct({
    'unixTimestamp': borsh.i64,
    'epoch': borsh.i64,
    'custodian': borsh.publicKey,
  });

  @override
  BorshSchema get schema => codec.schema;
  
  @override
  Map<String, dynamic> toJson() => {
    'unixTimestamp': unixTimestamp,
    'epoch': epoch,
    'custodian': custodian,
  };
}


/// Lockup Args
/// ------------------------------------------------------------------------------------------------

class LockupArgs extends BorshSerializable {

  /// Stake account lockup arguments.
  const LockupArgs({
    this.unixTimestamp,
    this.epoch,
    this.custodian,
  });

  /// Unix timestamp of lockup expiration.
  final i64? unixTimestamp;

  /// Epoch of lockup expiration.
  final i64? epoch;

  /// Lockup custodian authority (base-58).
  final String? custodian;

  /// {@macro solana_common.Serializable.fromJson}
  factory LockupArgs.fromJson(final Map<String, dynamic> json) => LockupArgs(
    unixTimestamp: json['unixTimestamp'],
    epoch: json['epoch'],
    custodian: json['custodian'],
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static LockupArgs? tryFromJson(final Map<String, dynamic>? json) 
    => json != null ? LockupArgs.fromJson(json) : null;
  
  /// {@macro solana_common.BorshSerializable.codec}
  static final BorshStructCodec codec = borsh.struct({
    'unixTimestamp': borsh.i64.option(),
    'epoch': borsh.i64.option(),
    'custodian': borsh.publicKey.option(),
  });

  @override
  BorshSchema get schema => codec.schema;
  
  @override
  Map<String, dynamic> toJson() => {
    'unixTimestamp': unixTimestamp,
    'epoch': epoch,
    'custodian': custodian,
  };
}


/// Lockup Checked Args
/// ------------------------------------------------------------------------------------------------

class LockupCheckedArgs extends BorshSerializable {

  /// Stake account lockup arguments.
  const LockupCheckedArgs({
    this.unixTimestamp,
    this.epoch,
  });

  /// Unix timestamp of lockup expiration.
  final i64? unixTimestamp;

  /// Epoch of lockup expiration.
  final i64? epoch;

  /// {@macro solana_common.Serializable.fromJson}
  factory LockupCheckedArgs.fromJson(final Map<String, dynamic> json) => LockupCheckedArgs(
    unixTimestamp: json['unixTimestamp'],
    epoch: json['epoch'],
  );

  /// {@macro solana_common.Serializable.tryFromJson}
  static LockupCheckedArgs? tryFromJson(final Map<String, dynamic>? json) 
    => json != null ? LockupCheckedArgs.fromJson(json) : null;
  
  /// {@macro solana_common.BorshSerializable.codec}
  static final BorshStructCodec codec = borsh.struct({
    'unixTimestamp': borsh.i64.option(),
    'epoch': borsh.i64.option(),
  });

  @override
  BorshSchema get schema => codec.schema;
  
  @override
  Map<String, dynamic> toJson() => {
    'unixTimestamp': unixTimestamp,
    'epoch': epoch,
  };
}