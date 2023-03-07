/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert';
import 'dart:typed_data';
import 'package:solana_common/utils/buffer.dart';
import 'package:solana_common/utils/convert.dart' as convert;
import 'package:solana_common/utils/convert.dart';
import 'package:solana_common/utils/types.dart' show u64;
import 'package:solana_common/utils/utils.dart' show check;
import 'package:solana_web3/rpc_models/blockhash_with_expiry_block_height.dart';
import '../instruction.dart';
import '../blockhash.dart';
import '../keypair.dart';
import '../message/message.dart';
import 'package:solana_common/models/serializable.dart';
import '../nacl.dart' as nacl;
import '../nacl.dart';
import '../public_key.dart';
import '../connection.dart';
import '../transaction/constants.dart';
import '../utils/shortvec.dart' as shortvec;
import '../../exceptions/transaction_exception.dart';


/// Transaction Signature
/// ------------------------------------------------------------------------------------------------

/// A base-58 encoded string.
typedef TransactionSignature = String;


// /// Transaction Status
// /// ------------------------------------------------------------------------------------------------

// enum TransactionStatus {
//   blockHeigntExceeded,
//   processed,
//   timedOut,
// }


/// Default (empty) Signature
/// ------------------------------------------------------------------------------------------------

final Buffer defaultSignature = Buffer(nacl.signatureLength);


/// Account Meta
/// ------------------------------------------------------------------------------------------------

class AccountMeta extends Serializable {

  /// Account metadata used to define instructions.
  const AccountMeta(
    this.publicKey, {
    this.isSigner = false,
    this.isWritable = false,
  });

  /// An account's public key.
  final PublicKey publicKey;
  
  /// True if an instruction requires a transaction signature matching `pubkey`.
  final bool isSigner;

  /// True if the `pubkey` can be loaded as a read-write account.
  final bool isWritable;

  factory AccountMeta.signer(final PublicKey publicKey, { final bool isWritable = false }) 
    => AccountMeta(publicKey, isSigner: true, isWritable: isWritable);
  
  factory AccountMeta.writable(final PublicKey publicKey, { final bool isSigner = false }) 
    => AccountMeta(publicKey, isSigner: isSigner, isWritable: true);

  factory AccountMeta.signerAndWritable(final PublicKey publicKey) 
    => AccountMeta(publicKey, isSigner: true, isWritable: true);
  
  /// {@macro solana_common.Serializable.fromJson}
  factory AccountMeta.fromJson(final Map<String, dynamic> json) => AccountMeta(
    PublicKey.fromBase58(json['publicKey']),
    isSigner: json['isSigner'],
    isWritable: json['isWritable'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'publicKey': publicKey.toBase58(),
    'isSigner': isSigner,
    'isWritable': isWritable,
  };

  /// Creates a copy of this class applying the provided parameters to the new instance.
  AccountMeta copyWith({
    final PublicKey? publicKey,
    final bool? isSigner,
    final bool? isWritable,
  }) {
    return AccountMeta(
      publicKey ?? this.publicKey, 
      isSigner: isSigner ?? this.isSigner, 
      isWritable: isWritable ?? this.isWritable,
    );
  }
}


/// Serialize Config
/// ------------------------------------------------------------------------------------------------

class SerializeConfig {

  /// Configuration object for [Transaction.serialize]
  const SerializeConfig({
    this.requireAllSignatures = true,
    this.verifySignatures = true,
  });

  /// Require all transaction signatures be present (default: true).
  final bool requireAllSignatures;

  /// Verify provided signatures (default: true).
  final bool verifySignatures;
}


/// Transaction Instruction
/// ------------------------------------------------------------------------------------------------

class TransactionInstruction extends Serializable {

  /// A TransactionInstruction object.
  TransactionInstruction({
    required this.keys,
    required this.programId,
    Uint8List? data,
  }): data = Buffer.fromList(data ?? Uint8List(0));

  /// Public keys to include in this transaction.
  final List<AccountMeta> keys;

  //// Program Id to execute
  final PublicKey programId;

  /// Program input
  final Buffer data;

