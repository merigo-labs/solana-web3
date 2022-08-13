/// Imports
/// ------------------------------------------------------------------------------------------------

library solana_web3;


/// Exports
/// ------------------------------------------------------------------------------------------------

export 'package:solana_web3/src/blockhash.dart';
export 'package:solana_web3/src/bpf_loader.dart';
export 'package:solana_web3/src/buffer.dart';
export 'package:solana_web3/src/config/cluster.dart';
export 'package:solana_web3/src/connection.dart';
export 'package:solana_web3/src/fee_calculator.dart';
export 'package:solana_web3/src/instruction.dart';
export 'package:solana_web3/src/keypair.dart';
export 'package:solana_web3/src/loader.dart';
export 'package:solana_web3/src/message/message.dart';
export 'package:solana_web3/src/message/message_instruction.dart';
export 'package:solana_web3/src/nonce_account.dart';
export 'package:solana_web3/src/programs/compute_budget.dart';
export 'package:solana_web3/src/programs/ed25519.dart';
export 'package:solana_web3/src/programs/stake.dart';
export 'package:solana_web3/src/programs/system.dart';
export 'package:solana_web3/src/public_key.dart';
export 'package:solana_web3/src/sysvar.dart';
export 'package:solana_web3/src/transaction/constants.dart';
export 'package:solana_web3/src/transaction/transaction.dart';
export 'package:solana_web3/src/validator_info.dart';


/// Solana Library
/// ------------------------------------------------------------------------------------------------

/// The number of lamport per sol (1 billion).
const int LAMPORTS_PER_SOL = 1000000000; // ignore: constant_identifier_names

/// Converts [sol] to lamports.
BigInt solToLamports(final int sol) => BigInt.from(sol) * BigInt.from(LAMPORTS_PER_SOL);