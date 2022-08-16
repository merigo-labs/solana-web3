/// Imports
/// ------------------------------------------------------------------------------------------------

import 'serialisable.dart';
import '../message/message.dart';
import '../utils/convert.dart' as convert show list;


/// Transaction
/// ------------------------------------------------------------------------------------------------

class Transaction extends Serialisable {
  
  /// Transaction.
  const Transaction({
    required this.signatures,
    required this.message,
  });

  /// A list of base-58 encoded signatures applied to the transaction. The list is always of length 
  /// [MessageHeader.numRequiredSignatures] and not empty. The signature at index i corresponds to 
  /// the public key at index i in [Message.accountKeys]. The first one is used as the transaction 
  /// id.
  final List<String>? signatures;

  /// The content of the transaction.
  final Message message;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// Transaction.fromJson({ '<parameter>': <value> });
  /// ```
  factory Transaction.fromJson(final Map<String, dynamic> json) => Transaction(
    signatures: convert.list.tryCast(json['signatures']),
    message: Message.fromJson(json['message']),
  );

  @override
  Map<String, dynamic> toJson() => {
    'signatures': signatures,
    'message': message.toJson(),
  };
}