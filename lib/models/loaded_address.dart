/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/models/serialisable.dart';


/// Loaded Address
/// ------------------------------------------------------------------------------------------------

class LoadedAddress extends Serialisable {
  
  /// Transaction addresses loaded from the address lookup tables.
  const LoadedAddress({
    required this.writable,
    required this.readonly,
  });

  /// An ordered list of base-58 encoded addresses for writable loaded accounts.
  final List<String> writable;

  /// An ordered list of base-58 encoded addresses for readonly loaded accounts.
  final List<String> readonly;

  /// Create an instance of this class from the given [json] object.
  /// 
  /// @param [json]: A map containing the class' constructor parameters.
  factory LoadedAddress.fromJson(final Map<String, dynamic> json) => LoadedAddress(
    writable: json['writable'].cast<String>(),
    readonly: json['readonly'].cast<String>(),
  );

  static LoadedAddress? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? LoadedAddress.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'writable': writable,
    'readonly': readonly,
  };
}