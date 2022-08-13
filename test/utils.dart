/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/buffer.dart';


/// Test Utilities
/// ------------------------------------------------------------------------------------------------

/// Max/Min values
const int minUInt = 0;
const int maxUint8 = 255;
const int maxUint16 = 65535;
const int maxUint32 = 4294967295;
final BigInt maxUInt64 = BigInt.parse('18446744073709551615');
final Buffer maxUInt64Buffer = Buffer.fromList([255, 255, 255, 255, 255, 255, 255, 255]);
const int minInt64 = -9223372036854775808;
final Buffer minInt64Buffer = Buffer.fromList([0, 0, 0, 0, 0, 0, 0, 128]);
const int maxInt64 = 9223372036854775807;
final Buffer maxInt64Buffer = Buffer.fromList([255, 255, 255, 255, 255, 255, 255, 127]);

/// Helpers
assertRange(final int value, { final int min = 0, final int max = 255 }) {
  assert(value >= min && value <= max);
}