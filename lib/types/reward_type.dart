/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/utils/library.dart' as utils show tryCall;


/// Rewards Types
/// ------------------------------------------------------------------------------------------------

enum RewardType {
  
  fee,
  rent,
  voting,
  staking,
  ;

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Throws an [ArgumentError] if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// RewardType.fromName('fee');
  /// ```
  factory RewardType.fromName(final String name) => values.byName(name);

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Returns `null` if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// RewardType.tryFromName('fee');
  /// ```
  static RewardType? tryFromName(final String? name) {
    return name != null ? utils.tryCall(() => RewardType.fromName(name)) : null;
  }
}