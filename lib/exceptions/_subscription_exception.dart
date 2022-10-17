// /// Imports
// /// ------------------------------------------------------------------------------------------------

// import 'package:solana_common/exceptions/solana_exception.dart';


// /// Subscription Exception
// /// ------------------------------------------------------------------------------------------------

// class SubscriptionException extends SolanaException {

//   /// Creates an exception for an invalid subscription.
//   const SubscriptionException(
//     super.message, {
//     super.code,
//   });

//   /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
//   /// object.
//   /// 
//   /// ```
//   /// SubscriptionException.fromJson({ '<parameter>': <value> });
//   /// ```
//   factory SubscriptionException.fromJson(final Map<String, dynamic> json) => SubscriptionException(
//     json['message'],
//     code: json['code'],
//   );
// }