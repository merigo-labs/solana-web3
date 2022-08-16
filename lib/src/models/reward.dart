/// Imports
/// ------------------------------------------------------------------------------------------------

import 'serialisable.dart';
import '../../types/reward_type.dart';
import '../utils/types.dart';


/// Reward
/// ------------------------------------------------------------------------------------------------

class Reward extends Serialisable {
  
  /// Rewards
  const Reward({
    required this.pubkey,
    required this.lamports,
    required this.postBalance,
    required this.rewardType,
    required this.commission,
  });

  /// The public key as a base-58 encoded string, of the account that received the reward.
  final String pubkey;

  /// The number of reward lamports credited or debited by the account.
  final i64 lamports;

   /// The account balance in lamports after the reward was applied.
  final u64 postBalance;

  /// The reward type.
  final RewardType? rewardType;

  /// The vote account commission when the reward was credited (only present for [RewardType.voting] 
  /// and [RewardType.staking]).
  final u8? commission;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// Reward.fromJson({ '<parameter>': <value> });
  /// ```
  factory Reward.fromJson(final Map<String, dynamic> json) => Reward(
    pubkey: json['pubkey'],
    lamports: json['lamports'],
    postBalance: json['postBalance'],
    rewardType: RewardType.tryFromName(json['rewardType']),
    commission: json['commission'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'pubkey': pubkey,
    'lamports': lamports,
    'postBalance': postBalance,
    'rewardType': rewardType?.name,
    'commission': commission,
  };
}