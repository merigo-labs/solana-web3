/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data';
import 'package:solana_web3/src/buffer.dart';
import 'package:solana_web3/src/buffer_layout.dart' as buffer_layout;
import 'package:solana_web3/src/keypair.dart';
import 'package:solana_web3/src/nacl.dart' as nacl;
import 'package:solana_web3/src/public_key.dart';
import 'package:solana_web3/src/transaction/transaction.dart';
import 'package:solana_web3/src/utils/library.dart';


/// Create Ed25519 Instruction With Public Key Params
/// ------------------------------------------------------------------------------------------------

class CreateEd25519InstructionWithPublicKeyParams {

  /// Params for creating an ed25519 instruction using a public key.
  const CreateEd25519InstructionWithPublicKeyParams({
    required this.publicKey,
    required this.message,
    required this.signature,
    required this.instructionIndex,
  });

  final Uint8List publicKey;
  final Uint8List message;
  final Uint8List signature;
  final int? instructionIndex;
}


/// Create Ed25519 Instruction With Private Key Params
/// ------------------------------------------------------------------------------------------------

class CreateEd25519InstructionWithPrivateKeyParams {

  /// Params for creating an ed25519 instruction using a private key.
  const CreateEd25519InstructionWithPrivateKeyParams({
    required this.privateKey,
    required this.message,
    required this.instructionIndex,
  });
  final Uint8List privateKey;
  final Uint8List message;
  final int? instructionIndex;
}


/// Ed25519 Instruction Layout
/// ------------------------------------------------------------------------------------------------

final ed25519InstructionLayout = buffer_layout.struct([
  buffer_layout.u8('numSignatures'),
  buffer_layout.u8('padding'),
  buffer_layout.u16('signatureOffset'),
  buffer_layout.u16('signatureInstructionIndex'),
  buffer_layout.u16('publicKeyOffset'),
  buffer_layout.u16('publicKeyInstructionIndex'),
  buffer_layout.u16('messageDataOffset'),
  buffer_layout.u16('messageDataSize'),
  buffer_layout.u16('messageInstructionIndex'),
]);


/// Ed25519 Program
/// ------------------------------------------------------------------------------------------------

class Ed25519Program {
  
  /// Ed25519 program.
  const Ed25519Program();

  /// The public key that identifies the ed25519 program.
  static final PublicKey programId = PublicKey.fromString(
    'Ed25519SigVerify111111111111111111111111111',
  );

  /// Creates an ed25519 instruction with a public key and signature. The public key must be a 
  /// buffer that is 32 bytes long, and the signature must be a buffer of 64 bytes.
  static TransactionInstruction createInstructionWithPublicKey({
    required final Uint8List publicKey,
    required final Uint8List message,
    required final Uint8List signature,
    required final int? instructionIndex,
  }) {
    require(
      publicKey.length == nacl.publicKeyLength,
      'The public Key must be ${nacl.publicKeyLength} bytes but received ${publicKey.length} bytes.'
    );

    require(
      signature.length == nacl.signatureLength,
      'The signature must be ${nacl.signatureLength} bytes but received ${signature.length} bytes.'
    );

    final publicKeyOffset = ed25519InstructionLayout.span;
    final signatureOffset = publicKeyOffset + publicKey.length;
    final messageDataOffset = signatureOffset + signature.length;
    const numSignatures = 1;

    final instructionData = Buffer(messageDataOffset + message.length);

    final index = instructionIndex ?? 0xffff; // An index of `u16::MAX` makes it default to the 
                                              //current instruction.

    ed25519InstructionLayout.encode(
      {
        'numSignatures': numSignatures,
        'padding': 0,
        'signatureOffset': signatureOffset,
        'signatureInstructionIndex': index,
        'publicKeyOffset': publicKeyOffset,
        'publicKeyInstructionIndex': index,
        'messageDataOffset': messageDataOffset,
        'messageDataSize': message.length,
        'messageInstructionIndex': index,
      },
      instructionData,
    );

    instructionData.setAll(publicKeyOffset, publicKey);
    instructionData.setAll(signatureOffset, signature);
    instructionData.setAll(messageDataOffset, message);

    return TransactionInstruction(
      keys: [],
      programId: Ed25519Program.programId,
      data: instructionData.asUint8List(),
    );
  }

  //// Create an ed25519 instruction with a private key. The private key must be a buffer that is 64 
  /// bytes long.
  static TransactionInstruction createInstructionWithPrivateKey({
    required final Uint8List privateKey,
    required final Uint8List message,
    required final int? instructionIndex,
  }) {
    require(
      privateKey.length == nacl.secretKeyLength,
      'The private key must be ${nacl.secretKeyLength} bytes but received ${privateKey.length} bytes.'
    );

    try {
      final keypair = Keypair.fromSecretKey(privateKey);
      final publicKey = keypair.publicKey.toBytes();
      final signature = nacl.sign.detached(message, keypair.secretKey);

      return createInstructionWithPublicKey(
        publicKey: publicKey,
        message: message,
        signature: signature,
        instructionIndex: instructionIndex,
      );
    } catch (error) {
      throw Exception('Error creating ED25519 instruction: $error');
    }
  }
}