/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/stake_activation_state.dart';
import 'package:solana_web3/src/models/serialisable.dart';
import 'package:solana_web3/src/utils/types.dart' show u64;


/// Stake Activation
/// ------------------------------------------------------------------------------------------------

class StakeActivation extends Serialisable {
  
  /// Epoch activation information for a stake account.
  const StakeActivation({
    required this.state,
    required this.active,
    required this.inactive,
  });

  /// The stake account's activation state.
  final StakeActivationState state;

  /// The stake active during the epoch.
  final u64 active;

  /// The stake inactive during the epoch.
  final u64 inactive;
  
  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// StakeActivation.fromJson({ '<parameter>': <value> });
  /// ```
  factory StakeActivation.fromJson(final Map<String, dynamic> json) => StakeActivation(
    state: StakeActivationState.fromName(json['state']),
    active: json['active'],
    inactive: json['inactive'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// StakeActivation.fromJson({ '<parameter>': <value> });
  /// ```
  static StakeActivation? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? StakeActivation.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'state': state.name,
    'active': active,
    'inactive': inactive,
  };
}