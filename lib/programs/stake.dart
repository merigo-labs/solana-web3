/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data';
import 'system.dart';
import '../src/buffer_layout.dart' as buffer_layout;
import '../src/instruction.dart';
import '../src/layout.dart' as layout;
import '../src/public_key.dart';
import '../src/sysvar.dart';
import '../src/transaction/transaction.dart';
import '../src/utils/library.dart' show require;
import '../src/utils/types.dart' show u64;


/// Stake Config Public Key
/// ------------------------------------------------------------------------------------------------

/// Address of the stake config account which configures the rate of stake warmup and cooldown as 
/// well as the slashing penalty.
final stakeConfigId = PublicKey.fromString(
  'StakeConfig11111111111111111111111111111111',
);


/// Authorized
/// ------------------------------------------------------------------------------------------------

class Authorized {

  /// Stake account authority info.
  const Authorized({
    required this.staker,
    required this.withdrawer,
  });

  /// Stake authority.
  final PublicKey staker;

  /// Withdraw authority.
  final PublicKey withdrawer;
}


/// Authorized Raw
/// ------------------------------------------------------------------------------------------------

class AuthorizedRaw {

  /// Stake account authority info.
  const AuthorizedRaw({
    required this.staker,
    required this.withdrawer,
  });

  /// Stake authority.
  final Uint8List staker;

  /// Withdraw authority.
  final Uint8List withdrawer;
}


/// Lockup
/// ------------------------------------------------------------------------------------------------

class Lockup {

  /// Stake account lockup info.
  const Lockup({
    required this.unixTimestamp,
    required this.epoch,
    required this.custodian,
  });

  /// Unix timestamp of lockup expiration.
  final int unixTimestamp;

  /// Epoch of lockup expiration.
  final int epoch;

  /// Lockup custodian authority.
  final PublicKey custodian;

  /// The default, inactive lockup value.
  static final Lockup inactive = Lockup(unixTimestamp: 0, epoch: 0, custodian: PublicKey.zero());
}


/// Lockup Raw
/// ------------------------------------------------------------------------------------------------

class LockupRaw {

  /// Stake account lockup info.
  const LockupRaw({
    required this.unixTimestamp,
    required this.epoch,
    required this.custodian,
  });

  /// Unix timestamp of lockup expiration.
  final int unixTimestamp;

  /// Epoch of lockup expiration.
  final int epoch;

  /// Lockup custodian authority.
  final Uint8List custodian;
}


/// Create Stake Account Params
/// ------------------------------------------------------------------------------------------------

class CreateStakeAccountParams {

  /// Create stake account transaction params.
  const CreateStakeAccountParams({
    required this.fromPublicKey,
    required this.stakePublicKey,
    required this.authorized,
    this.lockup,
    required this.lamports,
  });

  /// Address of the account which will fund creation.
  final PublicKey fromPublicKey;

  /// Address of the new stake account.
  final PublicKey stakePublicKey;
  
  /// Authorities of the new stake account.
  final Authorized authorized;
  
  /// Lockup of the new stake account.
  final Lockup? lockup;
  
  /// Funding amount.
  final u64 lamports;
}


/// Create Stake Account Params
/// ------------------------------------------------------------------------------------------------

class CreateStakeAccountWithSeedParams {

  /// Create stake account with seed transaction params.
  const CreateStakeAccountWithSeedParams({
    required this.fromPublicKey,
    required this.stakePublicKey,
    required this.basePublicKey,
    required this.seed,
    required this.authorized,
    this.lockup,
    required this.lamports,
  });

  final PublicKey fromPublicKey;
  final PublicKey stakePublicKey;
  final PublicKey basePublicKey;
  final String seed;
  final Authorized authorized;
  final Lockup? lockup;
  final u64 lamports;
}


/// Initialize Stake Params
/// ------------------------------------------------------------------------------------------------

class InitializeStakeParams {

  /// Initialize stake instruction params.
  const InitializeStakeParams({
    required this.stakePublicKey,
    required this.authorized,
    this.lockup,
  });

  final PublicKey stakePublicKey;
  final Authorized authorized;
  final Lockup? lockup;
}


/// Delegate Stake Params
/// ------------------------------------------------------------------------------------------------

class DelegateStakeParams {
  
