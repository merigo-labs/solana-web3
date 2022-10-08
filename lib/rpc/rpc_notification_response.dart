/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/utils/types.dart' show JsonRpcParser;
import 'rpc_notification.dart';
import '../types/notification_method.dart';


/// RPC Notification Response
/// ------------------------------------------------------------------------------------------------

class RpcNotificationResponse<T> {
  
  /// Defines a JSON-RPC websocket response for a notification.
  const RpcNotificationResponse({
    required this.jsonrpc,
    required this.method,
    required this.params,
  });

  /// The JSON-RPC version.
  final String jsonrpc;

  /// The invoked notification method.
  final NotificationMethod method;

  /// The notification data.
  final RpcNotification<T> params;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// The [params] result property ([RpcNotification.result]) is set to the return value of 
  /// `parse(json['params'])`.
  /// 
  /// ```
  /// RpcNotificationResponse.parse({ '<parameter>': <value> }, (U) => T);
  /// ```
  static RpcNotificationResponse<T> parse<T, U>(
    final Map<String, dynamic> json, 
    final JsonRpcParser<T, U> parse,
  ) {
    const String paramsKey = 'params';
    json[paramsKey] = RpcNotification.parse(json[paramsKey], parse) ;
    return RpcNotificationResponse.fromJson(json);
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// RpcNotificationResponse.fromJson({ '<parameter>': <value> });
  /// ```
  factory RpcNotificationResponse.fromJson(final Map<String, dynamic> json) 
    => RpcNotificationResponse<T>(
      jsonrpc: json['jsonrpc'], 
      method: NotificationMethod.fromName(json['method']),
      params: json['params'],
    );
}