  /// {@macro solana_common.Serializable.fromJson}
  factory TransactionInstruction.fromJson(final Map<String, dynamic> json) => TransactionInstruction(
    keys: convert.list.decode(json['keys'], AccountMeta.fromJson),
    programId: PublicKey.fromBase58(json['programId']),
    data: json['data'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'keys': convert.list.encode(keys),
    'programId': programId.toBase58(),
    'data': data.asUint8List(),
  };

  /// Returns a list containing the indices of the given account [keys] as they appear in 
  /// [TransactionInstruction.keys].
  Iterable<int> accounts(final List<PublicKey> keys) {
    return this.keys.map((final AccountMeta meta) => keys.indexOf(meta.publicKey));
  }

  /// Converts this [TransactionInstruction] into an [Instruction]. The [keys] are an ordered list 
  /// of `all` public keys referenced by this transaction.
  Instruction toInstruction(final List<PublicKey> keys) => Instruction(
    programIdIndex: keys.indexOf(programId), 
    accounts: accounts(keys), 
    data: convert.base58.encode(data.asUint8List()),
  );
}


/// Signature Public Key Pair
/// ------------------------------------------------------------------------------------------------

class SignaturePublicKeyPair extends Serializable {

  /// A signature and its corresponding public key.
  const SignaturePublicKeyPair({
    this.signature,
    required this.publicKey,
  });

  /// The signature.
  final Uint8List? signature;

  /// The public key.
  final PublicKey publicKey;
  
  /// {@macro solana_common.Serializable.fromJson}
  factory SignaturePublicKeyPair.fromJson(final Map<String, dynamic> json) => SignaturePublicKeyPair(
    signature: json['signature'],
    publicKey: PublicKey.fromBase58(json['publicKey']),
  );

  @override
  Map<String, dynamic> toJson() => {
    'signature': signature,
    'publicKey': publicKey.toBase58(),
  };

  /// Creates a copy of this class applying the provided parameters to the new instance.
  SignaturePublicKeyPair copyWith({
    final Uint8List? signature,
    final PublicKey? publicKey,
  }) {
    return SignaturePublicKeyPair(
      signature: signature ?? this.signature,
      publicKey: publicKey ?? this.publicKey,
    );
  }
}


/// Nonce Information
/// ------------------------------------------------------------------------------------------------

class NonceInformation extends Serializable {

  /// Nonce information to be used to build an offline Transaction.
  const NonceInformation({
    required this.nonce,
    required this.nonceInstruction,
  });
  
  /// The current blockhash stored in the nonce.
  final Blockhash nonce;

  /// AdvanceNonceAccount Instruction
  final TransactionInstruction nonceInstruction;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Return `null` if [json] is `null`.
  /// 
  /// ```
  /// NonceInformation.tryParse({ '<parameter>': <value> });
  /// ```
  static NonceInformation? tryParse(final Map<String, dynamic>? json) {
    return json != null ? NonceInformation.fromJson(json) : null;
  }

  /// {@macro solana_common.Serializable.fromJson}
  factory NonceInformation.fromJson(final Map<String, dynamic> json) => NonceInformation(
    nonce: json['nonce'],
    nonceInstruction: TransactionInstruction.fromJson(json['nonceInstruction']),
  );
  
  @override
  Map<String, dynamic> toJson() => {
    'nonce': nonce,
    'nonceInstruction': nonceInstruction.toJson(),
  };
}


/// Transaction
/// ------------------------------------------------------------------------------------------------

class Transaction extends Serializable {

  /// Transaction.
  Transaction({
    this.feePayer,
    List<SignaturePublicKeyPair>? signatures,
    this.recentBlockhash,
    this.lastValidBlockHeight,
    final List<TransactionInstruction>? instructions,
    this.nonceInfo,
  }): signatures = signatures ?? [],
      instructions = instructions ?? [];

  /// The transaction's fee payer.
  final PublicKey? feePayer;

  /// One or more signatures for the transaction. Typically created by invoking the [sign] method.
  final List<SignaturePublicKeyPair> signatures;

  /// A recent transaction id.
  final Blockhash? recentBlockhash;

