/// Imports
/// ------------------------------------------------------------------------------------------------

library solana_web3;


/// Exports
/// ------------------------------------------------------------------------------------------------

// solana_common
export 'package:solana_common/borsh/index.dart';
export 'package:solana_common/config/cluster.dart';
export 'package:solana_common/models/serializable.dart';
export 'package:solana_common/protocol/json_rpc_response.dart';
export 'package:solana_common/utils/buffer.dart';
export 'package:solana_common/utils/convert.dart';

// src/message/
export 'src/message/message_instruction.dart';
export 'src/message/message.dart';

// src/models/
export 'src/models/address_table_lookup.dart';
export 'src/models/data_size.dart';
export 'src/models/data_slice.dart';
export 'src/models/data.dart';
export 'src/models/inner_instruction.dart';
export 'src/models/loaded_address.dart';
export 'src/models/logs_filter.dart';
export 'src/models/mem_cmp.dart';
export 'src/models/meta.dart';
export 'src/models/program_address.dart';
export 'src/models/program_filters.dart';
export 'src/models/reward.dart';
export 'src/models/slot_range.dart';
export 'src/models/token_balance.dart';
export 'src/models/transaction_data.dart';
export 'src/models/ui_token_amount.dart';

// src/transaction/
export 'src/transaction/constants.dart';
export 'src/transaction/transaction.dart';


// src/
export 'src/blockhash.dart';
export 'src/bpf_loader.dart';
export 'src/connection.dart';
export 'src/fee_calculator.dart';
export 'src/instruction.dart';
export 'src/keypair.dart';
export 'src/loader.dart';
export 'src/nonce_account.dart';
export 'src/public_key.dart';
export 'src/sysvar.dart';
export 'src/validator_info.dart';


/// Solana Library
/// ------------------------------------------------------------------------------------------------

/// The number of lamport per sol (1 billion).
const int lamportsPerSol = 1000000000;

/// Converts [sol] to lamports.
BigInt solToLamports(final int sol) => BigInt.from(sol) * BigInt.from(lamportsPerSol);