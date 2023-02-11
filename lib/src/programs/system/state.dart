/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/utils/types.dart';
import '../../public_key.dart';


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
  final bu64 lamports;
  
  /// The amount of space in bytes to allocate to the created account.
  final bu64 space;

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
  final bu64 lamports;
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
  final bu64 lamports;
  
  /// The amount of space in bytes to allocate to the created account.
  final bu64 space;

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
    required this.authorizedPublicKey,
    required this.lamports,
  });
  
  /// The account that will transfer lamports to the created nonce account.
  final PublicKey fromPublicKey;

  /// The public key of the created nonce account.
  final PublicKey noncePublicKey;
  
  /// Thje public key to set as authority of the created nonce account.
  final PublicKey authorizedPublicKey;

  /// The amount of lamports to transfer to the created nonce account.
  final bu64 lamports;
}


/// Create Nonce Account With Seed Params
/// ------------------------------------------------------------------------------------------------

class CreateNonceAccountWithSeedParams {

  /// Create nonce account with seed system transaction params.
  const CreateNonceAccountWithSeedParams({
    required this.fromPublicKey,
    required this.noncePublicKey,
    required this.authorizedPublicKey,
    required this.lamports,
    required this.basePublicKey,
    required this.seed,
  });

  /// The account that will transfer lamports to the created nonce account.
  final PublicKey fromPublicKey;
  
  /// The public key of the created nonce account.
  final PublicKey noncePublicKey;
  
  /// The public key to set as the authority of the created nonce account.
  final PublicKey authorizedPublicKey;
  
  /// The amount of lamports to transfer to the created nonce account.
  final bu64 lamports;

  /// The base public key used to derive the address of the nonce account.
  final PublicKey basePublicKey;

  /// The seed used to derive the address of the nonce account.
  final String seed;
}


/// Initialize Nonce Params
/// ------------------------------------------------------------------------------------------------

class InitializeNonceParams {

  /// Initialize nonce account system instruction params.
  const InitializeNonceParams({
    required this.noncePublicKey,
    required this.authorizedPublicKey,
  });

  /// The nonce account to be initialized.
  final PublicKey noncePublicKey;

  /// The public key to set as the authority of the initialized nonce account.
  final PublicKey authorizedPublicKey;
}


/// Advance Nonce Params
/// ------------------------------------------------------------------------------------------------

class AdvanceNonceParams {

  /// Advance nonce account system instruction params.
  const AdvanceNonceParams({
    required this.noncePublicKey,
    required this.authorizedPublicKey,
  });
  
  /// The nonce account.
  final PublicKey noncePublicKey;

  /// The public key of the nonce authority.
  final PublicKey authorizedPublicKey;
}


/// Withdraw Nonce Params
/// ------------------------------------------------------------------------------------------------

class WithdrawNonceParams {

  /// Withdraw nonce account system transaction params.
  const WithdrawNonceParams({
    required this.noncePublicKey,
    required this.authorizedPublicKey,
    required this.toPublicKey,
    required this.lamports,
  });

  /// The nonce account.
  final PublicKey noncePublicKey;

  /// The public key of the nonce authority.
  final PublicKey authorizedPublicKey;

  /// The public key of the account which will receive the withdrawn nonce account balance.
  final PublicKey toPublicKey;

  /// The mount of lamports to withdraw from the nonce account.
  final bu64 lamports;
}


/// Authorize Nonce Params
/// ------------------------------------------------------------------------------------------------

class AuthorizeNonceParams {

  /// Authorise nonce account system transaction params.
  const AuthorizeNonceParams({
    required this.noncePublicKey,
    required this.authorizedPublicKey,
    required this.newAuthorizedPublicKey,
  });

  /// The nonce account.
  final PublicKey noncePublicKey;

  /// The public key of the current nonce authority.
  final PublicKey authorizedPublicKey;

  /// The public key to set as the new nonce authority.
  final PublicKey newAuthorizedPublicKey;
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
  final bu64 space;
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
  final bu64 space;

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
  final bu64 lamports;
  
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
  final bu64 lamports;
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
  final bu64 lamports;

  /// The seed used to derive the funding account address.
  final String seed;

  /// The program id used to derive the funding account address.
  final PublicKey programId;
}