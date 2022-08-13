/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/instruction.dart';
import 'package:solana_web3/buffer_layout.dart' as buffer_layout;
import 'package:solana_web3/layout.dart' as layout;
import 'package:solana_web3/nonce_accounts.dart';
import 'package:solana_web3/public_key.dart';
import 'package:solana_web3/sysvar.dart';
import 'package:solana_web3/transaction.dart';
import 'package:solana_web3/utils/library.dart';
import 'package:solana_web3/utils/types.dart' show u64;


/// Create Account Params
/// ------------------------------------------------------------------------------------------------

class CreateAccountParams {

  /// Creates account system transaction params.
  const CreateAccountParams({
    required this.fromPublicKey,
    required this.newAccountPublicKey,
    required this.lamports,
    required this.space,
    required this.programId,
  });

  /// The account that will transfer lamports to the created account.
  final PublicKey fromPublicKey;

  /// The public key of the created account.
  final PublicKey newAccountPublicKey;

  /// The amount of lamports to transfer to the created account.
  final u64 lamports;
  
  /// The amount of space in bytes to allocate to the created account.
  final u64 space;

  /// The public key of the program to assign as the owner of the created account.
  final PublicKey programId;
}


/// Transfer Params
/// ------------------------------------------------------------------------------------------------

class TransferParams {

  /// Transfer system transaction params.
  const TransferParams({
    required this.fromPublicKey,
    required this.toPublicKey,
    required this.lamports,
  });

  /// The account that will transfer lamports.
  final PublicKey fromPublicKey;

  /// The account that will receive transferred lamports.
  final PublicKey toPublicKey;

  /// The amount of lamports to transfer.
  final u64 lamports;
}


/// Assign Params
/// ------------------------------------------------------------------------------------------------

class AssignParams {

  /// Assign system transaction params.
  const AssignParams({
    required this.accountPublicKey,
    required this.programId,
  });

  /// The public key of the account which will be assigned a new owner.
  final PublicKey accountPublicKey;

  /// The public key of the program to assign as the owner.
  final PublicKey programId;
}


/// Create Account With Seed Params
/// ------------------------------------------------------------------------------------------------

class CreateAccountWithSeedParams {

  /// Create account with [seed] system transaction params.
  const CreateAccountWithSeedParams({
    required this.fromPublicKey, 
    required this.newAccountPublicKey, 
    required this.basePublicKey, 
    required this.seed, 
    required this.lamports, 
    required this.space, 
    required this.programId,
  });

  /// The account that will transfer lamports to the created account.
  final PublicKey fromPublicKey;
  
  /// The public key of the created account. Must be pre-calculated with PublicKey.createWithSeed().
  final PublicKey newAccountPublicKey;

  /// The base public key used to derive the address of the created account. Must be the same as the 
  /// base key used to create `newAccountPublicKey`.
  final PublicKey basePublicKey;

  /// The seed used to derive the address of the created account. Must be the same as the seed used 
  /// to create `newAccountPublicKey`.
  final String seed;
  
  /// The amount of lamports to transfer to the created account.
  final u64 lamports;
  
  /// The amount of space in bytes to allocate to the created account.
  final u64 space;

  /// The public key of the program to assign as the owner of the created account.
  final PublicKey programId;
}


/// Create Nonce Account Params
/// ------------------------------------------------------------------------------------------------

class CreateNonceAccountParams {

  /// Create nonce account system transaction params.
  const CreateNonceAccountParams({
    required this.fromPublicKey,
    required this.noncePublicKey,
    required this.authorisedPublicKey,
    required this.lamports,
  });
  
  /// The account that will transfer lamports to the created nonce account.
  final PublicKey fromPublicKey;

  /// The public key of the created nonce account.
  final PublicKey noncePublicKey;
  
  /// Thje public key to set as authority of the created nonce account.
  final PublicKey authorisedPublicKey;

  /// The amount of lamports to transfer to the created nonce account.
  final u64 lamports;
}


/// Create Nonce Account With Seed Params
/// ------------------------------------------------------------------------------------------------

class CreateNonceAccountWithSeedParams {

  /// Create nonce account with seed system transaction params.
  const CreateNonceAccountWithSeedParams({
    required this.fromPublicKey,
    required this.noncePublicKey,
    required this.authorisedPublicKey,
    required this.lamports,
    required this.basePublicKey,
    required this.seed,
  });

  /// The account that will transfer lamports to the created nonce account.
  final PublicKey fromPublicKey;
  
  /// The public key of the created nonce account.
  final PublicKey noncePublicKey;
  
  /// The public key to set as the authority of the created nonce account.
  final PublicKey authorisedPublicKey;
  
  /// The amount of lamports to transfer to the created nonce account.
  final u64 lamports;

  /// The base public key used to derive the address of the nonce account.
  final PublicKey basePublicKey;

  /// The seed used to derive the address of the nonce account.
  final String seed;
}


