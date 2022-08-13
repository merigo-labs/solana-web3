/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/utils/library.dart' as utils show tryCall;


/// Transaction Details
/// ------------------------------------------------------------------------------------------------

enum TransactionDetail {
  
  full,
  signatures,
  none
  ;

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Throws an [ArgumentError] if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// TransactionDetail.fromName('full');
  /// ```
  factory TransactionDetail.fromName(final String name) => values.byName(name);

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Returns `null` if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// TransactionDetail.tryFromName('full');
  /// ```
  static TransactionDetail? tryFromName(final String? name) {
    return name != null ? utils.tryCall(() => TransactionDetail.fromName(name)) : null;
  }
}