  /// Delegate stake instruction params.
  const DelegateStakeParams({
    required this.stakePublicKey,
    required this.authorizedPublicKey,
    required this.votePublicKey,
  });

  final PublicKey stakePublicKey;
  final PublicKey authorizedPublicKey;
  final PublicKey votePublicKey;
}


/// Authorize Stake Params
/// ------------------------------------------------------------------------------------------------

class AuthorizeStakeParams {

  /// Authorise stake instruction params.
  const AuthorizeStakeParams({
    required this.stakePublicKey,
    required this.authorizedPublicKey,
    required this.newAuthorizedPublicKey,
    required this.stakeAuthorizationType,
    required this.custodianPublicKey,
  });

  final PublicKey stakePublicKey;
  final PublicKey authorizedPublicKey;
  final PublicKey newAuthorizedPublicKey;
  final StakeAuthorizationType stakeAuthorizationType;
  final PublicKey? custodianPublicKey;
}


/// Authorize With Seed Stake Params
/// ------------------------------------------------------------------------------------------------

class AuthorizeWithSeedStakeParams {

  /// Authorize stake instruction params using a derived key.
  const AuthorizeWithSeedStakeParams({
    required this.stakePublicKey,
    required this.authorityBase,
    required this.authoritySeed,
    required this.authorityOwner,
    required this.newAuthorizedPublicKey,
    required this.stakeAuthorizationType,
    required this.custodianPublicKey,
  });

  final PublicKey stakePublicKey;
  final PublicKey authorityBase;
  final String authoritySeed;
  final PublicKey authorityOwner;
  final PublicKey newAuthorizedPublicKey;
  final StakeAuthorizationType stakeAuthorizationType;
  final PublicKey? custodianPublicKey;
}


/// Split Stake Params
/// ------------------------------------------------------------------------------------------------

class SplitStakeParams {

  /// Split stake instruction params.
  const SplitStakeParams({
    required this.stakePublicKey,
    required this.authorizedPublicKey,
    required this.splitStakePublicKey,
    required this.lamports,
  });

  final PublicKey stakePublicKey;
  final PublicKey authorizedPublicKey;
  final PublicKey splitStakePublicKey;
  final u64 lamports;
}


/// Split Stake With Seed Params
/// ------------------------------------------------------------------------------------------------

class SplitStakeWithSeedParams {

  /// Split with seed transaction params.
  const SplitStakeWithSeedParams({
    required this.stakePublicKey,
    required this.authorizedPublicKey,
    required this.splitStakePublicKey,
    required this.basePublicKey,
    required this.seed,
    required this.lamports,
  });

  final PublicKey stakePublicKey;
  final PublicKey authorizedPublicKey;
  final PublicKey splitStakePublicKey;
  final PublicKey basePublicKey;
  final String seed;
  final u64 lamports;
}


/// Withdraw Stake Params
/// ------------------------------------------------------------------------------------------------

class WithdrawStakeParams {

  /// Withdraw stake instruction params.
  const WithdrawStakeParams({
    required this.stakePublicKey,
    required this.authorizedPublicKey,
    required this.toPublicKey,
    required this.lamports,
    required this.custodianPublicKey,
  });

  final PublicKey stakePublicKey;
  final PublicKey authorizedPublicKey;
  final PublicKey toPublicKey;
  final u64 lamports;
  final PublicKey? custodianPublicKey;
}


/// Deactivate Stake Params
/// ------------------------------------------------------------------------------------------------

class DeactivateStakeParams {

  /// Deactivate stake instruction params.
  const DeactivateStakeParams({
    required this.stakePublicKey,
    required this.authorizedPublicKey,
  });

  final PublicKey stakePublicKey;
  final PublicKey authorizedPublicKey;
}


/// Merge Stake Params
/// ------------------------------------------------------------------------------------------------

class MergeStakeParams {

  /// Merge stake instruction params.
  const MergeStakeParams({
    required this.stakePublicKey,
    required this.sourceStakePublicKey,
    required this.authorizedPublicKey,
  });

  final PublicKey stakePublicKey;
  final PublicKey sourceStakePublicKey;
  final PublicKey authorizedPublicKey;
}


/// Stake Instruction
/// ------------------------------------------------------------------------------------------------

class StakeInstruction {

  const StakeInstruction();

