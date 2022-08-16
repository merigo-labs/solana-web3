/// Imports
/// ------------------------------------------------------------------------------------------------

import 'serialisable.dart';


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

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// UITokenAmount.fromJson({ '<parameter>': <value> });
  /// ```
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