  /// The last block the chain can advance to before tx is declared expired.
  final u64? lastValidBlockHeight;

  /// The instructions to atomically execute.
  final List<TransactionInstruction> instructions;

  /// If provided, the transaction will use a durable Nonce hash instead of a [recentBlockhash].
  final NonceInformation? nonceInfo;

  /// The saved compiled message.
  Message? _message;

  /// The saved [_message]'s JSON output.
  Map<String, dynamic>? _json;

  /// The first (payer) Transaction signature.
  Uint8List? get signature {
    return signatures.isNotEmpty ? signatures.first.signature : null;
  }

  /// Blockhash.
  BlockhashWithExpiryBlockHeight? get blockhash {
    return recentBlockhash != null && lastValidBlockHeight != null
      ? BlockhashWithExpiryBlockHeight(
          blockhash: recentBlockhash!, 
          lastValidBlockHeight: lastValidBlockHeight!,
        )
      : null;
  }

  /// {@macro solana_common.Serializable.fromJson}
  factory Transaction.fromJson(final Map<String, dynamic> json) => Transaction(
    feePayer: PublicKey.tryFromBase58(json['feePayer']),
    signatures: convert.list.decode(json['signatures'], SignaturePublicKeyPair.fromJson),
    recentBlockhash: json['recentBlockhash'],
    lastValidBlockHeight: json['lastValidBlockHeight'],
    instructions: convert.list.decode(json['instructions'], TransactionInstruction.fromJson),
    nonceInfo: NonceInformation.tryParse(json['nonceInfo']),
  );
  
  @override
  Map<String, dynamic> toJson() => {
    'feePayer': feePayer?.toBase58(),
    'signatures': convert.list.encode(signatures),
    'recentBlockhash': recentBlockhash,
    'lastValidBlockHeight': lastValidBlockHeight,
    'instructions': convert.list.encode(instructions),
    'nonceInfo': nonceInfo?.toJson(),
  };

  /// Creates a copy of this class applying the provided parameters to the new instance.
  Transaction copyWith({
    final PublicKey? feePayer,
    final List<SignaturePublicKeyPair>? signatures,
    final Blockhash? recentBlockhash,
    final u64? lastValidBlockHeight,
    final List<TransactionInstruction>? instructions,
    final NonceInformation? nonceInfo,
  }) {
    final transaction = Transaction(
      feePayer: feePayer ??  this.feePayer,
      signatures: signatures ?? this.signatures,
      recentBlockhash: recentBlockhash ?? this.recentBlockhash,
      lastValidBlockHeight: lastValidBlockHeight ?? this.lastValidBlockHeight,
      instructions: instructions ?? this.instructions,
      nonceInfo: nonceInfo ?? this.nonceInfo,
    );
    transaction._message = _message;
    transaction._json = _json;
    return transaction;
  }

  /// Creates a copy of this class applying the provided [blockhash].
  Transaction copyWithBlockhash(
    final BlockhashWithExpiryBlockHeight blockhash,
  ) => copyWith(
      recentBlockhash: blockhash.blockhash,
      lastValidBlockHeight: blockhash.lastValidBlockHeight,
    );

  /// Appends [instruction] to this [Transaction].
  void add(final TransactionInstruction instruction) {
    instructions.add(instruction);
  }

  /// Appends all [instructions] to this [Transaction].
  void addAll(final List<TransactionInstruction> instructions) {
    this.instructions.addAll(instructions);
  }

  /// Check that the [publicKeys] have each provided their [signatures].
  bool validSignatures({ required final List<PublicKey> publicKeys }) {
    if (signatures.length != publicKeys.length) {
      return false;
    }
    for (int i = 0; i < signatures.length; ++i) {
      if (signatures[i].publicKey != publicKeys[i]) {
        return false;
      }
    }
    return true;
  }

