/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/buffer_layout.dart' as buffer_layout;


/// Fee Calculator Layout
/// ------------------------------------------------------------------------------------------------

//// https://github.com/solana-labs/solana/blob/90bedd7e067b5b8f3ddbb45da00a4e9cabb22c62/sdk/src/fee_calculator.rs#L7-L11
final buffer_layout.NearUInt64 feeCalculatorLayout = buffer_layout.nu64('lamportsPerSignature');


/// Fee Calculator
/// ------------------------------------------------------------------------------------------------

class FeeCalculator {

  // Transaction fee calculator.
  const FeeCalculator(this.lamportsPerSignature);

  /// The cost in `lamports` to validate a `signature`.
  final int lamportsPerSignature;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// FeeCalculator.fromJson({ '<parameter>': <value> });
  /// ```
  factory FeeCalculator.fromJson(final Map<String, dynamic> json) => FeeCalculator(
    json['lamportsPerSignature'],
  );
}