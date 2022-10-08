/// Imports
/// ------------------------------------------------------------------------------------------------
import 'package:solana_common/models/serializable.dart';


/// Loaded Address
/// ------------------------------------------------------------------------------------------------

class LoadedAddress extends Serializable {
  
  /// Transaction addresses loaded from the address lookup tables.
  const LoadedAddress({
    required this.writable,
    required this.readonly,
  });

  /// An ordered list of base-58 encoded addresses for writable loaded accounts.
  final List<String> writable;

  /// An ordered list of base-58 encoded addresses for readonly loaded accounts.
  final List<String> readonly;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// LoadedAddress.fromJson({ '<parameter>': <value> });
  /// ```
  factory LoadedAddress.fromJson(final Map<String, dynamic> json) => LoadedAddress(
    writable: List.castFrom(json['writable']),
    readonly: List.castFrom(json['readonly']),
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// LoadedAddress.tryFromJson({ '<parameter>': <value> });
  /// ```
  static LoadedAddress? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? LoadedAddress.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'writable': writable,
    'readonly': readonly,
  };
}