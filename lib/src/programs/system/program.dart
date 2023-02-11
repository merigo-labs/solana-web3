/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/borsh/borsh.dart';
import 'package:solana_common/extensions/num.dart';
import 'package:solana_common/utils/buffer.dart';
import 'package:solana_common/utils/types.dart';
import '../../../programs/program.dart';
import '../../nonce_account.dart';
import '../../sysvar.dart';
import '../../transaction/transaction.dart';
import '../../public_key.dart';
import 'instruction.dart';


/// System Program
/// ------------------------------------------------------------------------------------------------

class SystemProgram extends Program {

  /// System program.
  SystemProgram._()
    : super(PublicKey.zero());

  /// Internal singleton instance.
  static final SystemProgram _instance = SystemProgram._();

  /// The program id.
  static PublicKey get programId => _instance.publicKey;

  @override
  Iterable<int> encodeInstruction<T extends Enum>(final T instruction)
    => Buffer.fromUint32(instruction.index);

  /// Generates a transaction instruction that creates a new account.
  /// 
  /// ### Keys:
  /// - `[w,s]` [fromPublicKey] - The account that will transfer lamports to the created account.
  /// - `[w,s]` [newAccountPublicKey] - The public key of the created account.
  /// 
  /// ### Data:
  /// - [lamports] - The amount of lamports to transfer to the created account.
  /// - [space] - The amount of space in bytes to allocate to the created account.
  /// - [programId] - The public key of the program to assign as the owner of the created account.
  static TransactionInstruction createAccount({
    required final PublicKey fromPublicKey,
    required final PublicKey newAccountPublicKey,
    required final bu64 lamports,
    required final bu64 space,
    required final PublicKey programId,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.signerAndWritable(fromPublicKey),
      AccountMeta.signerAndWritable(newAccountPublicKey),
    ];
    
    final List<Iterable<int>> data = [
      borsh.u64.encode(lamports),
      borsh.u64.encode(space),
      borsh.publicKey.encode(programId.toBase58()),
    ];

    return _instance.createTransactionIntruction(
      SystemInstruction.create, 
      keys: keys, 
      data: data,
    );
  }

  /// Generates a transaction instruction that transfers lamports from one account to another.
  /// 
  /// ### Keys:
  /// - [fromPublicKey] The account that will transfer lamports.
  /// - [toPublicKey] The account that will receive transferred lamports.
  /// 
  /// ### Data:
  /// - [lamports] The amount of lamports to transfer.
  static TransactionInstruction transfer({
    required final PublicKey fromPublicKey,
    required final PublicKey toPublicKey,
    required final BigInt lamports,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.signerAndWritable(fromPublicKey),
      AccountMeta.writable(toPublicKey),
    ];   
    
    final List<Iterable<int>> data = [
      borsh.u64.encode(lamports),
    ];

    return _instance.createTransactionIntruction(
      SystemInstruction.transfer, 
      keys: keys, 
      data: data,
    );
  }

  /// Generates a transaction instruction that transfers lamports from one account to another.
  /// 
  /// ### Keys:
  /// - [fromPublicKey] The account that will transfer lamports.
  /// - [basePublicKey] The base public key used to derive the funding account address.
  /// - [toPublicKey] The account that will receive the transferred lamports.
  /// 
  /// ### Data:
  /// - [lamports] The amount of lamports to transfer.
  /// - [seed] The seed used to derive the funding account address.
  /// - [programId] The program id used to derive the funding account address.
  static TransactionInstruction transferWithSeed({
    required final PublicKey fromPublicKey,
    required final PublicKey basePublicKey,
    required final PublicKey toPublicKey,
    required final BigInt lamports,
    required final String seed,
    required final PublicKey programId,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.writable(fromPublicKey),
      AccountMeta.signer(basePublicKey),
      AccountMeta.writable(toPublicKey),
    ];
    
    final List<Iterable<int>> data = [
      borsh.u64.encode(lamports),
      borsh.string.encode(seed),
      borsh.publicKey.encode(programId.toBase58()),
    ];

    return _instance.createTransactionIntruction(
      SystemInstruction.transferWithSeed, 
      keys: keys, 
      data: data,
    );
  }

