/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/utils/library.dart' as utils show tryCall;


/// Data Encodings
/// ------------------------------------------------------------------------------------------------

enum DataEncoding {
  
  base58('base58'),
  base64('base64'),
  base64Zstd('base64+zstd'),
  json('json'),
  jsonParsed('jsonParsed'),
  ;

  /// Stores the encoding's [_name] as a property of the enum variant.
  const DataEncoding(this._name);

  /// The variant's string value.
  final String _name;

  /// @override [EnumName.name] to return [_name];
  String get name => _name;

  /// If true, the value is valid for encoding account data (`base58`, `base64`, `base64Zstd` or 
  /// `jsonParsed`).
  bool get isAccount {
    return isBinary || this == DataEncoding.jsonParsed;
  }

  /// If true, the value is valid for encoding binary data (`base58`, `base64` or `base64Zstd`).
  bool get isBinary {
    return this == DataEncoding.base58
        || this == DataEncoding.base64
        || this == DataEncoding.base64Zstd;
  }

  /// If true, the value is valid for encoding JSON data (`json` or `jsonParsed`).
  bool get isJson {
    return this == DataEncoding.json
        || this == DataEncoding.jsonParsed;
  }

  /// If true, the value is valid for encoding transaction data (`base58`, `base64`, `json` or 
  /// `jsonParsed`).
  bool get isTransaction {
    return isJson || this == DataEncoding.base58 || this == DataEncoding.base64;
  }

  /// Returns the enum variant where [DataEncoding.name] is equal to [name].
  /// 
  /// Throws a [StateError] if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// DataEncoding.fromName('base58');
  /// ```
  factory DataEncoding.fromName(final String name) {
    return values.firstWhere((final DataEncoding property) => property._name == name);
  }

  /// Returns the enum variant where [DataEncoding.name] is equal to [name].
  /// 
  /// Returns `null` if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// DataEncoding.tryFromName('base58');
  /// ```
  static DataEncoding? tryFromName(final String? name) {
    return name != null ? utils.tryCall(() => DataEncoding.fromName(name)) : null;
  }
}