  /// Decodes a stake instruction and retrieve the instruction type.
  static StakeInstructionType decodeInstructionType(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    final instructionTypeLayout = buffer_layout.u32('instruction');
    final typeIndex = instructionTypeLayout.decode(instruction.data);
    return StakeInstructionType.fromIndex(typeIndex); // Throws an exception.
  }

  /// Decodes a initialize stake instruction and retrieve the instruction params.
  static InitializeStakeParams decodeInitialize(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 2);

    final Map<String, dynamic> data = Instruction.decodeData(
      StakeInstructionLayout.initialize(),
      instruction.data,
    );

    final Map<String, dynamic> authorised = data['authorized'];
    final Map<String, dynamic> lockup = data['lockup'];

    return InitializeStakeParams(
      stakePublicKey: instruction.keys[0].publicKey,
      authorized: Authorized(
        staker: PublicKey(authorised['staker']),
        withdrawer: PublicKey(authorised['withdrawer']),
      ),
      lockup: Lockup(
        unixTimestamp: lockup['unixTimestamp'],
        epoch: lockup['epoch'],
        custodian: PublicKey.fromString(lockup['custodian']),
      ),
    );
  }

  /// Decodes a delegate stake instruction and retrieve the instruction params.
  static DelegateStakeParams decodeDelegate(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 6);
    Instruction.decodeData(StakeInstructionLayout.delegate(), instruction.data);

    return DelegateStakeParams(
      stakePublicKey: instruction.keys[0].publicKey,
      votePublicKey: instruction.keys[1].publicKey,
      authorizedPublicKey: instruction.keys[5].publicKey,
    );
  }

  /// Decodes an authorize stake instruction and retrieve the instruction params.
  static AuthorizeStakeParams decodeAuthorize(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 3);
    final Map<String, dynamic> data = Instruction.decodeData(
      StakeInstructionLayout.authorize(),
      instruction.data,
    );

    return AuthorizeStakeParams(
      stakePublicKey: instruction.keys[0].publicKey,
      authorizedPublicKey: instruction.keys[2].publicKey,
      newAuthorizedPublicKey: PublicKey.fromString(data['newAuthorized']),
      stakeAuthorizationType: StakeAuthorizationType(data['stakeAuthorizationType']),
      custodianPublicKey: instruction.keys.length > 3 ? instruction.keys[3].publicKey : null,
    );
  }

  /// Decodes an authorize-with-seed stake instruction and retrieve the instruction params.
  static AuthorizeWithSeedStakeParams decodeAuthorizeWithSeed(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 2);

    final Map<String, dynamic> data = Instruction.decodeData(
      StakeInstructionLayout.authorizeWithSeed(),
      instruction.data,
    );

    return AuthorizeWithSeedStakeParams(
      stakePublicKey: instruction.keys[0].publicKey,
      authorityBase: instruction.keys[1].publicKey,
      authoritySeed: data['authoritySeed'],
      authorityOwner: PublicKey.fromString(data['authorityOwner']),
      newAuthorizedPublicKey: PublicKey.fromString(data['newAuthorized']),
      stakeAuthorizationType: StakeAuthorizationType(data['stakeAuthorizationType']),
      custodianPublicKey: instruction.keys.length > 3 ? instruction.keys[3].publicKey : null,
    );
  }

  /// Decodes a split stake instruction and retrieve the instruction params.
  static SplitStakeParams decodeSplit(final TransactionInstruction instruction) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 3);
    
    final Map<String, dynamic> data = Instruction.decodeData(
      StakeInstructionLayout.split(),
      instruction.data,
    );

    return SplitStakeParams(
      stakePublicKey: instruction.keys[0].publicKey,
      splitStakePublicKey: instruction.keys[1].publicKey,
      authorizedPublicKey: instruction.keys[2].publicKey,
      lamports: data['lamports'],
    );
  }

  /// Decodes a merge stake instruction and retrieve the instruction params.
  static MergeStakeParams decodeMerge(final TransactionInstruction instruction) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 3);
    
    Instruction.decodeData(StakeInstructionLayout.merge(), instruction.data);

    return MergeStakeParams(
      stakePublicKey: instruction.keys[0].publicKey,
      sourceStakePublicKey: instruction.keys[1].publicKey,
      authorizedPublicKey: instruction.keys[4].publicKey,
    );
  }

  /// Decodes a withdraw stake instruction and retrieve the instruction params.
  static WithdrawStakeParams decodeWithdraw(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 5);
    
    final Map<String, dynamic> data = Instruction.decodeData(
      StakeInstructionLayout.withdraw(),
      instruction.data,
    );

    return WithdrawStakeParams(
      stakePublicKey: instruction.keys[0].publicKey,
      toPublicKey: instruction.keys[1].publicKey,
      authorizedPublicKey: instruction.keys[4].publicKey,
      lamports: data['lamports'], 
      custodianPublicKey: instruction.keys.length > 5 ? instruction.keys[5].publicKey : null,
    );
  }

  /// Decodes a deactivate stake instruction and retrieve the instruction params.
  static DeactivateStakeParams decodeDeactivate(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    _checkKeyLength(instruction.keys, 3);
    
    Instruction.decodeData(StakeInstructionLayout.deactivate(), instruction.data);

    return DeactivateStakeParams(
      stakePublicKey: instruction.keys[0].publicKey,
      authorizedPublicKey: instruction.keys[2].publicKey,
    );
  }
  
  /// Asserts that [programId] is the [StakeProgram.programId].
  /// 
  /// Throws an [AssertionError].
  static _checkProgramId(final PublicKey programId) {
    require(
      programId.equals(StakeProgram.programId), 
      'Invalid instruction; programId is not StakeProgram',
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


/// Stake Instruction Types
/// ------------------------------------------------------------------------------------------------

enum StakeInstructionType {

  // The variants MUST be ordered by their [InstructionType.index].
  initialize,             // 0
  authorize,              // 1
  delegate,               // 2
  split,                  // 3
  withdraw,               // 4
  deactivate,             // 5
  _deprecated,            // 6
  merge,                  // 7
  authorizeWithSeed,      // 8
  ;

  /// Returns the enum variant where [Enum.index] is equal to [index].
  /// 
  /// Throws an [RangeError] if [index] does not satisy the relations `0` ≤ `index` < 
  /// `values.length`.
  /// 
  /// ```
  /// StakeInstructionType.fromIndex(0); // [StakeInstructionType.initialize]
  /// StakeInstructionType.fromIndex(4); // [StakeInstructionType.withdraw]
  /// // StakeInstructionType.fromIndex(StakeInstructionType.values.length); // Throws RangeError.
  /// ```
  factory StakeInstructionType.fromIndex(final int index) => values[index];
}


/// Stake Instruction Layouts
/// ------------------------------------------------------------------------------------------------

class StakeInstructionLayout {

  /// Stake instruction layout.
  const StakeInstructionLayout();

  /// Initialize.
  static InstructionType<buffer_layout.Structure> initialize() {
    return InstructionType(
      index: StakeInstructionType.initialize.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
        layout.authorized(),
        layout.lockup(),
      ])
    );
  }

  static InstructionType<buffer_layout.Structure> authorize() {
    return InstructionType(
      index:  StakeInstructionType.authorize.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
        layout.publicKey('newAuthorized'),
        buffer_layout.u32('stakeAuthorizationType'),
      ])
    );
  }

  static InstructionType<buffer_layout.Structure> delegate() {
    return InstructionType(
      index: StakeInstructionType.delegate.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
      ])
    );
  }

  static InstructionType<buffer_layout.Structure> split() {
    return InstructionType(
      index: StakeInstructionType.split.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
        buffer_layout.ns64('lamports'),
      ])
    );
  }

  static InstructionType<buffer_layout.Structure> withdraw() {
    return InstructionType(
      index: StakeInstructionType.withdraw.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
        buffer_layout.ns64('lamports'),
      ])
    );
  }

  static InstructionType<buffer_layout.Structure> deactivate() {
    return InstructionType(
      index: StakeInstructionType.deactivate.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
      ])
    );
  }

  static InstructionType<buffer_layout.Structure> merge() {
    return InstructionType(
      index: StakeInstructionType.merge.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
      ])
    );
  }

  static InstructionType<buffer_layout.Structure> authorizeWithSeed() {
    return InstructionType(
      index: StakeInstructionType.authorizeWithSeed.index,
      layout: buffer_layout.struct([
        buffer_layout.u32('instruction'),
        layout.publicKey('newAuthorized'),
        buffer_layout.u32('stakeAuthorizationType'),
        layout.rustString('authoritySeed'),
        layout.publicKey('authorityOwner'),
      ])
    );
  }
}