/// Initialise Nonce Params
/// ------------------------------------------------------------------------------------------------

class InitialiseNonceParams {

  /// Initialise nonce account system instruction params.
  const InitialiseNonceParams({
    required this.noncePublicKey,
    required this.authorisedPublicKey,
  });

  /// The nonce account to be initialised.
  final PublicKey noncePublicKey;

  /// The public key to set as the authority of the initialised nonce account.
  final PublicKey authorisedPublicKey;
}


/// Advance Nonce Params
/// ------------------------------------------------------------------------------------------------

class AdvanceNonceParams {

  /// Advance nonce account system instruction params.
  const AdvanceNonceParams({
    required this.noncePublicKey,
    required this.authorisedPublicKey,
  });
  
  /// The nonce account.
  final PublicKey noncePublicKey;

  /// The public key of the nonce authority.
  final PublicKey authorisedPublicKey;
}


/// Withdraw Nonce Params
/// ------------------------------------------------------------------------------------------------

class WithdrawNonceParams {

  /// Withdraw nonce account system transaction params.
  const WithdrawNonceParams({
    required this.noncePublicKey,
    required this.authorisedPublicKey,
    required this.toPublicKey,
    required this.lamports,
  });

  /// The nonce account.
  final PublicKey noncePublicKey;

  /// The public key of the nonce authority.
  final PublicKey authorisedPublicKey;

  /// The public key of the account which will receive the withdrawn nonce account balance.
  final PublicKey toPublicKey;

  /// The mount of lamports to withdraw from the nonce account.
  final u64 lamports;
}


/// Authorise Nonce Params
/// ------------------------------------------------------------------------------------------------

class AuthoriseNonceParams {

  /// Authorise nonce account system transaction params.
  const AuthoriseNonceParams({
    required this.noncePublicKey,
    required this.authorisedPublicKey,
    required this.newAuthorisedPublicKey,
  });

  /// The nonce account.
  final PublicKey noncePublicKey;

  /// The public key of the current nonce authority.
  final PublicKey authorisedPublicKey;

  /// The public key to set as the new nonce authority.
  final PublicKey newAuthorisedPublicKey;
}


/// Allocate Params
/// ------------------------------------------------------------------------------------------------

class AllocateParams {

  /// Allocate account system transaction params.
  const AllocateParams({
    required this.accountPublicKey,
    required this.space,
  });

  /// The account to allocate.
  final PublicKey accountPublicKey;

  /// The amount of space in bytes to allocate.
  final u64 space;
}


/// Allocate With Seed Params
/// ------------------------------------------------------------------------------------------------

class AllocateWithSeedParams {

  /// Allocate account with seed system transaction params.
  const AllocateWithSeedParams({
    required this.accountPublicKey,
    required this.basePublicKey,
    required this.seed,
    required this.space,
    required this.programId,
  });

  /// The account to allocate.
  final PublicKey accountPublicKey;
  
  /// The base public key used to derive the address of the allocated account.
  final PublicKey basePublicKey;
  
  /// The seed used to derive the address of the allocated account.
  final String seed;

  /// The amount of space in bytes to allocate.
  final u64 space;

  /// The public key of the program to assign as the owner of the allocated account.
  final PublicKey programId;
}


/// Assign With Seed Params
/// ------------------------------------------------------------------------------------------------

class AssignWithSeedParams {

  /// Assign account with seed system transaction params.
  const AssignWithSeedParams({
    required this.accountPublicKey,
    required this.basePublicKey,
    required this.seed,
    required this.programId,
  });

  /// The public key of the account which will be assigned a new owner.
  final PublicKey accountPublicKey;

  /// The base public key used to derive the address of the assigned account.
  final PublicKey basePublicKey;

  /// The seed used to derive the address of the assigned account.
  final String seed;

  /// The public key of the program to assign as the owner.
  final PublicKey programId;
}


/// Transfer With Seed Params
/// ------------------------------------------------------------------------------------------------

class TransferWithSeedParams {

  /// Transfer with seed system transaction params.
  const TransferWithSeedParams({
    required this.fromPublicKey,
    required this.basePublicKey,
    required this.toPublicKey,
    required this.lamports,
    required this.seed,
    required this.programId,
  });

  /// The account that will transfer lamports.
  final PublicKey fromPublicKey;

  /// The base public key used to derive the funding account address.
  final PublicKey basePublicKey;

  /// The account that will receive the transferred lamports.
  final PublicKey toPublicKey;
  
  /// The amount of lamports to transfer.
  final u64 lamports;
  
  /// The seed used to derive the funding account address.
  final String seed;

  /// The program id used to derive the funding account address.
  final PublicKey programId;
}


/// Decoded Transfer Instruction
/// ------------------------------------------------------------------------------------------------

class DecodedTransferInstruction {

  /// Decoded transfer system transaction instruction.
  const DecodedTransferInstruction({
    required this.fromPublicKey,
    required this.toPublicKey,
    required this.lamports,
  });

