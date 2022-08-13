/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/reward_type.dart';
import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/utils/types.dart';


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

  /// Create an instance of this class from the given [json] object.
  /// 
  /// @param [json]: A map containing the class' constructor parameters.
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