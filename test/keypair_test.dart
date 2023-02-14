/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:solana_web3/src/keypair.dart';
import 'package:solana_web3/src/models/program_address.dart';
import 'package:solana_web3/src/public_key.dart';


/// Keypair Tests
/// ------------------------------------------------------------------------------------------------

void main() {

  const String publicKeyBase58 = 'E5bw5oWGNG7Z3V5e5kyFVUJRP32LoWvj5TVMtmNKFqYS';

  final Uint8List publicKey = Uint8List.fromList([
    194, 85, 192, 100, 227, 236, 153, 196, 197, 68, 62, 250, 237, 102, 200, 33, 
    191, 39, 117, 191, 37, 156, 129, 14, 63, 181, 81, 212, 63, 125, 123, 207,
  ]);

  final Uint8List secretKey = Uint8List.fromList([
    165, 3, 223, 246, 18, 234, 25, 99, 180, 106, 197, 162, 68, 209, 16, 31,
    95, 71, 64, 84, 148, 95, 220, 50, 80, 28, 220, 192, 36, 200, 192, 62,
    194, 85, 192, 100, 227, 236, 153, 196, 197, 68, 62, 250, 237, 102, 200, 33,
    191, 39, 117, 191, 37, 156, 129, 14, 63, 181, 81, 212, 63, 125, 123, 207,
  ]);

  compareLists<T>(List<T> a, List<T> b) {
    if (a.length != b.length) {
      return false;
    }

    if (!identical(a, b)) {
      for (int i = 0; i < a.length; ++i) {
        if (a[i] != b[i]) {
          return false;
        }
      }
    }

    return true;
  }

  void assertPublicKey(PublicKey pubKey) {
    assert(pubKey.toBase58() == publicKeyBase58);
    assert(pubKey.toString() == publicKeyBase58);
    assert(compareLists(pubKey.toBuffer().asUint8List(), publicKey));
    assert(compareLists(pubKey.toBytes(), publicKey));
  }

  void assertSecretKey(Uint8List secretKey) {
    assert(compareLists(secretKey, secretKey));
  }

  /// KEYPAIR TESTS
  
  test('playground', () {
    // const String source = '9818446744073709551615';
    // final BigInt bigInt = BigInt.parse(source);
    // final Uint8List list = bigInt.toUint8List();
    // print(list);
    // print(BigIntExtension.fromUint8List(list));
    // print(BigIntExtension.fromUint8List(list).toString() == source);
    // print(BigIntExtension.fromUint8List(list).asSigned());
    // print(BigIntExtension.fromUint8List(list).toSigned(list.length * 8));
    // print(BigIntExtension.fromUint8List(list).asSigned().toString() == source);
  });

  test('generate keypair', () {
    final Keypair keypair = Keypair.generateSync();
    print('NEW KEYPAIR PK ${keypair.publicKey}');
    print('NEW KEYPAIR SK ${keypair.secretKey}');
  });

  test('keypair from secret key', () {
    final Keypair keypair = Keypair.fromSecretKeySync(secretKey);
    print('KEYPAIR FROM SECRET KEY ${keypair.publicKey}');
    assertPublicKey(keypair.publicKey);
    assertSecretKey(keypair.secretKey);
  });

  test('keypair from seed', () { 
    final Uint8List seed = Keypair.fromSecretKeySync(secretKey).secretKey.sublist(0, 32);
    final Keypair keypair = Keypair.fromSeedSync(seed);
    print('KEYPAIR FROM SEED ${keypair.publicKey}');
    assertPublicKey(keypair.publicKey);
    assertSecretKey(keypair.secretKey);
  });


  /// PUBLIC KEY TESTS
  test('public key zero', () {
    final PublicKey pubKey = PublicKey.zero();
    print('PUBKEY ZERO ${pubKey.toBase58()}');
    assert(pubKey.toBase58() == '11111111111111111111111111111111');
  });
  test('public key from string', () {
    final PublicKey pubKey = PublicKey.fromBase58(publicKeyBase58);
    print('PUBKEY FROM STRING $pubKey');
    assertPublicKey(pubKey);
  });
  test('public key from uint8list', () {
    final PublicKey pubKey = PublicKey.fromUint8List(publicKey);
    print('PUBKEY FROM UINT8LIST $pubKey');
    assertPublicKey(pubKey);
  });

  test('public key create with seed', () {
    final Keypair keypair = Keypair.fromSecretKeySync(secretKey);
    final PublicKey pubKey = PublicKey.createWithSeed(
      keypair.publicKey,
      'legoseedphrase12345',
      PublicKey.zero()
    );
    print('PUBKEY CREATE WITH SEED B58 ${pubKey.toBase58()}');
    print('PUBKEY CREATE WITH SEED BYT ${pubKey.toBytes()}');
  });
  test('public key create program address', () {
    final PublicKey pubKey = PublicKey.createProgramAddress(
      ['seedPhrase12345'.codeUnits],
      PublicKey.zero()
    );
    print('PUBKEY CREATE PROG ADDR B58 ${pubKey.toBase58()}');
    print('PUBKEY CREATE PROG ADDR BYT ${pubKey.toBytes()}');
  });
  test('public key find program address', () {
    final ProgramAddress programAddress = PublicKey.findProgramAddress(
      ['abcde'.codeUnits],
      PublicKey.zero(),
    );
    print('PUBKEY CREATE FIND ADDR B58 ${programAddress.publicKey.toBase58()}');
    print('PUBKEY CREATE FIND ADDR BYT ${programAddress.bump}');
  });
  test('public key is on curve', () {
    final PublicKey pubKey = Keypair.fromSecretKeySync(secretKey).publicKey;
    final bool isOnCurve = PublicKey.isOnCurve(pubKey);
    print('PUBKEY ADDRESS              ${pubKey.toBase58()}');
    print('PUBKEY IS ON CURVE          $isOnCurve');
    assert(isOnCurve);
  });
}