  /// The account that will transfer lamports.
  final PublicKey fromPublicKey;

  /// The account that will receive the transferred lamports.
  final PublicKey toPublicKey;

  /// The amount of lamports to transfer.
  final u64 lamports;
}


/// Decoded Transfer With Seed Instruction
/// ------------------------------------------------------------------------------------------------

class DecodedTransferWithSeedInstruction {

  /// Decoded transferWithSeed system transaction instruction.
  const DecodedTransferWithSeedInstruction({
    required this.fromPublicKey,
    required this.basePublicKey,
    required this.toPublicKey,
    required this.lamports,
    required this.seed,
    required this.programId,
  });

  /// The account that will transfer lamports.
  final PublicKey fromPublicKey;
  
  /// The base public key used to derive the funding account address.
  final PublicKey basePublicKey;
  
  /// The account that will receive transferred lamports.
  final PublicKey toPublicKey;
  
  /// The amount of lamports to transfer.
  final u64 lamports;

  /// The seed used to derive the funding account address.
  final String seed;

  /// The program id used to derive the funding account address.
  final PublicKey programId;
}


/// System Instruction Types
/// ------------------------------------------------------------------------------------------------

enum SystemInstructionType {

  // The variants MUST be ordered by their [InstructionType.index].
  create,                 // 0
  assign,                 // 1
  transfer,               // 2
  createWithSeed,         // 3
  advanceNonceAccount,    // 4
  withdrawNonceAccount,   // 5
  initialiseNonceAccount, // 6
  authoriseNonceAccount,  // 7
  allocate,               // 8
  allocateWithSeed,       // 9
  assignWithSeed,         // 10
  transferWithSeed,       // 11
  upgradeNonceAccount,    // 12
  ;

  /// Returns the enum variant where [Enum.index] is equal to [index].
  /// 
  /// Throws an [RangeError] if [index] does not satisy the relations `0` ≤ `index` < 
  /// `values.length`.
  /// 
  /// ```
  /// SystemInstructionType.fromIndex(0); // [SystemInstructionType.create]
  /// SystemInstructionType.fromIndex(4); // [SystemInstructionType.advanceNonceAccount]
  /// // SystemInstructionType.fromIndex(SystemInstructionType.values.length); // Throws RangeError.
  /// ```
  factory SystemInstructionType.fromIndex(final int index) => values[index];
}


/// System Instruction
/// ------------------------------------------------------------------------------------------------

class SystemInstruction {

  const SystemInstruction();

  /// Decodes a system instruction and retrieves the instruction type.
  static SystemInstructionType decodeInstructionType(final TransactionInstruction instruction) {
    _checkProgramId(instruction.programId);
    final instructionTypeLayout = buffer_layout.u32('instruction');
    final int typeIndex = instructionTypeLayout.decode(instruction.data);
    return SystemInstructionType.fromIndex(typeIndex); // Throws an exception.
  }

