/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/slot_range.dart';
import 'package:solana_web3/src/models/serialisable.dart';


/// Block Production
/// ------------------------------------------------------------------------------------------------

class BlockProduction extends Serialisable {
  
  /// Block production information.
  const BlockProduction({
    required this.byIdentity,
    required this.range,
  });

  // ***********************************************************************************************
  // ** Do not change the type to Map<String, List<int>>, a bug in dart throws an error when you  **
  // ** try to print this property.                                                               **
  // **                                                                                           **
  // ** final BlockProduction p = BlockProduction.fromJson(...);                                  **
  // ** print(p.byIdentity) // 'List<dynamic>' is not a subtype of type 'List<int>' in type cast  **
  // ***********************************************************************************************
  /// A dictionary of validator identities, as base-58 encoded strings. The values are a two element 
  /// array, containing the number of leader slots and the number of blocks produced.
  final Map<String, List> byIdentity;

  /// The block production slot range.
  final SlotRange range;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// BlockProduction.fromJson({ '<parameter>': <value> });
  /// ```
  factory BlockProduction.fromJson(final Map<String, dynamic> json) => BlockProduction(
    byIdentity: Map.castFrom(json['byIdentity']),
    range: SlotRange.fromJson(json['range']),
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// BlockProduction.fromJson({ '<parameter>': <value> });
  /// ```
  static BlockProduction? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? BlockProduction.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'byIdentity': byIdentity,
    'range': range.toJson(),
  };
}