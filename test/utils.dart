/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:pinenacl/ed25519.dart';
import 'package:solana_web3/solana_web3.dart' as web3;
import 'package:solana_common/utils/buffer.dart';


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

final web3.Keypair wallet = web3.Keypair.fromSeedSync(
  Uint8List.fromList([
    183, 69, 110, 126, 141, 167, 148, 129, 79, 147, 153, 132, 80, 178, 86, 134, 
    29, 190, 26, 249, 17, 113, 128, 188, 232, 98, 25, 174, 129, 170, 200, 48,
  ])
);

/// Helpers
assertRange(final int value, { final int min = 0, final int max = 255 }) {
  assert(value >= min && value <= max);
}