   /// Decodes a create account system instruction and retrieve the instruction params.
  static CreateAccountParams decodeCreateAccount(final TransactionInstruction instruction) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 2);

    final Map<String, dynamic> data = Instruction.decodeData(
      SystemInstructionLayout.create(),
      instruction.data,
    );

    return CreateAccountParams(
      fromPublicKey: instruction.keys[0].publicKey,
      newAccountPublicKey: instruction.keys[1].publicKey,
      lamports: data['lamports'],
      space: data['seeds'],
      programId: PublicKey.fromString(data['programId']),
    );
  }

  /// Decodes a transfer system instruction and retrieve the instruction params.
  static DecodedTransferInstruction decodeTransfer(final TransactionInstruction instruction) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 2);

    final Map<String, dynamic> data = Instruction.decodeData(
      SystemInstructionLayout.transfer(),
      instruction.data,
    );

    return DecodedTransferInstruction(
      fromPublicKey: instruction.keys[0].publicKey,
      toPublicKey: instruction.keys[1].publicKey,
      lamports: data['lamports'],
    );
  }

  /// Decodes a transfer with seed system instruction and retrieve the instruction params.
  static DecodedTransferWithSeedInstruction decodeTransferWithSeed(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 3);

    final Map<String, dynamic> data = Instruction.decodeData(
      SystemInstructionLayout.transferWithSeed(),
      instruction.data,
    );

    return DecodedTransferWithSeedInstruction(
      fromPublicKey: instruction.keys[0].publicKey,
      basePublicKey: instruction.keys[1].publicKey,
      toPublicKey: instruction.keys[2].publicKey,
      lamports: data['lamports'],
      seed: data['seed'],
      programId: PublicKey.fromString(data['programId']),
    );
  }

  /// Decodes an allocate system instruction and retrieve the instruction params.
  static AllocateParams decodeAllocate(final TransactionInstruction instruction) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 1);

    final Map<String, dynamic> data = Instruction.decodeData(
      SystemInstructionLayout.allocate(),
      instruction.data,
    );

    return AllocateParams(
      accountPublicKey: instruction.keys[0].publicKey,
      space: data['space'],
    );
  }

  /// Decodes an allocate with seed system instruction and retrieve the instruction params.
  static AllocateWithSeedParams decodeAllocateWithSeed(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 1);

    final Map<String, dynamic> data = Instruction.decodeData(
      SystemInstructionLayout.allocateWithSeed(),
      instruction.data,
    );

    return AllocateWithSeedParams(
      accountPublicKey: instruction.keys[0].publicKey,
      basePublicKey: PublicKey.fromString(data['base']),
      seed: data['seed'],
      space: data['space'],
      programId: PublicKey.fromString(data['programId']),
    );
  }

  /// Decodes an assign system instruction and retrieve the instruction params.
  static AssignParams decodeAssign(final TransactionInstruction instruction) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 1);

    final Map<String, dynamic> data = Instruction.decodeData(
      SystemInstructionLayout.assign(),
      instruction.data,
    );

    return AssignParams(
      accountPublicKey: instruction.keys[0].publicKey,
      programId: PublicKey.fromString(data['programId']),
    );
  }

  /// Decodes an assign with seed system instruction and retrieve the instruction params.
  static AssignWithSeedParams decodeAssignWithSeed(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 1);

    final Map<String, dynamic> data = Instruction.decodeData(
      SystemInstructionLayout.assignWithSeed(),
      instruction.data,
    );

    return AssignWithSeedParams(
      accountPublicKey: instruction.keys[0].publicKey,
      basePublicKey: PublicKey(data['base']),
      seed: data['seed'],
      programId: PublicKey(data['programId']),
    );
  }

  /// Decodes a create account with seed system instruction and retrieve the instruction params.
  static CreateAccountWithSeedParams decodeCreateWithSeed(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 2);

    final Map<String, dynamic> data = Instruction.decodeData(
      SystemInstructionLayout.createWithSeed(),
      instruction.data,
    );

    return CreateAccountWithSeedParams(
      fromPublicKey: instruction.keys[0].publicKey,
      newAccountPublicKey: instruction.keys[1].publicKey,
      basePublicKey: PublicKey.fromString(data['base']),
      seed: data['seed'],
      lamports: data['lamports'],
      space: data['space'],
      programId: PublicKey.fromString(data['programId']),
    );
  }

  /// Decodes a nonce initialize system instruction and retrieve the instruction params.
  static InitialiseNonceParams decodeNonceInitialize(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 3);

    final Map<String, dynamic> data = Instruction.decodeData(
      SystemInstructionLayout.initialiseNonceAccount(),
      instruction.data,
    );

    return InitialiseNonceParams(
      noncePublicKey: instruction.keys[0].publicKey,
      authorisedPublicKey: PublicKey.fromString(data['authorized']),
    );
  }

  /// Decodes a nonce advance system instruction and retrieve the instruction params.
  static AdvanceNonceParams decodeNonceAdvance(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 3);

    Instruction.decodeData(
      SystemInstructionLayout.advanceNonceAccount(),
      instruction.data,
    );

    return AdvanceNonceParams(
      noncePublicKey: instruction.keys[0].publicKey,
      authorisedPublicKey: instruction.keys[2].publicKey,
    );
  }

  /// Decodes a nonce withdraw system instruction and retrieve the instruction params.
  static WithdrawNonceParams decodeNonceWithdraw(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 5);

    final Map<String, dynamic> data = Instruction.decodeData(
      SystemInstructionLayout.withdrawNonceAccount(),
      instruction.data,
    );

    return WithdrawNonceParams(
      noncePublicKey: instruction.keys[0].publicKey,
      toPublicKey: instruction.keys[1].publicKey,
      authorisedPublicKey: instruction.keys[4].publicKey,
      lamports: data['lamports'],
    );
  }

  /// Decodes a nonce authorize system instruction and retrieve the instruction params.
  static AuthoriseNonceParams decodeNonceAuthorise(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 2);

    final Map<String, dynamic> data = Instruction.decodeData(
      SystemInstructionLayout.authoriseNonceAccount(),
      instruction.data,
    );

    return AuthoriseNonceParams(
      noncePublicKey: instruction.keys[0].publicKey,
      authorisedPublicKey: instruction.keys[1].publicKey,
      newAuthorisedPublicKey: PublicKey.fromString(data['authorized']),
    );
  }
  
  /// Asserts that [programId] is the [SystemProgram.programId].
  /// 
  /// Throws an [AssertionError].
  static _checkProgramId(final PublicKey programId) {
    require(
      programId.equals(SystemProgram.programId), 
      'Invalid instruction; programId is not SystemProgram',
    );
  }

  /// Asserts that [keys] `length` is gte [expectedLength].
  /// 
  /// Throws an [AssertionError].
  static _checkKeyLength(final Iterable keys, final int expectedLength) {
    require(
      keys.length >= expectedLength, 
      'Invalid instruction; found ${keys.length} keys, expected at least $expectedLength',
    );
  }
}