/// Stake Authorization Type
/// ------------------------------------------------------------------------------------------------

class StakeAuthorizationType {
  /// The Stake Authorization index (from solana-stake-program).
  const StakeAuthorizationType(this.index);
  final int index;
}


/// Stake Program
/// ------------------------------------------------------------------------------------------------

class StakeProgram {

  const StakeProgram();

  /// The public key that identifies the Stake Program.
  static final PublicKey programId = PublicKey.fromString(
    'Stake11111111111111111111111111111111111111',
  );

  /// The max space of a Stake account.
  ///
  /// This is generated from the solana-stake-program StakeState struct as `StakeState::size_of()`:
  /// https://docs.rs/solana-stake-program/latest/solana_stake_program/stake_state/enum.StakeState.html
  static const int space = 200;

  /// Generates an Initialize instruction to add to a Stake Create transaction.
  static TransactionInstruction initialize({
    required final PublicKey stakePublicKey,
    required final Authorized authorized,
    required final Lockup? lockup,
  }) {
    final Lockup _lockup = lockup ?? Lockup.inactive;
    final type = StakeInstructionLayout.initialize();
    final data = Instruction.encodeData(type, {
      'authorized': {
        'staker': authorized.staker.toBytes(),
        'withdrawer': authorized.withdrawer.toBytes(),
      },
      'lockup': {
        'unixTimestamp': _lockup.unixTimestamp,
        'epoch': _lockup.epoch,
        'custodian': _lockup.custodian.toBuffer(),
      },
    });
    
    final List<AccountMeta> keys = [
      AccountMeta(stakePublicKey, isSigner: false, isWritable: true),
      AccountMeta(sysvarRentPublicKey, isSigner: false, isWritable: false),
    ];

    return TransactionInstruction(
      keys: keys,
      programId: StakeProgram.programId,
      data: data,
    );
  }

