/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/exceptions/rpc_exception.dart';
import 'package:solana_web3/src/models/serialisable.dart';
import 'package:solana_web3/src/rpc/rpc_request.dart';
import 'package:solana_web3/src/utils/types.dart' show RpcParser;


/// RPC Response Object Exception
/// ------------------------------------------------------------------------------------------------

class _RpcResponseObjectException extends RpcException {
  const _RpcResponseObjectException(): super('Unexpected JSON-RPC response object format.');
}


/// RPC Response
/// ------------------------------------------------------------------------------------------------

class RpcResponse<T> extends Serialisable {
  
  /// Defines a JSON-RPC response.
  /// 
  /// The response is expressed as a single JSON object; a `success` response must contain a 
  /// [result] key and an `error` response must contain an [error] key. A response cannot contain 
  /// both a [result] and an [error].
  const RpcResponse._({
    required this.jsonrpc,
    this.result,
    this.error,
    this.id,
  });

  /// The JSON-RPC version.
  final String jsonrpc;

  /// The requested data or success confirmation (array|number|object|string|RpcException).
  final T? result;

  /// The error response of a failed request.
  final RpcException? error;

  /// The client-generated identifier sent with the request.
  final int? id;

  /// If true, this instance represents a `success` response.
  /// 
  /// Success responses contain a [result] value, which can be `null`.
  bool get isSuccess => error == null;

  /// If true, this instance represents an `error` response.
  /// 
  /// Error responses contain a `non-null` [error] value.
  bool get isError => error != null;

  /// The response object's `result` key.
  static const String resultKey = 'result';
  
  /// Returns true if the response [json] contains a result of type T.
  static bool isType<T>(final Map<String, dynamic> json) {
    return json[resultKey] is T;
  }

  /// Creates an [RpcResponse] for the given [result].
  factory RpcResponse.fromResult(final T result) => RpcResponse._(
    jsonrpc: RpcRequest.version, 
    result: result,
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// A `success` response will set [RpcResponse.result] to the return value of 
  /// `parse(json['result'])`.
  /// 
  /// ```
  /// RpcResponse.parse({ '<parameter>': <value> }, (U) => T);
  /// ```
  static RpcResponse<T> parse<T, U>(
    final Map<String, dynamic> json,
    final RpcParser<T, U> parse,
  ) {
    
    /// Success responses contain a 'result' key.
    if (json.containsKey(resultKey)) {
      json[resultKey] = parse.call(json[resultKey]);
      return RpcResponse<T>.fromJson(json);
    }

    /// Error responses contain an 'error' key.
    const String errorKey = 'error';
    if (json.containsKey(errorKey)) {
      json[errorKey] = RpcException.fromJson(json[errorKey]);
      return RpcResponse<T>.fromJson(json);
    }

    /// A valid JSON-RPC 2.0 response object must contain a 'result' or 'error', but not both.
    /// https://www.jsonrpc.org/specification#response_object
    return RpcResponse<T>._(jsonrpc: '', error: const _RpcResponseObjectException());
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// A `success` response will set [RpcResponse.result] to the return value of 
  /// `parse(json['result'])`.
  /// 
  /// Return's `null` if [json] is `null` or `badly formatted`.
  /// 
  /// ```
  /// RpcResponse.tryParse({ '<parameter>': <value> }, (U) => T);
  /// ```
  static RpcResponse<T>? tryParse<T, U>(
    final Map<String, dynamic>? json,
    final RpcParser<T, U> parse,
  ) {
    final RpcResponse<T>? response = json != null ? RpcResponse.parse(json, parse) : null;
    return response?.error is _RpcResponseObjectException ? null : response;
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// RpcResponse.fromJson({ '<parameter>': <value> });
  /// ```
  factory RpcResponse.fromJson(final Map<String, dynamic> json) => RpcResponse<T>._(
    jsonrpc: json['jsonrpc'], 
    result: json['result'],
    error: json['error'],
    id: json['id'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'jsonrpc': jsonrpc,
    'result': result,
    'error': error,
    'id': id,
  };
}