/// System Instruction Layouts
/// ------------------------------------------------------------------------------------------------

class SystemInstructionLayout {

  /// System instruction layout.
  const SystemInstructionLayout();

  /// Create.
  static InstructionType<buffer_layout.Structure> create() {
    return InstructionType(
      index: SystemInstructionType.create.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
        buffer_layout.ns64('lamports'),
        buffer_layout.ns64('space'),
        layout.publicKey('programId'),
      ])
    );
  }

  /// Assign.
  static InstructionType<buffer_layout.Structure> assign() {
    return InstructionType(
      index: SystemInstructionType.assign.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
        layout.publicKey('programId'),
      ])
    );
  }

  /// Transfer.
  static InstructionType<buffer_layout.Structure> transfer() {
    return InstructionType(
      index: SystemInstructionType.transfer.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
        buffer_layout.nu64('lamports'),
      ])
    );
  }

  /// Create with seed.
  static InstructionType<buffer_layout.Structure> createWithSeed() {
    return InstructionType(
      index: SystemInstructionType.createWithSeed.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
        layout.publicKey('base'),
        layout.rustString('seed'),
        buffer_layout.ns64('lamports'),
        buffer_layout.ns64('space'),
        layout.publicKey('programId'),
      ]),
    );
  }

  /// Advance nonce account.
  static InstructionType<buffer_layout.Structure> advanceNonceAccount() {
    return InstructionType(
      index: SystemInstructionType.advanceNonceAccount.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction')
      ]),
    );
  }

  /// Withdraw nonce account.
  static InstructionType<buffer_layout.Structure> withdrawNonceAccount() {
    return InstructionType(
      index: SystemInstructionType.withdrawNonceAccount.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'), 
        buffer_layout.ns64('lamports'),
      ]),
    );
  }

  /// Initialise nonce account.
  static InstructionType<buffer_layout.Structure> initialiseNonceAccount() {
    return InstructionType(
      index: SystemInstructionType.initialiseNonceAccount.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'), 
        layout.publicKey('authorized')
      ]),
    );
  }

  /// Authorise nonce account.
  static InstructionType<buffer_layout.Structure> authoriseNonceAccount() {
    return InstructionType(
      index: SystemInstructionType.authoriseNonceAccount.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'), 
        layout.publicKey('authorized'),
      ]),
    );
  }

  /// Allocate.
  static InstructionType<buffer_layout.Structure> allocate() {
    return InstructionType(
      index: SystemInstructionType.allocate.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
        buffer_layout.ns64('space'),
      ]),
    );
  }

  /// Allocate with seed.
  static InstructionType<buffer_layout.Structure> allocateWithSeed() {
    return InstructionType(
      index: SystemInstructionType.allocateWithSeed.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
        layout.publicKey('base'),
        layout.rustString('seed'),
        buffer_layout.ns64('space'),
        layout.publicKey('programId'),
      ]),
    );
  }
  
  /// Assign with seed.
  static InstructionType<buffer_layout.Structure> assignWithSeed() {
    return InstructionType(
      index: SystemInstructionType.assignWithSeed.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
        layout.publicKey('base'),
        layout.rustString('seed'),
        layout.publicKey('programId'),
      ]),
    );
  }

  /// Transfer with seed.
  static InstructionType<buffer_layout.Structure> transferWithSeed() {
    return InstructionType(
      index: SystemInstructionType.transferWithSeed.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
        buffer_layout.nu64('lamports'),
        layout.rustString('seed'),
        layout.publicKey('programId'),
      ]),
    );
  }

  /// Upgrade nonce account.
  static InstructionType<buffer_layout.Structure> upgradeNonceAccount() {
    return InstructionType(
      index: SystemInstructionType.upgradeNonceAccount.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
      ]),
    );
  }
}


/// System Program
/// ------------------------------------------------------------------------------------------------

class SystemProgram {

  const SystemProgram._();

  /// The public key that identifies the System Program.
  static final PublicKey programId = PublicKey.zero();

  /// Generates a transaction instruction that creates a new account.
  /// 
  /// [fromPublicKey] The account that will transfer lamports to the created account.
  /// 
  /// [newAccountPublicKey] The public key of the created account.
  /// 
  /// [lamports] The amount of lamports to transfer to the created account.
  /// 
  /// [space] The amount of space in bytes to allocate to the created account.
  /// 
  /// [programId] The public key of the program to assign as the owner of the created account.
  static TransactionInstruction createAccount({
    required final PublicKey fromPublicKey,
    required final PublicKey newAccountPublicKey,
    required final u64 lamports,
    required final u64 space,
    required final PublicKey programId,
  }) {
    
    final type = SystemInstructionLayout.create();
    final data = Instruction.encodeData(type, {
      'lamports':lamports,
      'space': space,
      'programId': programId.toBytes(),
    });

    final List<AccountMeta> keys = [
      AccountMeta(fromPublicKey, isSigner: true, isWritable: true),
      AccountMeta(newAccountPublicKey, isSigner: true, isWritable: true),
    ];

    return TransactionInstruction(
      keys: keys,
      programId: SystemProgram.programId,
      data: data,
    );
  }