  /// Generates a Transaction that creates a new Stake account at an address generated with `from`, 
  /// a seed, and the Stake programId.
  static Transaction createAccountWithSeed({
    required final PublicKey fromPublicKey,
    required final PublicKey stakePublicKey,
    required final PublicKey basePublicKey,
    required final String seed,
    required final Authorized authorized,
    final Lockup? lockup,
    required final u64 lamports,
  }) {
    return Transaction()
      ..add(
        SystemProgram.createAccountWithSeed(
          fromPublicKey: fromPublicKey,
          newAccountPublicKey: stakePublicKey,
          basePublicKey: basePublicKey,
          seed: seed,
          lamports: lamports,
          space: StakeProgram.space,
          programId: StakeProgram.programId,
        ),
      )
      ..add(
        StakeProgram.initialize(
          stakePublicKey: stakePublicKey,
          authorized: authorized,
          lockup: lockup,
        )
      );
  }

  /// Generates a Transaction that creates a new Stake account.
  static Transaction createAccount({
    required final PublicKey fromPublicKey,
    required final PublicKey stakePublicKey,
    required final Authorized authorized,
    final Lockup? lockup,
    required final u64 lamports,
  }) {
    return Transaction()
      ..add(
        SystemProgram.createAccount(
          fromPublicKey: fromPublicKey,
          newAccountPublicKey: stakePublicKey,
          lamports: lamports,
          space: StakeProgram.space,
          programId: StakeProgram.programId,
        ),
      )
      ..add(
        StakeProgram.initialize(
          stakePublicKey: stakePublicKey, 
          authorized: authorized, 
          lockup: lockup
        ),
      );
  }

  /// Generates a Transaction that delegates Stake tokens to a validator Vote PublicKey. This 
  /// transaction can also be used to redelegate Stake to a new validator Vote PublicKey.
  static Transaction delegate({
    required final PublicKey stakePublicKey,
    required final PublicKey authorizedPublicKey,
    required final PublicKey votePublicKey,
  }) {
    final type = StakeInstructionLayout.delegate();
    final data = Instruction.encodeData(type);
    
    final List<AccountMeta> keys = [
      AccountMeta(stakePublicKey, isSigner: false, isWritable: true),
      AccountMeta(votePublicKey, isSigner: false, isWritable: false),
      AccountMeta(sysvarClockPublicKey, isSigner: false, isWritable: false),
      AccountMeta(sysvarStakeHistoryPublicKey, isSigner: false, isWritable: false),
      AccountMeta(stakeConfigId, isSigner: false, isWritable: false),
      AccountMeta(authorizedPublicKey, isSigner: true, isWritable: false),
    ];

    return Transaction()
      ..add(
        TransactionInstruction(
          keys: keys, 
          programId: StakeProgram.programId,
          data: data,
        ),
      );
  }

