/// Imports
/// ------------------------------------------------------------------------------------------------

import 'serialisable.dart';


/// AddressTableLookup
/// ------------------------------------------------------------------------------------------------

class AddressTableLookup extends Serialisable {
  
  /// Used by a transaction to dynamically load addresses from on-chain address lookup tables.
  const AddressTableLookup({
    required this.accountKey,
    required this.writableIndexes,
    required this.readonlyIndexes,
  });

  /// A base-58 encoded public key for an address lookup table account.
  final String accountKey;

  /// A List of indices used to load addresses of writable accounts from a lookup table.
  final List<num> writableIndexes;

   /// A list of indices used to load addresses of readonly accounts from a lookup table.
  final List<num> readonlyIndexes;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// AddressTableLookup.fromJson({ '<parameter>': <value> });
  /// ```
  factory AddressTableLookup.fromJson(final Map<String, dynamic> json) => AddressTableLookup(
    accountKey: json['accountKey'],
    writableIndexes: json['writableIndexes'],
    readonlyIndexes: json['readonlyIndexes'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'accountKey': accountKey,
    'writableIndexes': writableIndexes,
    'readonlyIndexes': readonlyIndexes,
  };
}