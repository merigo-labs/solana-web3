/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/serialisable.dart';


/// Logs Notification
/// ------------------------------------------------------------------------------------------------

class LogsNotification extends Serialisable {
  
  /// Logs notification.
  const LogsNotification({
    required this.signature,
    required this.err,
    required this.logs,
  });

  /// The transaction signature base-58 encoded.
  final String signature;

  /// The error if transaction failed, null if transaction succeeded.
  /// 
  /// TODO: check error definitions.
  final dynamic err;

  /// An array of log messages the transaction instructions output during execution, null if 
  /// simulation failed before the transaction was able to execute (for example due to an invalid 
  /// blockhash or signature verification failure).
  final List? logs;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// LogsNotification.fromJson({ '<parameter>': <value> });
  /// ```
  factory LogsNotification.fromJson(final Map<String, dynamic> json) => LogsNotification(
    signature: json['signature'],
    err: json['err'],
    logs: json['logs'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// LogsNotification.tryFromJson({ '<parameter>': <value> });
  /// ```
  static LogsNotification? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? LogsNotification.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'signature': signature,
    'err': err,
    'logs': logs,
  };
}