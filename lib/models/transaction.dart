/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/message.dart';
import 'package:solana_web3/models/serialisable.dart';


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

  /// Create an instance of this class from the given [json] object.
  /// 
  /// @param [json]: A map containing the class' constructor parameters.
  factory Transaction.fromJson(final Map<String, dynamic> json) => Transaction(
    signatures: json['signatures']?.cast<String>(),
    message: Message.fromJson(json['message']),
  );

  @override
  Map<String, dynamic> toJson() => {
    'signatures': signatures,
    'message': message.toJson(),
  };
}