  /// Generates a Transaction that authorizes a new PublicKey as Staker or Withdrawer on the Stake 
  /// account.
  static Transaction authorize({
    required final PublicKey stakePublicKey,
    required final PublicKey authorizedPublicKey,
    required final PublicKey newAuthorizedPublicKey,
    required final StakeAuthorizationType stakeAuthorizationType,
    final PublicKey? custodianPublicKey,
  }) {
    final type = StakeInstructionLayout.authorize();
    final data = Instruction.encodeData(type, {
      'newAuthorized': newAuthorizedPublicKey.toBytes(),
      'stakeAuthorizationType': stakeAuthorizationType.index,
    });
    
    final List<AccountMeta> keys = [
      AccountMeta(stakePublicKey, isSigner: false, isWritable: true),
      // TODO: check if `sysvarClockPublicKey isWritable` should be `false`?
      AccountMeta(sysvarClockPublicKey, isSigner: false, isWritable: true),
      AccountMeta(authorizedPublicKey, isSigner: true, isWritable: false),
    ];

    if (custodianPublicKey != null) {
      keys.add(AccountMeta(custodianPublicKey, isSigner: false, isWritable: false));
    }

    return Transaction()
      ..add(
        TransactionInstruction(
          keys: keys, 
          programId: StakeProgram.programId,
          data: data,
        ),
      );
  }

  /// Generates a Transaction that authorizes a new PublicKey as Staker or Withdrawer on the Stake 
  /// account.
  static Transaction authorizeWithSeed({
    required final PublicKey stakePublicKey,
    required final PublicKey authorityBase,
    required final String authoritySeed,
    required final PublicKey authorityOwner,
    required final PublicKey newAuthorizedPublicKey,
    required final StakeAuthorizationType stakeAuthorizationType,
    final PublicKey? custodianPublicKey,
  }) {
    final type = StakeInstructionLayout.authorizeWithSeed();
    final data = Instruction.encodeData(type, {
      'newAuthorized': newAuthorizedPublicKey.toBytes(),
      'stakeAuthorizationType': stakeAuthorizationType.index,
      'authoritySeed': authoritySeed,
      'authorityOwner': authorityOwner.toBytes(),
    });

    final List<AccountMeta> keys = [
      AccountMeta(stakePublicKey, isSigner: false, isWritable: true),
      AccountMeta(authorityBase, isSigner: true, isWritable: false),
      AccountMeta(sysvarClockPublicKey, isSigner: false, isWritable: false),
    ];

    if (custodianPublicKey != null) {
      keys.add(AccountMeta(custodianPublicKey, isSigner: false, isWritable: false));
    }

    return Transaction()
      ..add(
        TransactionInstruction(
          keys: keys, 
          programId: StakeProgram.programId,
          data: data,
        ),
      );
  }

  /// Split instruction.
  static TransactionInstruction _splitInstruction({
    required final PublicKey stakePublicKey,
    required final PublicKey authorizedPublicKey,
    required final PublicKey splitStakePublicKey,
    required final u64 lamports,
  }) {
    final type = StakeInstructionLayout.split();
    final data = Instruction.encodeData(type, { 'lamports': lamports });
    return TransactionInstruction(
      keys: [
        AccountMeta(stakePublicKey, isSigner: false, isWritable: true),
        AccountMeta(splitStakePublicKey, isSigner: false, isWritable: true),
        AccountMeta(authorizedPublicKey, isSigner: true, isWritable: false),
      ],
      programId: StakeProgram.programId,
      data: data,
    );
  }