  /// Generates a transaction instruction that transfers lamports from one account to another.
  /// 
  /// [fromPublicKey] The account that will transfer lamports.
  /// 
  /// [toPublicKey] The account that will receive transferred lamports.
  /// 
  /// [lamports] The amount of lamports to transfer.
  static TransactionInstruction transfer({
    required final PublicKey fromPublicKey,
    required final PublicKey toPublicKey,
    required final BigInt lamports,
  }) {

    final type = SystemInstructionLayout.transfer();
    final data = Instruction.encodeData(type, {
      'lamports': lamports,
    });

    final List<AccountMeta> keys = [
      AccountMeta(fromPublicKey, isSigner: true, isWritable: true),
      AccountMeta(toPublicKey, isSigner: false, isWritable: true),
    ];

    return TransactionInstruction(
      keys: keys,
      programId: SystemProgram.programId,
      data: data,
    );
  }

  /// Generates a transaction instruction that transfers lamports from one account to another.
  /// 
  /// [fromPublicKey] The account that will transfer lamports.
  /// 
  /// [basePublicKey] The base public key used to derive the funding account address.
  /// 
  /// [toPublicKey] The account that will receive the transferred lamports.
  /// 
  /// [lamports] The amount of lamports to transfer.
  /// 
  /// [seed] The seed used to derive the funding account address.
  /// 
  /// [programId] The program id used to derive the funding account address.
  static TransactionInstruction transferWithSeed({
    required final PublicKey fromPublicKey,
    required final PublicKey basePublicKey,
    required final PublicKey toPublicKey,
    required final BigInt lamports,
    required final String seed,
    required final PublicKey programId,
  }) {

    final type = SystemInstructionLayout.transferWithSeed();
    final data = Instruction.encodeData(type, {
      'lamports': lamports,
      'seed': seed,
      'programId': programId.toBytes(),
    });

    final List<AccountMeta> keys = [
      AccountMeta(fromPublicKey, isSigner: false, isWritable: true),
      AccountMeta(basePublicKey, isSigner: true, isWritable: false),
      AccountMeta(toPublicKey, isSigner: false, isWritable: true),
    ];

    return TransactionInstruction(
      keys: keys,
      programId: SystemProgram.programId,
      data: data,
    );
  }

  /// Generates a transaction instruction that assigns an account to a program.
  /// 
  /// [accountPublicKey] The public key of the account which will be assigned a new owner.
  /// 
  /// [programId] The public key of the program to assign as the owner.
  static TransactionInstruction assign({
    required final PublicKey accountPublicKey,
    required final PublicKey programId,
  }) {
    
    final type = SystemInstructionLayout.assign();
    final data = Instruction.encodeData(type, {
      'programId': programId.toBytes(),
    });

    final List<AccountMeta> keys = [
      AccountMeta(accountPublicKey, isSigner: true, isWritable: true),
    ];

    return TransactionInstruction(
      keys: keys,
      programId: SystemProgram.programId,
      data: data,
    );
  }

  /// Generates a transaction instruction that assigns an account to a program.
  /// 
  /// [accountPublicKey] The public key of the account which will be assigned a new owner.
  /// 
  /// [basePublicKey] The base public key used to derive the address of the assigned account.
  /// 
  /// [seed] The seed used to derive the address of the assigned account.
  /// 
  /// [programId] The public key of the program to assign as the owner.
  static TransactionInstruction assignWithSeed({
    required final PublicKey accountPublicKey,
    required final PublicKey basePublicKey,
    required final String seed,
    required final PublicKey programId,
  }) {
    
    final type = SystemInstructionLayout.assignWithSeed();
    final data = Instruction.encodeData(type, {
      'base': basePublicKey.toBytes(),
      'seed': seed,
      'programId': programId.toBytes(),
    });

    final List<AccountMeta> keys = [
      AccountMeta(accountPublicKey, isSigner: false, isWritable: true),
      AccountMeta(basePublicKey, isSigner: true, isWritable: false),
    ];

    return TransactionInstruction(
      keys: keys,
      programId: SystemProgram.programId,
      data: data,
    );
  }

