/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert' show base64Decode;
import 'package:solana_web3/src/config/data_encoding.dart';
import 'package:solana_web3/src/exceptions/data_exception.dart';
import 'package:solana_web3/src/models/serialisable.dart';
import 'package:solana_web3/src/utils/convert.dart';


/// Data
/// ------------------------------------------------------------------------------------------------

class Data<T> extends Serialisable {

  /// The `account` or `transaction` data received from a JSON-RPC method call.
  const Data(
    this.value, {
    required this.encoding,
  });

  /// The parsed data.
  final T value;
  
  /// The [value]'s encoding.
  final DataEncoding encoding;

  /// Returns [value]'s length property.
  /// 
  /// Returns zero for types that do not have a `length` property.
  int get length {
    if (value is Iterable) {
      return (value as Iterable).length;
    } else if (value is Map) {
      return (value as Map).length;
    } else if (value is String) {
      return (value as String).length;
    } else {
      return 0;
    }
  }

  /// Returns `true` if [data] is a binary encoded [List].
  /// 
  /// ```
  /// final List<String> data = ['SGkgS2F0ZQ==', 'base64'];
  /// print(Data.isBinary(data)); // true
  /// ```
  static bool isBinary(final Object data) {
    return data is List 
        && data.length == 2
        && data.first is String
        && DataEncoding.tryFromName(data.last) != null;
  }

  /// Creates a [Data] instance from a `base58` or `base64` [encoded] binary string.
  /// 
  /// Throws a [DataException] if [encoded] is not a valid `base58`, `base64` encoded string.
  /// 
  /// ```
  /// final String encoded = 'SGkgS2F0ZQ==';
  /// final Data<String> data = Data.fromBinary(encoded);
  /// print('value: ${data.value}, encoding: ${data.encoding}'); // value: 'SGkgS2F0ZQ==', 
  ///                                                            // encoding: DataEncoding.base64
  /// ```
  static Data<String> fromBinary(final String encoded) {

    try {
      base58Decode(encoded);
      return Data(encoded, encoding: DataEncoding.base58);
    } catch (_) {
      /// Invalid `base58` encoded string.
    }

    try {
      base64Decode(encoded);
      return Data(encoded, encoding: DataEncoding.base64);
    } catch (_) {
      /// Invalid `base64` encoded string.
    }
    
    throw DataException('Invalid binary encoded string $encoded');
  }

  /// Creates an instance of `this` class from the provided `account` or `transaction` [data].
  /// 
  /// 
  /// Throws a [DataException] if [data] is not a valid `binary` or `JSON` object for one of the 
  /// [DataEncoding]s.
  /// 
  /// The format of [data] must be `[string, encoding]` for binary data or a `JSON` object.
  /// 
  /// ```
  /// Data.parse(['UA==', 'base64']);               // Binary object.
  /// Data.parse({ 'program': 'spl-token', ... });  // JSON object.
  /// Data.parse([ '4fGh...GTh6', { ... } ]);       // JSON object.
  /// ```
  static Data parse(final Object data) {

    // First check if [data] is binary encoded data.
    if (Data.isBinary(data)) {
      final List<String >binaryList = (data as List).cast();
      return Data(binaryList[0], encoding: DataEncoding.fromName(binaryList[1]));
    }

    // If not binary encoded data, but is a [List] or [Map], assume it's JSON data.
    if (data is List || data is Map) {
      final bool isParsed = data is Map && data.containsKey('parsed');
      return Data(data, encoding: isParsed ? DataEncoding.jsonParsed : DataEncoding.json);
    }

    // If data is a [String], it must be a binary encoded string. When the encoding specified in a 
    // request (e.g. [DataEncoding.jsonParsed]) is not available, it may default to a literal binary 
    // encoded string.
    if (data is String) {
      return Data.fromBinary(data);
    }

    // If this code is reached, check that [data] is in the expected format: `[string, encoding]` 
    // (binary) or `object` (JSON).
    throw DataException('Unexpected format $data');
  }
  
  /// Creates an instance of `this` class from the [data] object.
  /// 
  /// Returns `null` if [data] is `null` or cannot be parsed.
  /// 
  /// ```
  /// Data.tryParse(['UA==', 'base64']);
  /// ```
  static Data? tryParse(final Object? data) {
    return data != null ? Data.parse(data) : null;
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// Data.fromJson({ '<parameter>': <value> });
  /// ```
  factory Data.fromJson(final Map<String, dynamic> json) => Data(
    json['value'],
    encoding: DataEncoding.fromName(json['encoding']),
  );

  /// Explicity casts [source] to be a Data<S>.
  /// 
  /// Throws an exception if [source] is not of type `S`.
  static Data<S> castFrom<S>(final Data source) => Data<S>(
    source.value as S, 
    encoding: source.encoding,
  );
  
  @override
  Map<String, dynamic> toJson() => {
    'value': value,
    'encoding': encoding.name,
  };
}