  /// Generates a transaction instruction that assigns an account to a program.
  /// 
  /// ### Keys:
  /// - [accountPublicKey] The public key of the account which will be assigned a new owner.
  /// 
  /// ### Data:
  /// - [programId] The public key of the program to assign as the owner.
  static TransactionInstruction assign({
    required final PublicKey accountPublicKey,
    required final PublicKey programId,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.signerAndWritable(accountPublicKey),
    ];
    
    final List<Iterable<int>> data = [
      borsh.publicKey.encode(programId.toBase58()),
    ];

    return _instance.createTransactionIntruction(
      SystemInstruction.assign, 
      keys: keys, 
      data: data,
    );
  }

  /// Generates a transaction instruction that assigns an account to a program.
  /// 
  /// ### Keys:
  /// - [accountPublicKey] The public key of the account which will be assigned a new owner.
  /// 
  /// ### Data:
  /// - [basePublicKey] The base public key used to derive the address of the assigned account.
  /// - [seed] The seed used to derive the address of the assigned account.
  /// - [programId] The public key of the program to assign as the owner.
  static TransactionInstruction assignWithSeed({
    required final PublicKey accountPublicKey,
    required final PublicKey basePublicKey,
    required final String seed,
    required final PublicKey programId,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.writable(accountPublicKey),
      AccountMeta.signer(basePublicKey),
    ];
    
    final List<Iterable<int>> data = [
      borsh.publicKey.encode(basePublicKey.toBase58()),
      borsh.string.encode(seed),
      borsh.publicKey.encode(programId.toBase58()),
    ];

    return _instance.createTransactionIntruction(
      SystemInstruction.assignWithSeed, 
      keys: keys, 
      data: data,
    );
  }

  /// Creates a transaction instruction that creates a new account at an address generated with 
  /// `fromPublicKey`, a `seed`, and `programId`.
  /// 
  /// ### Keys:
  /// - [fromPublicKey] The account that will transfer lamports to the created account.
  /// - [newAccountPublicKey] The public key of the created account. Must be pre-calculated with 
  ///   PublicKey.createWithSeed().
  /// 
  /// ### Data:
  /// - [basePublicKey] The base public key used to derive the address of the created account. Must be 
  ///   the same as the base key used to create `newAccountPublicKey`.
  /// - [seed] The seed used to derive the address of the created account. Must be the same as the 
  ///   seed used to create `newAccountPublicKey`.
  /// - [lamports] The amount of lamports to transfer to the created account.
  /// - [space] The amount of space in bytes to allocate to the created account.
  /// - [programId] The public key of the program to assign as the owner of the created account.
  static TransactionInstruction createAccountWithSeed({
    required final PublicKey fromPublicKey,
    required final PublicKey newAccountPublicKey,
    required final PublicKey basePublicKey,
    required final String seed,
    required final bu64 lamports,
    required final bu64 space,
    required final PublicKey programId,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.signerAndWritable(fromPublicKey),
      AccountMeta.writable(newAccountPublicKey),
      if (fromPublicKey != basePublicKey)
        AccountMeta.signer(basePublicKey),
    ];
    
    final List<Iterable<int>> data = [
      borsh.publicKey.encode(basePublicKey.toBase58()),
      borsh.string.encode(seed),
      borsh.u64.encode(lamports),
      borsh.u64.encode(space),
      borsh.publicKey.encode(programId.toBase58()),
    ];

    return _instance.createTransactionIntruction(
      SystemInstruction.createWithSeed, 
      keys: keys, 
      data: data,
    );
  }

