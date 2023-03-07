/// Imports
/// ------------------------------------------------------------------------------------------------

library solana_web3;

import 'package:solana_common/extensions/num.dart';


/// Exports
/// ------------------------------------------------------------------------------------------------

// solana_common
export 'package:solana_common/borsh/borsh.dart';
export 'package:solana_common/config/cluster.dart';
export 'package:solana_common/exceptions/json_rpc_exception.dart';
export 'package:solana_common/exceptions/solana_exception.dart';
export 'package:solana_common/exceptions/subscription_exception.dart';
export 'package:solana_common/extensions/num.dart';
export 'package:solana_common/models/serializable.dart';
export 'package:solana_common/protocol/json_rpc_context_response.dart';
export 'package:solana_common/protocol/json_rpc_context_result.dart';
export 'package:solana_common/protocol/json_rpc_context.dart';
export 'package:solana_common/protocol/json_rpc_http_headers.dart';
export 'package:solana_common/protocol/json_rpc_notification_response.dart';
export 'package:solana_common/protocol/json_rpc_notification.dart';
export 'package:solana_common/protocol/json_rpc_request_config.dart';
export 'package:solana_common/protocol/json_rpc_request.dart';
export 'package:solana_common/protocol/json_rpc_response.dart';
export 'package:solana_common/protocol/json_rpc_subscribe_response.dart';
export 'package:solana_common/protocol/json_rpc_unsubscribe_response.dart';
export 'package:solana_common/utils/buffer.dart';
export 'package:solana_common/utils/convert.dart';
export 'package:solana_common/utils/rust_enum.dart';

// src/message/
export 'src/message/message_instruction.dart';
export 'src/message/message.dart';

// src/models/
export 'src/models/address_table_lookup.dart';
export 'src/models/data_size.dart';
export 'src/models/data_slice.dart';
export 'src/mixins/data_serializable_mixin.dart';
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
export 'src/timing.dart';
export 'src/validator_info.dart';


/// Solana Library
/// ------------------------------------------------------------------------------------------------

/// The number of lamport per sol (1 billion).
const int lamportsPerSol = 1000000000;

/// Converts [sol] to lamports.
BigInt _intToLamports(final int sol) {
  return sol.toBigInt() * lamportsPerSol.toBigInt();
}

/// Converts [sol] to lamports.
BigInt _numToLamports(final num sol) {
  const decimalPlaces = 9;
  final String value = sol.toStringAsFixed(decimalPlaces);
  final int decimalPosition = value.length - decimalPlaces;
  return BigInt.parse(value.substring(0, decimalPosition-1) + value.substring(decimalPosition));
}

/// Converts [sol] to lamports.
BigInt solToLamports(final num sol) {
  assert(sol is int || sol is double);
  return sol is int ? _intToLamports(sol) : _numToLamports(sol);
}

/// Converts [lamports] to sol.
double lamportsToSol(final BigInt lamports) {
  assert(lamports <= (BigInt.from(double.maxFinite) * lamportsPerSol.toBigInt()));
  return lamports / lamportsPerSol.toBigInt();
}