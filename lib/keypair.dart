/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data';
import 'package:solana_web3/exceptions/keypair_exception.dart';
import 'package:solana_web3/nacl.dart' as nacl;
import 'package:solana_web3/public_key.dart';


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
  Keypair(
    final Ed25519Keypair? keypair,
  ): _keypair = keypair ?? nacl.sign.keypair();

  /// The public key and secret key pair.
  final Ed25519Keypair _keypair;

  /// The public key for this keypair.
  @override
  PublicKey get publicKey => PublicKey.fromUint8List(_keypair.publicKey);

  /// The secret key for this keypair.
  @override
  Uint8List get secretKey => _keypair.secretKey;

  /// Generates a random keypair.
  factory Keypair.generate() => Keypair(nacl.sign.keypair());

  /// Creates a [Keypair] from a [secretKey] byte array.
  /// 
  /// This method should only be used to recreate a keypair from a previously generated [secretKey]. 
  /// Generating keypairs from a random seed should be done with the [Keypair.fromSeed] method.
  /// 
  /// Throws a [KeypairException] for invalid [secretKey]s that do not pass validation.
  factory Keypair.fromSecretKey(
    final Uint8List secretKey, {
    final bool skipValidation = false, 
  }) {
    final Ed25519Keypair keypair = nacl.sign.keypair.fromSecretKey(secretKey);
    if (!skipValidation) {
      const String message = 'solana/web3.dart';
      final Uint8List signData = Uint8List.fromList(message.codeUnits);
      final Uint8List signature = nacl.sign.detached(signData, keypair.secretKey);
      if (!nacl.sign.detached.verify(signData, signature, keypair.publicKey)) {
        throw const KeypairException('Invalid secret key.');
      }
    }
    return Keypair(keypair);
  }

  /// Creates a [Keypair] from a `32-byte` [seed].
  factory Keypair.fromSeed(final Uint8List seed) {
    return Keypair(nacl.sign.keypair.fromSeed(seed));
  }
}