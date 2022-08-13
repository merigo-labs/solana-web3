/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/rpc_data/vote_account.dart';
import 'package:solana_web3/utils/convert.dart' show list;


/// Vote Account Status
/// ------------------------------------------------------------------------------------------------

class VoteAccountStatus extends Serialisable {
  
  /// Current and delinquent vote accounts.
  const VoteAccountStatus({
    required this.current,
    required this.delinquent,
  });

  /// The current vote accounts.
  final List<VoteAccount> current;

  /// The delinquent vote accounts.
  final List<VoteAccount> delinquent;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// VoteAccountStatus.fromJson({ '<parameter>': <value> });
  /// ```
  factory VoteAccountStatus.fromJson(final Map<String, dynamic> json) => VoteAccountStatus(
    current: list.decode(json['current'], VoteAccount.fromJson),
    delinquent: list.decode(json['delinquent'], VoteAccount.fromJson),
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// VoteAccountStatus.fromJson({ '<parameter>': <value> });
  /// ```
  static VoteAccountStatus? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? VoteAccountStatus.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'current': list.encode(current),
    'delinquent': list.encode(delinquent),
  };
}