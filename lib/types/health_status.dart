/// Imports
/// ------------------------------------------------------------------------------------------------

import '../src/utils/library.dart' as utils show tryCall;


/// Health Statuses
/// ------------------------------------------------------------------------------------------------

enum HealthStatus {

  /// The node has within HEALTH_CHECK_SLOT_DISTANCE slots of the highest known validator.
  ok,

  /// The node does not has within HEALTH_CHECK_SLOT_DISTANCE slots of the highest known validator.
  behind,

  /// No slot information from known validators is currently available.
  unknown,
  ;

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Throws an [ArgumentError] if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// HealthStatus.fromName('ok');
  /// ```
  factory HealthStatus.fromName(final String name) => values.byName(name);
  
  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Returns `null` if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// HealthStatus.tryFromName('ok');
  /// ```
  static HealthStatus? tryFromName(final String? name) {
    return name != null ? utils.tryCall(() => HealthStatus.fromName(name)) : null;
  }
}