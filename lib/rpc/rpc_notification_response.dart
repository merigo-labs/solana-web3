/// Imports
/// ------------------------------------------------------------------------------------------------

import 'rpc_context_result.dart';
import 'rpc_notification.dart';
import '../rpc_models/account_info.dart';
import '../rpc_models/logs_notification.dart';
import '../rpc_models/program_account.dart';
import '../rpc_models/signature_notification.dart';
import '../rpc_models/slot_notification.dart';
import '../src/utils/library.dart' as utils show cast;
import '../src/utils/types.dart' show RpcParser, u64;
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
    final RpcParser<T, U> parse,
  ) {
    const String paramsKey = 'params';
    json[paramsKey] = RpcNotification.parse(json[paramsKey], parse) ;
    return RpcNotificationResponse.fromJson(json);
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// The [params] result property ([RpcNotification.result]) is set to the return value of 
  /// `parse(json['params'])`.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// RpcNotificationResponse.tryParse({ '<parameter>': <value> }, (U) => T);
  /// ```
  static RpcNotificationResponse? tryParse<T, U>(
    final Map<String, dynamic>? json, [
    RpcParser? parse,
  ]) {
    parse ??= RpcNotificationResponse.parser(json);
    return json != null && parse != null ? RpcNotificationResponse.parse(json, parse) : null;
  }

  static RpcParser? parser(final Map<String, dynamic>? json) {

    final notification = NotificationMethod.tryFromName(json?['method']);
    if (notification == null) {
      print('Uknown notification.');
      return null;
    }

    print('Parse notification $notification');

    switch (notification) {
      case NotificationMethod.accountNotification:
        return (result) => RpcContextResult.parse(result, AccountInfo.parse);
      case NotificationMethod.logsNotification:
        return (result) => RpcContextResult.parse(result, LogsNotification.fromJson);
      case NotificationMethod.programNotification:
        return (result) => RpcContextResult.parse(result, ProgramAccount.fromJson);
      case NotificationMethod.rootNotification:
        return (result) => utils.cast<u64>(result);
      case NotificationMethod.signatureNotification:
        return (result) => SignatureNotification.fromJson(result);
      case NotificationMethod.slotNotification:
        return (result) => SlotNotification.fromJson(result);
    }
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// RpcNotificationResponse.fromJson({ '<parameter>': <value> });
  /// ```
  factory RpcNotificationResponse.fromJson(final Map<String, dynamic> json) => 
    RpcNotificationResponse<T>(
      jsonrpc: json['jsonrpc'], 
      method: NotificationMethod.fromName(json['method']),
      params: json['params'],
    );
}