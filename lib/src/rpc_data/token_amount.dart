/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/serialisable.dart';
import 'package:solana_web3/src/utils/types.dart' show u8;


/// Token Amount
/// ------------------------------------------------------------------------------------------------

class TokenAmount extends Serialisable {
  
  /// The token balance of an SPL Token account.
  const TokenAmount({
    required this.amount,
    required this.decimals,
    required this.uiAmountString,
  });

  /// The raw balance without decimals, a u64.
  final BigInt amount;

  /// The number of base 10 digits to the right of the decimal place.
  final u8 decimals;

  /// The balance as a string, using mint-prescribed decimals.
  final String uiAmountString;
  

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// TokenAmount.fromJson({ '<parameter>': <value> });
  /// ```
  factory TokenAmount.fromJson(final Map<String, dynamic> json) => TokenAmount(
    amount: BigInt.parse(json['amount']),
    decimals: json['decimals'],
    uiAmountString: json['uiAmountString'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// TokenAmount.fromJson({ '<parameter>': <value> });
  /// ```
  static TokenAmount? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? TokenAmount.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'amount': amount.toString(),
    'decimals': decimals,
    'uiAmountString': uiAmountString,
  };
}