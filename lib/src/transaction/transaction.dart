/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data';
import '../instruction.dart';
import '../blockhash.dart';
import '../buffer.dart';
import '../keypair.dart';
import '../message/message.dart';
import '../models/serialisable.dart';
import '../nacl.dart' as nacl;
import '../public_key.dart';
import '../connection.dart';
import '../transaction/constants.dart';
import '../utils/convert.dart' as convert;
import '../utils/convert.dart';
import '../utils/shortvec.dart' as shortvec;
import '../utils/library.dart' show require;
import '../utils/types.dart';
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

class AccountMeta extends Serialisable {

  /// Account metadata used to define instructions.
  const AccountMeta(
    this.publicKey, {
    required this.isSigner,
    required this.isWritable,
  });

  /// An account's public key.
  final  PublicKey publicKey;
  
  /// True if an instruction requires a transaction signature matching `pubkey`.
  final bool isSigner;

  /// True if the `pubkey` can be loaded as a read-write account.
  final bool isWritable;
  
  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// AccountMeta.fromJson({ '<parameter>': <value> });
  /// ```
  factory AccountMeta.fromJson(final Map<String, dynamic> json) => AccountMeta(
    PublicKey.fromString(json['publicKey']),
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

class TransactionInstruction extends Serialisable {

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

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// TransactionInstruction.fromJson({ '<parameter>': <value> });
  /// ```
  factory TransactionInstruction.fromJson(final Map<String, dynamic> json) => TransactionInstruction(
    keys: convert.list.decode(json['keys'], AccountMeta.fromJson),
    programId: PublicKey.fromString(json['programId']),
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

class SignaturePublicKeyPair extends Serialisable {

  /// A signature and its corresponding public key.
  const SignaturePublicKeyPair({
    this.signature,
    required this.publicKey,
  });

  /// The signature.
  final Uint8List? signature;

  /// The public key.
  final PublicKey publicKey;
  
  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// SignaturePublicKeyPair.fromJson({ '<parameter>': <value> });
  /// ```
  factory SignaturePublicKeyPair.fromJson(final Map<String, dynamic> json) => SignaturePublicKeyPair(
    signature: json['signature'],
    publicKey: PublicKey.fromString(json['publicKey']),
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

class NonceInformation extends Serialisable {

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

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// NonceInformation.fromJson({ '<parameter>': <value> });
  /// ```
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

class Transaction extends Serialisable {

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

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// Transaction.fromJson({ '<parameter>': <value> });
  /// ```
  factory Transaction.fromJson(final Map<String, dynamic> json) => Transaction(
    feePayer: PublicKey.tryFromString(json['feePayer']),
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
    if (_message != null && _json == toJson()) {
      return _message;
    }

    // Add any `nonce` information to the transaction.
    String? nonce;
    final NonceInformation? nonceInfo = this.nonceInfo;
    if (nonceInfo != null 
        && (instructions.isEmpty || instructions.first != nonceInfo.nonceInstruction)) {
      nonce = nonceInfo.nonce;
      instructions.insert(0, nonceInfo.nonceInstruction);
    }

    // Check that a bloch hash has been provided.
    final Blockhash? recentBlockhash = nonce ?? this.recentBlockhash;
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
    final Iterable<Instruction> transaction = instructions.map(
      (final TransactionInstruction instruction) => instruction.toInstruction(accountKeys)
    );

    // Validate the indices of each instruction's program id and accounts.
    for (final Instruction instruction in transaction) {
      require(instruction.programIdIndex >= 0, 'Instruction program id index is < 0');
      for (var index in instruction.accounts) {
        require(index >= 0, 'Instruction account index is < 0');
      }
    }

    // Return the compiled transaction.
    return Message(
      accountKeys: accountKeys, 
      header: MessageHeader(
        numReadonlySignedAccounts: numReadonlySignedAccounts, 
        numReadonlyUnsignedAccounts: numReadonlyUnsignedAccounts, 
        numRequiredSignatures: numRequiredSignatures,
      ), 
      recentBlockhash: recentBlockhash, 
      instructions: transaction,
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
  sign(final List<Signer> signers, { final bool clear = true }) {

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
    
    final Buffer message = serializeMessage();

    for (final Signer signer in uniqueSigners) {
      final Uint8List signature = nacl.sign.detached(message.asUint8List(), signer.secretKey);
      final int index = signatures.indexWhere(
        (final SignaturePublicKeyPair pair) => signer.publicKey == pair.publicKey,
      );
      if (index < 0) {
        throw TransactionException('Unknown signer ${signer.publicKey}');
      }

      signatures[index] = signatures[index].copyWith(signature: signature);
    }
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
        if (!nacl.sign.detached.verify(message.asUint8List(), signature, pair.publicKey.toBytes())) {
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
    require(signatures.length < 256, 'The number of signatures must be < 256');
    Buffer.fromList(signatureCount).copy(wireTransaction, 0);
    
    for (int i = 0; i < signatures.length; ++i) {
      final Uint8List? signature = signatures[i].signature;
      if (signature != null) {
        require(signature.length == nacl.signatureLength, 'Invalid signature length.');
        Buffer.fromList(signature).copy(wireTransaction, signatureCount.length + i * 64);
      }
    }

    message.copy(wireTransaction, signatureCount.length + signatures.length * 64);
    require(
      wireTransaction.length <= packetDataSize,
      'Transaction is too large: ${wireTransaction.length} > $packetDataSize',
    );
    
    return wireTransaction;
  }

  /// Parses a wire transaction into a [Transaction] object.
  factory Transaction.fromList(final List<int> bytes) {
    final List<String> signatures = [];
    Buffer buffer = Buffer.fromList(bytes);
    final int signatureCount = shortvec.decodeLength(buffer.asUint8List());
    for (int i = 0; i < signatureCount; ++i) {
      final Buffer signature = buffer.slice(0, nacl.signatureLength);
      buffer = buffer.slice(nacl.signatureLength);
      signatures.add(base58.encode(signature.asUint8List()));
    }
    return Transaction.populate(Message.fromList(Uint8List(0)), signatures);
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
}