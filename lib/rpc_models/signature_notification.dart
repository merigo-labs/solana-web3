/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models/serializable.dart';


/// Signature Notification
/// ------------------------------------------------------------------------------------------------

class SignatureNotification extends Serializable {
  
  /// Signature notification.
  const SignatureNotification({
    required this.err,
  });

  /// The error if transaction failed, null if transaction succeeded.
  /// 
  /// TODO: check error definitions.
  final dynamic err;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// SignatureNotification.fromJson({ '<parameter>': <value> });
  /// ```
  static SignatureNotification fromJson(final Map<String, dynamic> json) => SignatureNotification(
    err: json['err'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// SignatureNotification.tryFromJson({ '<parameter>': <value> });
  /// ```
  static SignatureNotification? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? SignatureNotification.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'err': err,
  };
}