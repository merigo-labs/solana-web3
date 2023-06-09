/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert' show utf8;
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:solana_web3/src/crypto/keypair.dart';
import 'package:solana_web3/src/rpc/models/program_address.dart';
import 'package:solana_web3/src/crypto/pubkey.dart';


/// Keypair Tests
/// ------------------------------------------------------------------------------------------------

void main() {

  const String pubkeyBase58 = 'E5bw5oWGNG7Z3V5e5kyFVUJRP32LoWvj5TVMtmNKFqYS';

  final Uint8List pubkey = Uint8List.fromList([
    194, 85, 192, 100, 227, 236, 153, 196, 197, 68, 62, 250, 237, 102, 200, 33, 
    191, 39, 117, 191, 37, 156, 129, 14, 63, 181, 81, 212, 63, 125, 123, 207,
  ]);

  final Uint8List seckey = Uint8List.fromList([
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

  void assertPubkey(Pubkey pubKey) {
    assert(pubKey.toBase58() == pubkeyBase58);
    assert(pubKey.toString() == pubkeyBase58);
    assert(compareLists(pubKey.toBuffer().asUint8List(), pubkey));
    assert(compareLists(pubKey.toBytes(), pubkey));
  }

  void assertSeckey(Uint8List seckey) {
    assert(compareLists(seckey, seckey));
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
    print('NEW KEYPAIR PK ${keypair.pubkey}');
    print('NEW KEYPAIR SK ${keypair.seckey}');
  });

  test('keypair from secret key', () {
    final Keypair keypair = Keypair.fromSeckeySync(seckey);
    print('KEYPAIR FROM SECRET KEY ${keypair.pubkey}');
    assertPubkey(keypair.pubkey);
    assertSeckey(keypair.seckey);
  });

  test('keypair from seed', () { 
    final Uint8List seed = Keypair.fromSeckeySync(seckey).seckey.sublist(0, 32);
    final Keypair keypair = Keypair.fromSeedSync(seed);
    print('KEYPAIR FROM SEED ${keypair.pubkey}');
    assertPubkey(keypair.pubkey);
    assertSeckey(keypair.seckey);
  });


  /// PUBLIC KEY TESTS
  test('public key zero', () {
    final Pubkey pubkey = Pubkey.zero();
    print('PUBKEY ZERO ${pubkey.toBase58()}');
    assert(pubkey.toBase58() == '11111111111111111111111111111111');
  });
  test('public key from string', () {
    final Pubkey pubkey = Pubkey.fromBase58(pubkeyBase58);
    print('PUBKEY FROM STRING $pubkey');
    assertPubkey(pubkey);
  });
  test('public key from uint8list', () {
    final Pubkey pubkey1 = Pubkey.fromUint8List(pubkey);
    print('PUBKEY FROM UINT8LIST $pubkey1');
    assertPubkey(pubkey1);
  });

  test('public key create with seed', () {
    final Keypair keypair = Keypair.fromSeckeySync(seckey);
    final Pubkey pubkey = Pubkey.createWithSeed(
      keypair.pubkey,
      'legoseedphrase12345',
      Pubkey.zero()
    );
    print('PUBKEY CREATE WITH SEED B58 ${pubkey.toBase58()}');
    print('PUBKEY CREATE WITH SEED BYT ${pubkey.toBytes()}');
  });
  test('public key create program address', () {
    final Pubkey pubkey = Pubkey.createProgramAddress(
      [utf8.encode('seedPhrase12345')],
      Pubkey.zero()
    );
    print('PUBKEY CREATE PROG ADDR B58 ${pubkey.toBase58()}');
    print('PUBKEY CREATE PROG ADDR BYT ${pubkey.toBytes()}');
  });
  test('public key find program address', () {
    final ProgramAddress programAddress = Pubkey.findProgramAddress(
      [utf8.encode('abcde')],
      Pubkey.zero(),
    );
    print('PUBKEY CREATE FIND ADDR B58 ${programAddress.pubkey.toBase58()}');
    print('PUBKEY CREATE FIND ADDR BYT ${programAddress.bump}');
  });
  test('public key is on curve', () {
    final Pubkey pubkey = Keypair.fromSeckeySync(seckey).pubkey;
    final bool isOnCurve = Pubkey.isOnCurve(pubkey);
    print('PUBKEY ADDRESS              ${pubkey.toBase58()}');
    print('PUBKEY IS ON CURVE          $isOnCurve');
    assert(isOnCurve);
  });
}
