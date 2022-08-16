/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/foundation.dart' show protected;
import '../rpc/rpc_http_headers.dart';


/// RPC Request Config
/// ------------------------------------------------------------------------------------------------

abstract class RpcRequestConfig {
  
  /// Defines the configurations for JSON-RPC `requests`.
  const RpcRequestConfig({
    required this.id,
    required this.headers,
    required this.timeout,
  });

  /// A unique client-generated identifier.
  final int? id;

  /// The request's HTTP headers.
  final RpcHttpHeaders? headers;

  /// The request's timeout duration.
  final Duration? timeout;

  /// Returns the `configuration object` passed to a method call.
  /// 
  /// The `clean` configuration object returned by [objectClean] will be included as the last 
  /// item in the `params` list.
  /// 
  /// ```
  /// {
  ///   'jsonrpc': '2.0',
  ///   ...,
  ///   'params': [
  ///     '3C4iYswhNe7Z2LJvxc9qQmF55rsKDUGdiuKVUGpTbRsK',
  ///     // The object returned by objectClean()
  ///     {
  ///       'commitment': 'processed',
  ///     }
  ///   ]
  /// }
  /// ```
  @protected
  Map<String, dynamic> object();

  /// Returns the result of [object], removing all `null` valued entries.
  /// 
  /// ```
  /// print(object());      // { 'commitment': 'processed', 'encoding': null }
  /// print(objectClean()); // { 'commitment': 'processed' }
  /// ```
  Map<String, dynamic> objectClean() {
    return object()..removeWhere((key, value) => value == null);
  }
}