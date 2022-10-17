// /// Imports
// /// ------------------------------------------------------------------------------------------------

// import 'package:solana_common/utils/types.dart' show JsonRpcParser;


// /// RPC Notification
// /// ------------------------------------------------------------------------------------------------

// class RpcNotification<T> {
  
//   /// Defines a JSON-RPC websocket notification.
//   const RpcNotification({
//     required this.result,
//     required this.subscription,
//   });

//   /// The notification data.
//   final T result;

//   /// The subscription identifier.
//   final int subscription;

//   /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
//   /// object.
//   /// 
//   /// [RpcNotification.result] is set to the return value of `parse(json['result'])`.
//   /// 
//   /// ```
//   /// RpcNotification.parse({ '<parameter>': <value> }, (U) => T);
//   /// ```
//   static RpcNotification<T> parse<T, U>(
//     final Map<String, dynamic> json, 
//     final JsonRpcParser<T, U> parse,
//   ) {
//     const String resultKey = 'result';
//     json[resultKey] = parse.call(json[resultKey]);
//     return RpcNotification.fromJson(json);
//   }

//   /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
//   /// object.
//   /// 
//   /// ```
//   /// RpcNotification.fromJson({ '<parameter>': <value> });
//   /// ```
//   factory RpcNotification.fromJson(final Map<String, dynamic> json) => RpcNotification<T>(
//     result: json['result'],
//     subscription: json['subscription'],
//   );
// }