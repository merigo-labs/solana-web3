/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/serialisable.dart';
import 'package:solana_web3/src/utils/types.dart' show u8, u64;


/// Inflation Reward
/// ------------------------------------------------------------------------------------------------

class InflationReward extends Serialisable {
  
  /// Inflation / staking reward.
  const InflationReward({
    required this.epoch,
    required this.effectiveSlot,
    required this.amount,
    required this.postBalance,
    required this.commission,
  });

  /// The epoch for which the reward occured.
  final u64 epoch;

  /// The slot in which the rewards are effective.
  final u64 effectiveSlot;

  /// The reward amount in lamports.
  final u64 amount;
  
  /// The balance of the account in lamports, post the reward.
  final u64 postBalance;
  
  /// The vote account commission when the reward was credited.
  final u8? commission;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// InflationReward.fromJson({ '<parameter>': <value> });
  /// ```
  factory InflationReward.fromJson(final Map<String, dynamic> json) => InflationReward(
    epoch: json['epoch'],
    effectiveSlot: json['effectiveSlot'],
    amount: json['amount'],
    postBalance: json['postBalance'],
    commission: json['commission'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// InflationReward.tryFromJson({ '<parameter>': <value> });
  /// ```
  static InflationReward? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? InflationReward.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'epoch': epoch,
    'effectiveSlot': effectiveSlot,
    'amount': amount,
    'postBalance': postBalance,
    'commission': commission,
  };
}