  /// Creates a transaction instruction that creates a new account at an address generated with 
  /// `fromPublicKey`, a `seed`, and `programId`.
  /// 
  /// [fromPublicKey] The account that will transfer lamports to the created account.
  /// 
  /// [newAccountPublicKey] The public key of the created account. Must be pre-calculated with 
  /// PublicKey.createWithSeed().
  /// 
  /// [basePublicKey] The base public key used to derive the address of the created account. Must be 
  /// the same as the base key used to create `newAccountPublicKey`.
  /// 
  /// [seed] The seed used to derive the address of the created account. Must be the same as the 
  /// seed used to create `newAccountPublicKey`.
  /// 
  /// [lamports] The amount of lamports to transfer to the created account.
  /// 
  /// [space] The amount of space in bytes to allocate to the created account.
  /// 
  /// [programId] The public key of the program to assign as the owner of the created account.
  static TransactionInstruction createAccountWithSeed({
    required final PublicKey fromPublicKey,
    required final PublicKey newAccountPublicKey,
    required final PublicKey basePublicKey,
    required final String seed,
    required final u64 lamports,
    required final u64 space,
    required final PublicKey programId,
  }) {

    final type = SystemInstructionLayout.createWithSeed();
    final data = Instruction.encodeData(type, {
      'base': basePublicKey.toBytes(),
      'seed': seed,
      'lamports': lamports,
      'space': space,
      'programId': programId.toBytes(),
    });

    final List<AccountMeta> keys = [
      AccountMeta(fromPublicKey, isSigner: true, isWritable: true),
      AccountMeta(newAccountPublicKey, isSigner: false, isWritable: true),
    ];

    if (fromPublicKey != basePublicKey) {
      keys.add(AccountMeta(basePublicKey, isSigner: true, isWritable: false));
    }

    return TransactionInstruction(
      keys: keys,
      programId: SystemProgram.programId,
      data: data,
    );
  }

  /// Generates a transaction that creates a new Nonce account.
  /// 
  /// [fromPublicKey] The account that will transfer lamports to the created nonce account.
  /// 
  /// [noncePublicKey] The public key of the created nonce account.
  /// 
  /// [authorisedPublicKey] The public key to set as the authority of the created nonce account.
  /// 
  /// [lamports] The amount of lamports to transfer to the created nonce account.
  static Transaction createNonceAccount({
    required final PublicKey fromPublicKey,
    required final PublicKey noncePublicKey,
    required final PublicKey authorisedPublicKey,
    required final u64 lamports,
  }) {
    return Transaction()
      ..add(
        SystemProgram.createAccount(
          fromPublicKey: fromPublicKey,
          newAccountPublicKey: noncePublicKey,
          lamports: lamports,
          space: nonceAccountLength,
          programId: SystemProgram.programId,
        ),
      )
      ..add(
        nonceInitialise(
          noncePublicKey: noncePublicKey,
          authorisedPublicKey: authorisedPublicKey,
        ),
      );
  }