  /// Compiles the transaction's message.
  Message compileMessage() {

    // Return the cached message if no changes have been made.
    final Message? _message = this._message;
    if (_message != null && json.encode(_json) == json.encode(toJson())) {
      return _message;
    }

    // Add any `nonce` information to the transaction.
    final List<TransactionInstruction> instructions = List.from(this.instructions);
    final NonceInformation? nonceInfo = this.nonceInfo;
    if (nonceInfo != null) {
      if (instructions.isEmpty || instructions.first != nonceInfo.nonceInstruction) {
        instructions.insert(0, nonceInfo.nonceInstruction);
      }
    }

    // Check that a bloch hash has been provided.
    final Blockhash? recentBlockhash = nonceInfo?.nonce ?? this.recentBlockhash;
    if(recentBlockhash == null) {
      throw const TransactionException('Transaction requires a recentBlockhash');
    }

    // Check that a payer account has been provided.
    PublicKey? feePayer = this.feePayer;
    if (feePayer == null) {
      if (signatures.isNotEmpty) {
        feePayer = signatures.first.publicKey;
      } else {
        throw const TransactionException('Transaction fee payer required');
      }
    }

    // Collect all [programIds] and [accountMetas] found in the [instructions].
    final List<PublicKey> programIds = [];
    final List<AccountMeta> accountMetas = [];
    for (final TransactionInstruction instruction in instructions) {
      accountMetas.addAll(instruction.keys);
      final PublicKey programId = instruction.programId;
      if (!programIds.contains(programId)) {
        programIds.add(programId);
      }
    }

    // Append program id account metas.
    for (final PublicKey programId in programIds) {
      accountMetas.add(
        AccountMeta(
          programId, 
          isSigner: false, 
          isWritable: false,
        ),
      );
    }

    // Remove duplicate account metas.
    List<AccountMeta> uniqueMetas = [];
    for (final AccountMeta accountMeta in accountMetas) {
      // Find the index of [publicKey]'s existing account meta.
      final int index = uniqueMetas.indexWhere((final AccountMeta meta) {
        return meta.publicKey == accountMeta.publicKey;
      });
      // Add [publicKey] to [uniqueMetas] if it doesn't already exist or updgrade its existing
      // account meta to be a `signer` or `writable` if [accountMeta] is a signer or writable.
      if (index < 0) {
        uniqueMetas.add(accountMeta);
      } else {
        uniqueMetas[index] = accountMeta.copyWith(
          isSigner: uniqueMetas[index].isSigner || accountMeta.isSigner,
          isWritable: uniqueMetas[index].isWritable || accountMeta.isWritable,
        );
      }
    }

    // Sort [uniqueMetas] by signer accounts, followed by writable accounts.
    uniqueMetas.sort((final AccountMeta x, final AccountMeta y) {
      // Signers must be place before non-signers.
      if (x.isSigner != y.isSigner) {
        return x.isSigner ? -1 : 1;
      }
      // Writable accounts must be placed before read-only accounts.
      if (x.isWritable != y.isWritable) {
        return x.isWritable ? -1 : 1;
      }
      // Otherwise, sort by the public key's base-58 encoded string.
      return x.publicKey.toBase58().compareTo(y.publicKey.toBase58());
    });

    // Move the fee payer to the front of the list.
    final int feePayerIndex = uniqueMetas.indexWhere((final AccountMeta meta) {
      return meta.publicKey == feePayer;
    });
    if (feePayerIndex < 0) {
      uniqueMetas.insert(0, AccountMeta(feePayer, isSigner: true, isWritable: true));
    } else {
      final AccountMeta payerMeta = uniqueMetas.removeAt(feePayerIndex);
      uniqueMetas.insert(0, payerMeta.copyWith(isSigner: true, isWritable: true));
    } 

    // Check that there are no unknown signers.
    for (final SignaturePublicKeyPair signature in signatures) {
      final int index = uniqueMetas.indexWhere((final AccountMeta meta) {
        return meta.publicKey == signature.publicKey;
      });
      if (index < 0) {
        throw TransactionException('Unknown signer: ${signature.publicKey.toBase58()}');
      } else if (!uniqueMetas[index].isSigner) {
        uniqueMetas[index] = uniqueMetas[index].copyWith(isSigner: true);
        throw const TransactionException(
          'The transaction references a signature that is unnecessary. Only the fee payer and '
          'instruction signer accounts should sign a transaction.'
        );
      }
    }

    // [MessageHeader] values.
    int numRequiredSignatures = 0;
    int numReadonlySignedAccounts = 0;
    int numReadonlyUnsignedAccounts = 0;

    // Collect the signing and non-signing keys into separate lists and count [MessageHeader] 
    // values.
    final List<PublicKey> signedKeys = [];
    final List<PublicKey> unsignedKeys = [];
    for (final AccountMeta accountMeta in uniqueMetas) {
      if (accountMeta.isSigner) {
        signedKeys.add(accountMeta.publicKey);
        numRequiredSignatures += 1;
        if (!accountMeta.isWritable) {
          numReadonlySignedAccounts += 1;
        }
      } else {
        unsignedKeys.add(accountMeta.publicKey);
        if (!accountMeta.isWritable) {
          numReadonlyUnsignedAccounts += 1;
        }
      }
    }

    // Convert the [TransactionInstruction]s into [Instructions].
    final List<PublicKey> accountKeys = signedKeys + unsignedKeys;
    final Iterable<Instruction> compiledInstructions = instructions.map(
      (final TransactionInstruction instruction) => instruction.toInstruction(accountKeys)
    );

    // Validate the indices of each instruction's program id and accounts.
    for (final Instruction instruction in compiledInstructions) {
      check(instruction.programIdIndex >= 0, 'Instruction program id index is < 0');
      for (var index in instruction.accounts) {
        check(index >= 0, 'Instruction account index is < 0');
      }
    }

    // Return the compiled transaction.
    return Message(
      header: MessageHeader(
        numRequiredSignatures: numRequiredSignatures,
        numReadonlySignedAccounts: numReadonlySignedAccounts, 
        numReadonlyUnsignedAccounts: numReadonlyUnsignedAccounts, 
      ), 
      accountKeys: accountKeys, 
      recentBlockhash: recentBlockhash, 
      instructions: compiledInstructions,
    );
  }

