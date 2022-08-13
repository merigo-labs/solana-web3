/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/utils/library.dart' as utils show tryParse;


/// RPC Http Headers
/// ------------------------------------------------------------------------------------------------

class RpcHttpHeaders extends Serialisable {
  
  /// Defines the HTTP headers for a JSON-RPC request.
  const RpcHttpHeaders({
    this.contentType = 'application/json',
  });

  /// The content type (default: `application/json`).
  final String contentType;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// RpcHttpHeaders.fromJson({ '<parameter>': <value> });
  /// ```
  factory RpcHttpHeaders.fromJson(final Map<String, dynamic> json) => RpcHttpHeaders(
    contentType: json['content-type'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// RpcHttpHeaders.tryFromJson({ '<parameter>': <value> });
  /// ```
  static RpcHttpHeaders? tryFromJson(final Map<String, dynamic>? json) {
    return utils.tryParse(json, RpcHttpHeaders.fromJson);
  }

  @override
  Map<String, String> toJson() {
    return { 
      'content-type': contentType 
    };
  }
}