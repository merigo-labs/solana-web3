/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/utils/library.dart' as utils show tryCall;


/// Account Filter
/// ------------------------------------------------------------------------------------------------

enum AccountFilter {

  circulating,
  nonCirculating,
  ;

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Throws an [ArgumentError] if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// AccountFilter.fromName('ok');
  /// ```
  factory AccountFilter.fromName(final String name) => values.byName(name);
  
  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Returns `null` if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// AccountFilter.tryFromName('ok');
  /// ```
  static AccountFilter? tryFromName(final String? name) {
    return name != null ? utils.tryCall(() => AccountFilter.fromName(name)) : null;
  }
}