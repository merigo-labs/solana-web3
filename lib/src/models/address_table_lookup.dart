/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';


/// AddressTableLookup
/// ------------------------------------------------------------------------------------------------

class AddressTableLookup extends Serializable {
  
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

  /// {@macro solana_common.Serializable.fromJson}
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