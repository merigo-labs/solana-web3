/// Imports
/// ------------------------------------------------------------------------------------------------

library solana;


/// Exports
/// ------------------------------------------------------------------------------------------------

export 'package:solana_web3/config/cluster.dart';
export 'package:solana_web3/connection.dart';
export 'package:solana_web3/instruction.dart';
export 'package:solana_web3/system_program.dart';
export 'package:solana_web3/transaction.dart';


/// Solana Library
/// ------------------------------------------------------------------------------------------------

// ignore: constant_identifier_names
const int LAMPORTS_PER_SOL = 1000000000;

BigInt solToLamports(final int sol) => BigInt.from(sol) * BigInt.from(LAMPORTS_PER_SOL);