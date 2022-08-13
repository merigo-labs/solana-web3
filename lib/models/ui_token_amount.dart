/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/models/serialisable.dart';


/// UI Token Amount
/// ------------------------------------------------------------------------------------------------

class UITokenAmount extends Serialisable {

  /// Token amount.
  const UITokenAmount({
    required this.amount,
    required this.decimals,
    required this.uiAmountString,
  });

  /// The raw amount of tokens as a string, ignoring decimals.
  final String amount;

  /// The number of decimals configured for token's mint.
  final num decimals;

  /// The token amount as a string (including decimals).
  final String uiAmountString;

  /// Create an instance of this class from the given [json] object.
  /// 
  /// @param [json]: A map containing the class' constructor parameters.
  factory UITokenAmount.fromJson(final Map<String, dynamic> json) => UITokenAmount(
    amount: json['amount'], 
    decimals: json['decimals'],
    uiAmountString: json['uiAmountString'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'amount': amount,
    'decimals': decimals,
    'uiAmountString': uiAmountString,
  };
}