  /// Creates and verifies the transaction's message.
  Message compileAndVerifyMessage() {

    // Creates the transaction's message.
    final Message message = compileMessage();

    // Get the number of signers required by this transaction.
    final int numRequiredSignatures = message.header.numRequiredSignatures;

    // Get the public keys of the accounts that must sign this transaction.
    final List<PublicKey> publicKeys = message.accountKeys.sublist(0, numRequiredSignatures);

    // Verify that the accounts required to sign this transaction ([publicKeys]) have provided their 
    // [signatures] or unsign the transaction.
    if (!validSignatures(publicKeys: publicKeys)) {
      unsign(publicKeys: publicKeys);
    }

    // Return the compiled message.
    return message;
  }

  /// Get a buffer of the Transaction data that needs to be covered by signatures.
  Buffer serializeMessage() {
    return compileAndVerifyMessage().serialize();
  }

  /// Get the estimated fee associated with a transaction
  Future<u64> getEstimatedFee(final Connection connection) {
    return connection.getFeeForMessage(compileMessage());
  }

  /// Unsign this [Transaction] by replacing all [signatures] with unsigned [publicKeys].
  void unsign({ required final Iterable<PublicKey> publicKeys }) {
    signatures.clear();
    for (final PublicKey publicKey in publicKeys) {
      signatures.add(SignaturePublicKeyPair(publicKey: publicKey));
    }
  }

