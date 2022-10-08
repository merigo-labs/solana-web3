/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/types.dart' show u64;
import '../types/stake_activation_state.dart';


/// Stake Activation
/// ------------------------------------------------------------------------------------------------

class StakeActivation extends Serializable {
  
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
  /// StakeActivation.tryFromJson({ '<parameter>': <value> });
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