  /// Generates a transaction that creates a new Nonce account.
  /// 
  /// ### Keys:
  /// - [fromPublicKey] The account that will transfer lamports to the created nonce account.
  /// - [noncePublicKey] The public key of the created nonce account.
  /// - [authorizedPublicKey] The public key to set as the authority of the created nonce account.
  /// 
  /// ### Data:
  /// - [lamports] The amount of lamports to transfer to the created nonce account.
  static Transaction createNonceAccount({
    required final PublicKey fromPublicKey,
    required final PublicKey noncePublicKey,
    required final PublicKey authorizedPublicKey,
    required final bu64 lamports,
  }) {
    return Transaction()
      ..add(
        SystemProgram.createAccount(
          fromPublicKey: fromPublicKey,
          newAccountPublicKey: noncePublicKey,
          lamports: lamports,
          space: nonceAccountLength.toBigInt(),
          programId: SystemProgram.programId,
        ),
      )
      ..add(
        nonceInitialize(
          noncePublicKey: noncePublicKey,
          authorizedPublicKey: authorizedPublicKey,
        ),
      );
  }

  /// Generates a transaction that creates a new Nonce account.
  /// 
  /// ### Keys: 
  /// - [fromPublicKey] The account that will transfer lamports to the created nonce account.
  /// - [noncePublicKey] The public key of the created nonce account.
  /// - [authorizedPublicKey] The public key to set as the authority of the created nonce account.
  /// 
  /// ### Data:
  /// - [lamports] The amount of lamports to transfer to the created nonce account.
  /// - [basePublicKey] The base public key used to derive the address of the nonce account.
  /// - [seed] The seed used to derive the address of the nonce account.
  static Transaction createNonceAccountWithSeed({
    required final PublicKey fromPublicKey,
    required final PublicKey noncePublicKey,
    required final PublicKey authorizedPublicKey,
    required final bu64 lamports,
    required final PublicKey basePublicKey,
    required final String seed,
  }) {
    return Transaction()
      ..add(
        SystemProgram.createAccountWithSeed(
          fromPublicKey: fromPublicKey,
          newAccountPublicKey: noncePublicKey,
          basePublicKey: basePublicKey,
          seed: seed,
          lamports: lamports,
          space: nonceAccountLength.toBigInt(),
          programId: SystemProgram.programId,
        ),
      )
      ..add(
        nonceInitialize(
          noncePublicKey: noncePublicKey,
          authorizedPublicKey: authorizedPublicKey,
        ),
      );
  }

  /// Generates an instruction to initialize a Nonce account.
  /// 
  /// ### Keys:
  /// - [noncePublicKey] The nonce account.
  /// 
  /// ### Data:
  /// - [authorizedPublicKey] The public key of the nonce authority.
  static TransactionInstruction nonceInitialize({
    required final PublicKey noncePublicKey,
    required final PublicKey authorizedPublicKey,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.writable(noncePublicKey),
      AccountMeta(sysvarRecentBlockhashesPublicKey),
      AccountMeta(sysvarRentPublicKey),
    ];
    
    final List<Iterable<int>> data = [
      borsh.publicKey.encode(authorizedPublicKey.toBase58()),
    ];

    return _instance.createTransactionIntruction(
      SystemInstruction.initializeNonceAccount, 
      keys: keys, 
      data: data,
    );
  }

  /// Generates an instruction to advance the nonce in a Nonce account.
  /// 
  /// ### Keys:
  /// - [noncePublicKey] The nonce account.
  /// - [authorizedPublicKey] The public key of the nonce authority.
  static TransactionInstruction nonceAdvance({
    required final PublicKey noncePublicKey,
    required final PublicKey authorizedPublicKey,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.writable(noncePublicKey),
      AccountMeta(sysvarRecentBlockhashesPublicKey),
      AccountMeta.signer(authorizedPublicKey),
    ];

    return _instance.createTransactionIntruction(
      SystemInstruction.advanceNonceAccount, 
      keys: keys, 
    );
  }

