/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data' show Endian, Uint8List;
import 'package:solana_web3/src/buffer.dart';


/// Big Int Extension
/// ------------------------------------------------------------------------------------------------

extension BigIntExtension on BigInt {

  /// Returns the minimum number of bytes required to store this big integer.
  int get byteLength => (bitLength + 7) >> 3;

  /// Returns the value as a signed big integer.
  BigInt asSigned() => toSigned(byteLength * 8);

  /// Converts the [BigInt] value to a [Uint8List] of size [length].
  /// 
  /// If [length] is omitted, the minimum number of bytes required to store this big integer value 
  /// is used.
  Uint8List toUint8List([final int? length]) {
    final int byteLength = length ?? this.byteLength;
    assert(length == null || length >= byteLength, 'The value $this overflows $byteLength byte(s)');
    return (Buffer(byteLength)..setBigInt(this, 0, byteLength)).asUint8List();
  }

  /// Creates a [BigInt] from an array of [bytes].
  /// 
  /// ```
  /// final BigInt value = BigIntExtension.fromUint8List([255, 255, 255, 255, 255, 255, 255, 255]);
  /// print(value); // 18446744073709551615
  /// ```
  static BigInt fromUint8List(final Iterable<int> bytes, [final Endian endian = Endian.little]) {
    return Buffer.fromList(bytes).getBigUint(0, bytes.length, endian);
  }
}