  /// Generates a Transaction that splits Stake tokens into another stake account.
  static Transaction split({
    required final PublicKey stakePublicKey,
    required final PublicKey authorizedPublicKey,
    required final PublicKey splitStakePublicKey,
    required final u64 lamports,
  }) {
    return Transaction()
      ..add(
        SystemProgram.createAccount(
          fromPublicKey: authorizedPublicKey,
          newAccountPublicKey: splitStakePublicKey,
          lamports: 0,
          space: StakeProgram.space,
          programId: StakeProgram.programId,
        ),
      )
      ..add(
        StakeProgram._splitInstruction(
          stakePublicKey: stakePublicKey,
          authorizedPublicKey: authorizedPublicKey,
          splitStakePublicKey: splitStakePublicKey,
          lamports: lamports,
        ));
  }

  /// Generates a Transaction that splits Stake tokens into another account derived from a base 
  /// public key and seed.
  static Transaction splitWithSeed({
    required final PublicKey stakePublicKey,
    required final PublicKey authorizedPublicKey,
    required final PublicKey splitStakePublicKey,
    required final PublicKey basePublicKey,
    required final String seed,
    required final u64 lamports,
  }) {
    return Transaction()
      ..add(
        SystemProgram.allocateWithSeed(
          accountPublicKey: splitStakePublicKey,
          basePublicKey: basePublicKey,
          seed: seed,
          space: StakeProgram.space,
          programId: StakeProgram.programId,
        ),
      )
      ..add(
        StakeProgram._splitInstruction(
          stakePublicKey: stakePublicKey,
          authorizedPublicKey: authorizedPublicKey,
          splitStakePublicKey: splitStakePublicKey,
          lamports: lamports,
        ));
  }

  /// Generates a Transaction that merges Stake accounts.
  static Transaction merge({
    required final PublicKey stakePublicKey,
    required final PublicKey sourceStakePublicKey,
    required final PublicKey authorizedPublicKey,
  }) {
    final type = StakeInstructionLayout.merge();
    final data = Instruction.encodeData(type);

    final List<AccountMeta> keys = [
      AccountMeta(stakePublicKey, isSigner: false, isWritable: true),
      AccountMeta(sourceStakePublicKey, isSigner: false, isWritable: true),
      AccountMeta(sysvarClockPublicKey, isSigner: false, isWritable: false),
      AccountMeta(sysvarStakeHistoryPublicKey, isSigner: false, isWritable: false),
      AccountMeta(authorizedPublicKey, isSigner: true, isWritable: false),
    ];

    return Transaction()
      ..add(
        TransactionInstruction(
          keys: keys,
          programId: StakeProgram.programId,
          data: data,
        ),
      );
  }

  /// Generates a Transaction that withdraws deactivated Stake tokens.
  static Transaction withdraw({
    required final PublicKey stakePublicKey,
    required final PublicKey authorizedPublicKey,
    required final PublicKey toPublicKey,
    required final u64 lamports,
    required final PublicKey? custodianPublicKey,
  }) {
    final type = StakeInstructionLayout.withdraw();
    final data = Instruction.encodeData(type, { 'lamports': lamports });

    final List<AccountMeta> keys = [
      AccountMeta(stakePublicKey, isSigner: false, isWritable: true),
      AccountMeta(toPublicKey, isSigner: false, isWritable: true),
      AccountMeta(sysvarClockPublicKey, isSigner: false, isWritable: false),
      AccountMeta(authorizedPublicKey, isSigner: true, isWritable: false),
    ];

    if (custodianPublicKey != null) {
      keys.add(AccountMeta(custodianPublicKey, isSigner: false, isWritable: false));
    }
    
    return Transaction()
      ..add(
        TransactionInstruction(
          keys: keys,
          programId: StakeProgram.programId,
          data: data,
        ),
      );
  }

  /// Generates a Transaction that deactivates Stake tokens.
  static Transaction deactivate({
    required final PublicKey stakePublicKey,
    required final PublicKey authorizedPublicKey,
  }) {

    final type = StakeInstructionLayout.deactivate();
    final data = Instruction.encodeData(type);

    final List<AccountMeta> keys = [
      AccountMeta(stakePublicKey, isSigner: false, isWritable: true),
      AccountMeta(sysvarClockPublicKey, isSigner: false, isWritable: false),
      AccountMeta(authorizedPublicKey, isSigner: true, isWritable: false),
    ];
    
    return Transaction()
      ..add(
        TransactionInstruction(
          keys: keys,
          programId: StakeProgram.programId,
          data: data,
        ),
      );
  }
}