  /// Generates a transaction instruction that withdraws lamports from a Nonce account.
  /// 
  /// ### Keys:
  /// - [noncePublicKey] The nonce account.
  /// - [authorizedPublicKey] The public key of the nonce authority.
  /// - [toPublicKey] The public key of the account which will receive the withdrawn nonce account 
  ///   balance.
  /// 
  /// ### Data:
  /// - [lamports] The mount of lamports to withdraw from the nonce account.
  static TransactionInstruction nonceWithdraw({
    required final PublicKey noncePublicKey,
    required final PublicKey authorizedPublicKey,
    required final PublicKey toPublicKey,
    required final bu64 lamports,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.writable(noncePublicKey),
      AccountMeta.writable(toPublicKey),
      AccountMeta(sysvarRecentBlockhashesPublicKey),
      AccountMeta(sysvarRentPublicKey),
      AccountMeta.signer(authorizedPublicKey),
    ];
    
    final List<Iterable<int>> data = [
      borsh.u64.encode(lamports),
    ];

    return _instance.createTransactionIntruction(
      SystemInstruction.withdrawNonceAccount, 
      keys: keys, 
      data: data,
    );
  }

  /// Generates a transaction instruction that authorises a new PublicKey as the authority on a 
  /// Nonce account.
  /// 
  /// ### Keys:
  /// - [noncePublicKey] The nonce account.
  /// - [authorizedPublicKey] The public key of the current nonce authority.
  /// 
  /// ### Data:
  /// - [newAuthorizedPublicKey] The public key to set as the new nonce authority.
  static TransactionInstruction nonceAuthorize({
    required final PublicKey noncePublicKey,
    required final PublicKey authorizedPublicKey,
    required final PublicKey newAuthorizedPublicKey,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.writable(noncePublicKey),
      AccountMeta.signer(authorizedPublicKey),
    ];
    
    final List<Iterable<int>> data = [
      borsh.publicKey.encode(newAuthorizedPublicKey.toBase58()),
    ];

    return _instance.createTransactionIntruction(
      SystemInstruction.authorizeNonceAccount, 
      keys: keys, 
      data: data,
    );
  }

  /// Generates a transaction instruction that allocates space in an account without funding.
  /// 
  /// ### Keys:
  /// - [accountPublicKey] The public key of the account which will be assigned a new owner.
  /// 
  /// ### Data:
  /// - [space] The amount of space in bytes to allocate.
  static TransactionInstruction allocate({
    required final PublicKey accountPublicKey,
    required final bu64 space,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.signerAndWritable(accountPublicKey),
    ];
    
    final List<Iterable<int>> data = [
      borsh.u64.encode(space),
    ];

    return _instance.createTransactionIntruction(
      SystemInstruction.allocate, 
      keys: keys, 
      data: data,
    );
  }

  /// Generates a transaction instruction that allocates space in an account without funding.
  /// 
  /// ### Keys:
  /// - [accountPublicKey] The public key of the account which will be assigned a new owner.
  /// 
  /// ### Data:
  /// - [basePublicKey] The base public key used to derive the address of the assigned account.
  /// - [seed] The seed used to derive the address of the assigned account.
  /// - [space] The amount of space in bytes to allocate.
  /// - [programId] The public key of the program to assign as the owner.
  static TransactionInstruction allocateWithSeed({
    required final PublicKey accountPublicKey,
    required final PublicKey basePublicKey,
    required final String seed,
    required final bu64 space,
    required final PublicKey  programId,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.writable(accountPublicKey),
      AccountMeta.signer(basePublicKey),
    ];
    
    final List<Iterable<int>> data = [
      borsh.publicKey.encode(basePublicKey.toBase58()),
      borsh.string.encode(seed),
      borsh.u64.encode(space),
      borsh.publicKey.encode(programId.toBase58()),
    ];

    return _instance.createTransactionIntruction(
      SystemInstruction.allocateWithSeed, 
      keys: keys, 
      data: data,
    );
  }
}