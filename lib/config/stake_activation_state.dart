/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/utils/library.dart' as utils show tryCall;


/// Stake Activation States
/// ------------------------------------------------------------------------------------------------

enum StakeActivationState {

  active,
  inactive,
  activating,
  deactivating,
  ;

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Throws an [ArgumentError] if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// StakeActivationState.fromName('finalized');
  /// ```
  factory StakeActivationState.fromName(final String name) => values.byName(name);

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Returns `null` if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// StakeActivationState.tryFromName('finalized');
  /// ```
  static StakeActivationState? tryFromName(final String? name) {
    return name != null ? utils.tryCall(() => StakeActivationState.fromName(name)) : null;
  }
}