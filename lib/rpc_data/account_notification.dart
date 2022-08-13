/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/rpc/rpc_context_result.dart';
import 'package:solana_web3/rpc/rpc_notification.dart';
import 'package:solana_web3/rpc_data/account_info.dart';


/// Account Notification
/// ------------------------------------------------------------------------------------------------

class AccountNotification extends RpcNotification {
  
  /// Account Notification.
  const AccountNotification({
    required super.result,
    required super.subscription,
  });

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// [AccountNotification.result] is set to the return value of `parse(json['result'])`.
  /// 
  /// ```
  /// AccountNotification.parse({ '<parameter>': <value> }, (U) => T);
  /// ```
  static AccountNotification parse(final Map<String, dynamic> json) {
    final result = RpcContextResult.parse(json, AccountInfo.fromJson);
    return AccountNotification.fromJson(result.toJson());
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// AccountNotification.fromJson({ '<parameter>': <value> });
  /// ```
  factory AccountNotification.fromJson(final Map<String, dynamic> json) => AccountNotification(
    result: json['result'],
    subscription: json['subscription'],
  );
}