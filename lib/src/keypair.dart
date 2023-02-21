/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert' show utf8;
import 'package:flutter/foundation.dart';
import 'nacl.dart' as nacl;
import 'public_key.dart';
import '../exceptions/keypair_exception.dart';


/// Signer
/// ------------------------------------------------------------------------------------------------

abstract class Signer {

  /// Keypair signer.
  Signer({
    required this.publicKey,
    required this.secretKey,
  });

  /// The keypair's public key.
  final PublicKey publicKey;

  /// The keypair's secrey key.
  final Uint8List secretKey;
}


/// Ed25519 Keypair
/// ------------------------------------------------------------------------------------------------

class Ed25519Keypair {

  /// Ed25519 keypair.
  const Ed25519Keypair({
    required this.publicKey,
    required this.secretKey,
  }): assert(publicKey.length == nacl.publicKeyLength),
      assert(secretKey.length == nacl.secretKeyLength);

  /// The Ed25519 public key.
  final Uint8List publicKey;

  /// The Ed25519 signing key.
  final Uint8List secretKey;
}


/// Keypair
/// ------------------------------------------------------------------------------------------------

class Keypair implements Signer {

  /// Creates an account keypair used for signing transactions.
  const Keypair(
    this._keypair,
  );

  /// The public key and secret key pair.
  final Ed25519Keypair _keypair;

  /// The public key for this keypair.
  @override
  PublicKey get publicKey 
    => PublicKey.fromUint8List(_keypair.publicKey);

  /// The secret key for this keypair.
  @override
  Uint8List get secretKey 
    => _keypair.secretKey;

  /// {@macro Keypair.generateSync}
  static Future<Keypair> generate() async 
    => compute((_) => Keypair.generateSync(), null);

  /// {@template Keypair.generateSync}
  /// Generates a random keypair.
  /// {@endtemplate}
  factory Keypair.generateSync() 
    => Keypair(nacl.sign.keypair.sync());

  /// {@macro Keypair.fromSecretKeySync}
  static Future<Keypair> fromSecretKey(
    final Uint8List secretKey, {
    final bool skipValidation = false, 
  }) => compute((_) => Keypair.fromSecretKeySync(secretKey, skipValidation: skipValidation), null);

  /// {@template Keypair.fromSecretKeySync}
  /// Creates a [Keypair] from a [secretKey] byte array.
  /// 
  /// This method should only be used to recreate a keypair from a previously generated [secretKey]. 
  /// Generating keypairs from a random seed should be done with the [Keypair.fromSeedSync] method.
  /// 
  /// Throws a [KeypairException] for invalid [secretKey]s that do not pass validation.
  /// {@endtemplate}
  factory Keypair.fromSecretKeySync(
    final Uint8List secretKey, {
    final bool skipValidation = false, 
  }) {
    final Ed25519Keypair keypair = nacl.sign.keypair.fromSecretKeySync(secretKey);
    if (!skipValidation) {
      const String message = 'solana/web3.dart';
      final Uint8List signData = Uint8List.fromList(utf8.encode(message));
      final Uint8List signature = nacl.sign.detached.sync(signData, keypair.secretKey);
      if (!nacl.sign.detached.verifySync(signData, signature, keypair.publicKey)) {
        throw const KeypairException('Invalid secret key.');
      }
    }
    return Keypair(keypair);
  }

  /// {@macro Keypair.fromSeedSync}
  static Future<Keypair> fromSeed(final Uint8List seed) 
    => compute(Keypair.fromSeedSync, seed);

  /// {@template Keypair.fromSeedSync}
  /// Creates a [Keypair] from a `32-byte` [seed].
  /// {@endtemplate}
  factory Keypair.fromSeedSync(final Uint8List seed) 
    => Keypair(nacl.sign.keypair.fromSeedSync(seed));
}