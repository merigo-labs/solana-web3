/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert' show base64;
import 'package:solana_common/borsh/borsh.dart';
import 'buffer_layout.dart' as buffer_layout;


/// Fee Calculator Layout
/// ------------------------------------------------------------------------------------------------

//// https://github.com/solana-labs/solana/blob/90bedd7e067b5b8f3ddbb45da00a4e9cabb22c62/sdk/src/fee_calculator.rs#L7-L11
final buffer_layout.NearUInt64 feeCalculatorLayout = buffer_layout.nu64('lamportsPerSignature');


/// Fee Calculator
/// ------------------------------------------------------------------------------------------------

@Deprecated('Deprecated since Solana v1.8.0')
class FeeCalculator extends BorshSerializable {

  // Transaction fee calculator.
  const FeeCalculator(this.lamportsPerSignature);

  /// The cost in `lamports` to validate a `signature`.
  final BigInt lamportsPerSignature;

  /// {@macro solana_common.BorshSerializable.codec}
  static BorshStructSizedCodec get codec {
    return borsh.structSized({
      'lamportsPerSignature': borsh.u64,
    });
  }

  /// {@macro solana_common.Serializable.fromJson}
  factory FeeCalculator.fromJson(final Map<String, dynamic> json) => FeeCalculator(
    json['lamportsPerSignature'],
  );

  /// {@macro solana_common.BorshSerializable.deserialize}
  static FeeCalculator deserialize(final Iterable<int> buffer) {
    return borsh.deserialize(codec.schema, buffer, FeeCalculator.fromJson);
  }

  /// {@macro solana_common.BorshSerializable.tryDeserialize}
  static FeeCalculator? tryDeserialize(final Iterable<int>? buffer)
    => buffer != null ? FeeCalculator.deserialize(buffer) : null;

  /// {@macro solana_common.BorshSerializable.fromBase64}
  static FeeCalculator fromBase64(final String encoded) 
    => FeeCalculator.deserialize(base64.decode(encoded));

  /// {@macro solana_common.BorshSerializable.tryFromBase64}
  static FeeCalculator? tryFromBase64(final String? encoded)
    => encoded != null ? FeeCalculator.fromBase64(encoded) : null;

  @override
  BorshSchema get schema => codec.schema;
  
  @override
  Map<String, dynamic> toJson() => {
    'lamportsPerSignature': lamportsPerSignature,
  };
}