  /// Signs this [Transaction] with the specified signers. Multiple signatures may be applied to a 
  /// [Transaction]. The first signature is considered "primary" and is used to identify and confirm 
  /// transactions.
  ///
  /// If the [Transaction]'s `feePayer` is not set, the first signer will be used as the 
  /// transaction's fee payer account.
  ///
  /// Transaction fields should not be modified after the first call to `sign`, as doing so may 
  /// invalidate the signature and cause the [Transaction] to be rejected.
  ///
  /// The Transaction must be assigned a valid `recentBlockhash` before invoking this method.
  void sign(final Iterable<Signer> signers, { final bool clear = true }) {

    if (signers.isEmpty) {
      throw const TransactionException(
        'The transaction has not been signed. Call Transaction.sign() with the required signers.',
      );
    }

    final Set<PublicKey> unique = {};
    final List<Signer> uniqueSigners = signers.where(
      (final Signer signer) => unique.add(signer.publicKey)
    ).toList(growable: false); // consume and store the result of the lazy iterable.

    if (clear) {
      unsign(publicKeys: uniqueSigners.map((final Signer pair) => pair.publicKey));
    }
    
    final Message message = compileMessage();
    _partialSign(message, signers);
    
    // final Buffer message = serializeMessage();

    // for (final Signer signer in uniqueSigners) {
    //   final Uint8List signature = nacl.sign.detached(message.asUint8List(), signer.secretKey);
    //   final int index = signatures.indexWhere(
    //     (final SignaturePublicKeyPair pair) => signer.publicKey == pair.publicKey,
    //   );
    //   if (index < 0) {
    //     throw TransactionException('Unknown signer ${signer.publicKey}');
    //   }

    //   signatures[index] = signatures[index].copyWith(signature: signature);
    // }
  }

  /// Partially sign a transaction with the specified accounts. All accounts must correspond to 
  /// either the fee payer or a signer account in the transaction instructions.
  /// 
  /// All the caveats from the `sign` method apply to `partialSign`.
  void partialSign(final Iterable<Signer> signers) {
    if (signers.isEmpty) {
      throw const TransactionException('No signers');
    }

    // Dedupe signers
    final Set<PublicKey> unique = {};
    final List<Signer> uniqueSigners = signers.where(
      (final Signer signer) => unique.add(signer.publicKey)
    ).toList(growable: false); // consume and store the result of the lazy iterable.

    final message = compileMessage();
    _partialSign(message, uniqueSigners);
  }

  /// @internal
  void _partialSign(final Message message, final Iterable<Signer> signers) {
    final signData = message.serialize().asUint8List();
    for (final Signer signer in signers) {
      final Uint8List signature = nacl.sign.detached.sync(signData, signer.secretKey);
      _addSignature(signer.publicKey, Buffer.fromUint8List(signature));
    }
  }

  /// Add an externally created signature to a transaction. The public key must correspond to either 
  /// the fee payer or a signer account in the transaction instructions.
  void addSignature(final PublicKey pubkey, final Buffer signature) {
    compileMessage(); // Ensure signatures array is populated
    _addSignature(pubkey, signature);
  }

  /// @internal
  void _addSignature(final PublicKey publicKey, final Buffer signature) {
    check(signature.length == nacl.signatureLength);
    final int index = signatures.indexWhere(
      (final SignaturePublicKeyPair pair) => publicKey == pair.publicKey,
    );
    if (index < 0) {
      throw TransactionException('Unknown signer $publicKey');
    }
    signatures[index] = signatures[index].copyWith(signature: signature.asUint8List());
  }

  /// Verifies signatures of a complete, signed Transaction.
  bool verifySignatures() {
    return _verifySignatures(serializeMessage(), requireAllSignatures: true);
  }

  /// Verifies signatures of a complete, signed Transaction.
  bool _verifySignatures(final Buffer message, { final bool requireAllSignatures = true }) {
    for (final SignaturePublicKeyPair pair in signatures) {
      final Uint8List? signature = pair.signature;
      if (signature == null) {
        if (requireAllSignatures) {
          return false;
        }
      } else {
        if (!nacl.sign.detached.verifySync(
          message.asUint8List(), 
          signature, pair.publicKey.toBytes()
        )) {
          return false;
        }
      }
    }
    return true;
  }

  /// Serialises this [Transaction] into the wire format.
  Buffer serialize([SerializeConfig? config]) {
    config ??= const SerializeConfig();
    final Buffer message = serializeMessage();
    if (config.verifySignatures
        && !_verifySignatures(message, requireAllSignatures: config.requireAllSignatures)) {
      throw const TransactionException('Signature verification failed');
    }
    return _serialize(message);
  }

