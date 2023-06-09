/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter_test/flutter_test.dart';
import 'package:solana_web3/solana_web3.dart';
import 'package:solana_web3/src/encodings/lamports.dart';


/// Buffer Layout Tests
/// ------------------------------------------------------------------------------------------------

void main() {
  test('solana web3', () async {
    expect(solToLamports(0), BigInt.from(0));
    expect(solToLamports(1), BigInt.from(1000000000));
    expect(solToLamports(1.5), BigInt.from(1500000000));
    expect(solToLamports(2.5), BigInt.from(2500000000));
    expect(solToLamports(3.14159265359), BigInt.from(3141592654));
    expect(solToLamports(0.0123456789), BigInt.from(12345679));
    expect(solToLamports(0.0000000009), BigInt.from(1));
    expect(solToLamports(0.00000000009), BigInt.from(0));
  });
}