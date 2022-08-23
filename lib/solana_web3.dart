/// Imports
/// ------------------------------------------------------------------------------------------------

library solana_web3;


/// Exports
/// ------------------------------------------------------------------------------------------------

export 'src/blockhash.dart';
export 'src/bpf_loader.dart';
export 'src/buffer.dart';
export 'src/config/cluster.dart';
export 'src/connection.dart';
export 'src/epoch_schedule.dart';
export 'src/fee_calculator.dart';
export 'src/instruction.dart';
export 'src/keypair.dart';
export 'src/loader.dart';
export 'src/message/message.dart';
export 'src/message/message_instruction.dart';
export 'src/nonce_account.dart';
export 'src/public_key.dart';
export 'src/sysvar.dart';
export 'src/transaction/constants.dart';
export 'src/transaction/transaction.dart';
export 'src/validator_info.dart';
export 'src/web_socket_subscription_manager.dart';


/// Solana Library
/// ------------------------------------------------------------------------------------------------

/// The number of lamport per sol (1 billion).
const int lamportsPerSol = 1000000000;

/// Converts [sol] to lamports.
BigInt solToLamports(final int sol) => BigInt.from(sol) * BigInt.from(lamportsPerSol);