  /// Serialises a [Transaction] buffer into the wire format.
  Buffer _serialize(final Buffer message) {
    final List<int> signatureCount = shortvec.encodeLength(signatures.length);
    final int transactionLength = signatureCount.length + signatures.length * 64 + message.length;
    final Buffer wireTransaction = Buffer(transactionLength);
    check(signatures.length < 256, 'The number of signatures must be < 256');
    Buffer.fromList(signatureCount).copy(wireTransaction, 0);
    
    for (int i = 0; i < signatures.length; ++i) {
      final Uint8List? signature = signatures[i].signature;
      if (signature != null) {
        check(signature.length == nacl.signatureLength, 'Invalid signature length.');
        Buffer.fromList(signature).copy(wireTransaction, signatureCount.length + i * 64);
      }
    }

    message.copy(wireTransaction, signatureCount.length + signatures.length * 64);
    check(
      wireTransaction.length <= packetDataSize,
      'Transaction is too large: ${wireTransaction.length} > $packetDataSize',
    );
    
    return wireTransaction;
  }

  factory Transaction.fromBase64(final String encoded)
    => Transaction.fromList(base64.decode(encoded));

  /// Parses a wire transaction into a [Transaction] object.
  factory Transaction.fromList(final List<int> bytes) {
    final List<String> signatures = [];
    final BufferReader reader = BufferReader.fromList(bytes);
    final int signatureCount = shortvec.decodeLength(reader);
    for (int i = 0; i < signatureCount; ++i) {
      final Buffer signature = reader.getBuffer(nacl.signatureLength);
      signatures.add(convert.base58.encode(signature.asUint8List()));
    }
    final prefix = reader[0];
    final maskedPrefix = prefix & versionPrefixMask;
    if (maskedPrefix != prefix) {
      // TODO: Add versioned transactions.
      throw UnimplementedError('Versioned Transactions have not been implemented.');
    }
    return Transaction.populate(Message.fromBuffer(reader.toBuffer(slice: true)), signatures);
  }

  /// Populates a [Transaction] object with the contents of [message] and the provided [signatures].
  factory Transaction.populate(final Message message, [final List<String> signatures = const []]) {
    
    final Blockhash? recentBlockhash = message.recentBlockhash;
    final PublicKey? feePayer = message.header.numRequiredSignatures > 0 && message.accountKeys.isNotEmpty
      ? message.accountKeys.first 
      : null;

    final Transaction transaction = Transaction(
      feePayer: feePayer,
      recentBlockhash: recentBlockhash,
    );

    for (int i = 0; i < signatures.length; ++i) {
      final String signature = signatures[i];
      final SignaturePublicKeyPair pair = SignaturePublicKeyPair(
        signature: signature != convert.base58.encode(defaultSignature.asUint8List()) 
          ? convert.base58.decode(signature)
          : null,
        publicKey: message.accountKeys[i],
      );
      transaction.signatures.add(pair);
    }

    for (final Instruction instruction in message.instructions) {
      final Iterable<AccountMeta> keys = instruction.accounts.map((final int i) {
        final PublicKey publicKey = message.accountKeys[i];
        return AccountMeta(
          publicKey,
          isSigner: transaction.signatures.any((pair) => pair.publicKey == publicKey) || message.isAccountSigner(i),
          isWritable: message.isAccountWritable(i)
        );
      });
      
      transaction.instructions.add(
        TransactionInstruction(
          keys: keys.toList(), 
          programId: message.accountKeys[instruction.programIdIndex],
          data: convert.base58.decode(instruction.data),
        )
      );
    }

    transaction._message = message;
    transaction._json = transaction.toJson();

    return transaction;
  }

  static List<TransactionSignature> decodeSignatures(final String base64Encoded) {
    final List<TransactionSignature> signatures = [];
    final Uint8List base64Decoded = base64.decode(base64Encoded);
    final BufferReader reader = BufferReader.fromUint8List(base64Decoded);
    final int numberOfSignatures = reader.getUint8();
    for (int i = 0; i < numberOfSignatures; ++i) {
      signatures.add(base58.encode(reader.getBuffer(signatureLength).asUint8List()));
    }
    return signatures;
  }
}