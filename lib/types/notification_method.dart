/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/utils/library.dart' as utils show tryCall;


/// Notification Methods
/// ------------------------------------------------------------------------------------------------

enum NotificationMethod {

  accountNotification,
  logsNotification,
  programNotification,
  signatureNotification,
  slotNotification,
  rootNotification,
  ;

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Throws an [ArgumentError] if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// NotificationMethod.fromName('accountNotification');
  /// ```
  factory NotificationMethod.fromName(final String name) => values.byName(name);

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Returns `null` if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// NotificationMethod.tryFromName('accountNotification');
  /// ```
  static NotificationMethod? tryFromName(final String? name) {
    return name != null ? utils.tryCall(() => NotificationMethod.fromName(name)) : null;
  }
}