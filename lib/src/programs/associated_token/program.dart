/// Imports
/// ------------------------------------------------------------------------------------------------

import '../../../programs/program.dart';
import '../../../src/public_key.dart';
import '../../../src/transaction/transaction.dart';
import '../../../programs/system.dart';
import '../token/program.dart';
import 'instruction.dart';


/// Associated Token Program
/// ------------------------------------------------------------------------------------------------

class AssociatedTokenProgram extends Program {

  AssociatedTokenProgram._()
    : super(PublicKey.fromBase58('ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL'));

  /// Internal singleton instance.
  static final AssociatedTokenProgram _instance = AssociatedTokenProgram._();

  /// The program id.
  static PublicKey get programId => _instance.publicKey;

  /// Build `create` associated token instruction.
  ///
  /// ### Keys:
  /// - `[w,s]` [fundingAccount] - Funding account (must be a system account).
  /// - `[w]` [associatedTokenAccount] - Associated token account address to be created.
  /// - `[]` [associatedTokenAccountOwner] - Wallet address for the new associated token account.
  /// - `[]` [tokenMint] - The token mint for the new associated token account.
  static TransactionInstruction _createInstruction(
    final AssociatedTokenInstruction instruction, {
    required final PublicKey fundingAccount,
    required final PublicKey associatedTokenAccount,
    required final PublicKey associatedTokenAccountOwner,
    required final PublicKey tokenMint,
  }) {
    // 0. `[writeable,signer]` Funding account (must be a system account)
    // 1. `[writeable]` Associated token account address to be created
    // 2. `[]` Wallet address for the new associated token account
    // 3. `[]` The token mint for the new associated token account
    // 4. `[]` System program
    // 5. `[]` SPL Token program
    final List<AccountMeta> keys = [ 
      AccountMeta.signerAndWritable(fundingAccount),
      AccountMeta.writable(associatedTokenAccount),
      AccountMeta(associatedTokenAccountOwner),
      AccountMeta(tokenMint),
      AccountMeta(SystemProgram.programId),
      AccountMeta(TokenProgram.programId),
    ];

    return _instance.createTransactionIntruction(
      instruction, 
      keys: keys, 
    );
  }

  /// Creates an associated token account for the given wallet address and token mint.
  /// 
  /// Returns an error if the account exists.
  ///
  /// ### Keys:
  /// - `[w,s]` [fundingAccount] - Funding account (must be a system account).
  /// - `[w]` [associatedTokenAccount] - Associated token account address to be created.
  /// - `[]` [associatedTokenAccountOwner] - Wallet address for the new associated token account.
  /// - `[]` [tokenMint] - The token mint for the new associated token account.
  static TransactionInstruction create({
    required final PublicKey fundingAccount,
    required final PublicKey associatedTokenAccount,
    required final PublicKey associatedTokenAccountOwner,
    required final PublicKey tokenMint,
  }) {
    return _createInstruction(
      AssociatedTokenInstruction.create, 
      fundingAccount: fundingAccount, 
      associatedTokenAccount: associatedTokenAccount, 
      associatedTokenAccountOwner: associatedTokenAccountOwner, 
      tokenMint: tokenMint,
    );
  }

  /// Creates an associated token account for the given wallet address and token mint, if it doesn't 
  /// already exist.  Returns an error if the account exists, but with a different owner.
  ///
  ///   0. `[writeable,signer]` Funding account (must be a system account)
  ///   1. `[writeable]` Associated token account address to be created
  ///   2. `[]` Wallet address for the new associated token account
  ///   3. `[]` The token mint for the new associated token account
  ///   4. `[]` System program
  ///   5. `[]` SPL Token program
  static TransactionInstruction createIdempotent({
    required final PublicKey fundingAccount,
    required final PublicKey associatedTokenAccount,
    required final PublicKey associatedTokenAccountOwner,
    required final PublicKey tokenMint,
  }) {
    return _createInstruction(
      AssociatedTokenInstruction.createIdempotent, 
      fundingAccount: fundingAccount, 
      associatedTokenAccount: associatedTokenAccount, 
      associatedTokenAccountOwner: associatedTokenAccountOwner, 
      tokenMint: tokenMint,
    );
  }

  /// Transfers from and closes a nested associated token account: an associated token account owned 
  /// by an associated token account.
  ///
  /// The tokens are moved from the nested associated token account to the wallet's associated token 
  /// account, and the nested account lamports are moved to the wallet.
  ///
  /// Note: Nested token accounts are an anti-pattern, and almost always created unintentionally, so 
  /// this instruction should only be used to recover from errors.
  ///
  /// ### Keys:
  /// - `[w]` [nestedAssociatedTokenAccount] - Nested associated token account, must be owned by 
  ///   `[associatedTokenAccount]`.
  /// - `[]` [nestedAssociatedTokenMint] - Token mint for the nested associated token account.
  /// - `[w]` [nestedAssociatedTokenAccountOwner] - Wallet's associated token account.
  /// - `[]` [associatedTokenAccount] - Owner associated token account address, must be owned by 
  ///   `[associatedTokenAccountOwner]`.
  /// - `[]` [associatedTokenMint] - Token mint for the owner associated token account.
  /// - `[w,s]` [associatedTokenAccountOwner] - Wallet address for the owner associated token account.
  static TransactionInstruction recoverNested({
    required final PublicKey nestedAssociatedTokenAccount,
    required final PublicKey nestedAssociatedTokenMint,
    required final PublicKey nestedAssociatedTokenAccountOwner,
    required final PublicKey associatedTokenAccount,
    required final PublicKey associatedTokenMint,
    required final PublicKey associatedTokenAccountOwner,
  }) {
    // 0. `[w]` Nested associated token account, must be owned by `3`
    // 1. `[]` Token mint for the nested associated token account
    // 2. `[w]` Wallet's associated token account
    // 3. `[]` Owner associated token account address, must be owned by `5`
    // 4. `[]` Token mint for the owner associated token account
    // 5. `[w,s]` Wallet address for the owner associated token account
    // 6. `[]` SPL Token program
    final List<AccountMeta> keys = [ 
      AccountMeta.writable(nestedAssociatedTokenAccount),
      AccountMeta(nestedAssociatedTokenMint),
      AccountMeta.writable(nestedAssociatedTokenAccountOwner),
      AccountMeta(associatedTokenAccount),
      AccountMeta(associatedTokenMint),
      AccountMeta.signerAndWritable(associatedTokenAccountOwner),
      AccountMeta(TokenProgram.programId),
    ];

    return _instance.createTransactionIntruction(
      AssociatedTokenInstruction.recoverNested, 
      keys: keys, 
    );
  }
}