  /// Generates a transaction that creates a new Nonce account.
  /// 
  /// [fromPublicKey] The account that will transfer lamports to the created nonce account.
  /// 
  /// [noncePublicKey] The public key of the created nonce account.
  /// 
  /// [authorisedPublicKey] The public key to set as the authority of the created nonce account.
  /// 
  /// [lamports] The amount of lamports to transfer to the created nonce account.
  /// 
  /// [basePublicKey] The base public key used to derive the address of the nonce account.
  /// 
  /// [seed] The seed used to derive the address of the nonce account.
  static Transaction createNonceAccountWithSeed({
    required final PublicKey fromPublicKey,
    required final PublicKey noncePublicKey,
    required final PublicKey authorisedPublicKey,
    required final u64 lamports,
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
          space: nonceAccountLength,
          programId: SystemProgram.programId,
        ),
      )
      ..add(
        nonceInitialise(
          noncePublicKey: noncePublicKey,
          authorisedPublicKey: authorisedPublicKey,
        ),
      );
  }

  /// Generates an instruction to initialise a Nonce account.
  /// 
  /// [noncePublicKey] The nonce account.
  /// 
  /// [authorisedPublicKey] The public key of the nonce authority.
  static TransactionInstruction nonceInitialise({
    required final PublicKey noncePublicKey,
    required final PublicKey authorisedPublicKey,
  }) {
    final type = SystemInstructionLayout.initialiseNonceAccount();
    final data = Instruction.encodeData(type, {
      'authorized': authorisedPublicKey.toBytes(),
    });

    final List<AccountMeta> keys = [
      AccountMeta(noncePublicKey, isSigner: false, isWritable: true),
      AccountMeta(sysvarRecentBlockhashesPublicKey, isSigner: false, isWritable: false),
      AccountMeta(sysvarRentPublicKey, isSigner: false, isWritable: false),
    ];

    return TransactionInstruction(
      keys: keys,
      programId: SystemProgram.programId,
      data: data,
    );
  }

  /// Generates an instruction to advance the nonce in a Nonce account.
  /// 
  /// [noncePublicKey] The nonce account.
  /// 
  /// [authorisedPublicKey] The public key of the nonce authority.
  static TransactionInstruction nonceAdvance({
    required final PublicKey noncePublicKey,
    required final PublicKey authorisedPublicKey,
  }) {
    final type = SystemInstructionLayout.advanceNonceAccount();
    final data = Instruction.encodeData(type);

    final List<AccountMeta> keys = [
      AccountMeta(noncePublicKey, isSigner: false, isWritable: true),
      AccountMeta(sysvarRecentBlockhashesPublicKey, isSigner: false, isWritable: false),
      AccountMeta(authorisedPublicKey, isSigner: true, isWritable: false),
    ];

    return TransactionInstruction(
      keys: keys,
      programId: SystemProgram.programId,
      data: data,
    );
  }

  /// Generates a transaction instruction that withdraws lamports from a Nonce account.
  /// 
  /// [noncePublicKey] The nonce account.
  /// 
  /// [authorisedPublicKey] The public key of the nonce authority.
  /// 
  /// [toPublicKey] The public key of the account which will receive the withdrawn nonce account 
  /// balance.
  /// 
  /// [lamports] The mount of lamports to withdraw from the nonce account.
  static TransactionInstruction nonceWithdraw({
    required final PublicKey noncePublicKey,
    required final PublicKey authorisedPublicKey,
    required final PublicKey toPublicKey,
    required final u64 lamports,
  }) {
    final type = SystemInstructionLayout.withdrawNonceAccount();
    final data = Instruction.encodeData(type, {
      'lamports': lamports,
    });

    final List<AccountMeta> keys = [
      AccountMeta(noncePublicKey, isSigner: false, isWritable: true),
      AccountMeta(toPublicKey, isSigner: false, isWritable: true),
      AccountMeta(sysvarRecentBlockhashesPublicKey, isSigner: false, isWritable: false),
      AccountMeta(sysvarRentPublicKey, isSigner: false, isWritable: false),
      AccountMeta(authorisedPublicKey, isSigner: true, isWritable: false),
    ];

    return TransactionInstruction(
      keys: keys,
      programId: SystemProgram.programId,
      data: data,
    );
  }

  /// Generates a transaction instruction that authorises a new PublicKey as the authority on a 
  /// Nonce account.
  /// 
  /// [noncePublicKey] The nonce account.
  /// 
  /// [authorisedPublicKey] The public key of the current nonce authority.
  /// 
  /// [newAuthorisedPublicKey] The public key to set as the new nonce authority.
  static TransactionInstruction nonceAuthorise({
    required final PublicKey noncePublicKey,
    required final PublicKey authorisedPublicKey,
    required final PublicKey newAuthorisedPublicKey,
  }) {

    final type = SystemInstructionLayout.authoriseNonceAccount();
    final data = Instruction.encodeData(type, {
      'authorized': newAuthorisedPublicKey.toBytes(),
    });

    final List<AccountMeta> keys = [
      AccountMeta(noncePublicKey, isSigner: false, isWritable: true),
      AccountMeta(authorisedPublicKey, isSigner: true, isWritable: false),
    ];

    return TransactionInstruction(
      keys: keys,
      programId: SystemProgram.programId,
      data: data,
    );
  }

  /// Generates a transaction instruction that allocates space in an account without funding.
  /// 
  /// [accountPublicKey] The public key of the account which will be assigned a new owner.
  /// 
  /// [space] The amount of space in bytes to allocate.
  static TransactionInstruction allocate({
    required final PublicKey accountPublicKey,
    required final u64 space,
  }) {

    final type = SystemInstructionLayout.allocate();
    final data = Instruction.encodeData(type, {
      'space': space,
    });

    final List<AccountMeta> keys = [
      AccountMeta(accountPublicKey, isSigner: true, isWritable: true),
    ];

    return TransactionInstruction(
      keys: keys,
      programId: SystemProgram.programId,
      data: data,
    );
  }

  /// Generates a transaction instruction that allocates space in an account without funding.
  /// 
  /// [accountPublicKey] The public key of the account which will be assigned a new owner.
  /// 
  /// [basePublicKey] The base public key used to derive the address of the assigned account.
  /// 
  /// [seed] The seed used to derive the address of the assigned account.
  /// 
  /// [space] The amount of space in bytes to allocate.
  /// 
  /// [programId] The public key of the program to assign as the owner.
  static TransactionInstruction allocateWithSeed({
    required final PublicKey accountPublicKey,
    required final PublicKey basePublicKey,
    required final String seed,
    required final u64 space,
    required final PublicKey  programId,
  }) {

    final type = SystemInstructionLayout.allocateWithSeed();
    final data = Instruction.encodeData(type, {
      'base': basePublicKey.toBytes(),
      'seed': seed,
      'space': space,
      'programId': programId.toBytes(),
    });

    final List<AccountMeta> keys = [
      AccountMeta(accountPublicKey, isSigner: false, isWritable: true),
      AccountMeta(basePublicKey, isSigner: true, isWritable: false),
    ];

    return TransactionInstruction(
      keys: keys,
      programId: SystemProgram.programId,
      data: data,
    );
  }
}