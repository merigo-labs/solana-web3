/// Imports
/// ------------------------------------------------------------------------------------------------

import 'commitment_and_min_context_slot_config.dart';
import '../types/accounts_filter.dart';
import '../types/transaction_encoding.dart';


/// Simulate Transaction Config
/// ------------------------------------------------------------------------------------------------
 
class SimulateTransactionConfig extends CommitmentAndMinContextSlotConfig {

  /// JSON-RPC configurations for `SimulateTransaction` methods.
  const SimulateTransactionConfig({
    super.id,
    super.headers,
    super.timeout,
    this.sigVerify = false,
    super.commitment,
    this.encoding = TransactionEncoding.base64,
    this.replaceRecentBlockhash,
    this.accounts,
    super.minContextSlot,
  }): assert(encoding == TransactionEncoding.base64);

  /// If true, the transaction signatures will be verified (default: `false`, conflicts with 
  /// [replaceRecentBlockhash]).
  final bool sigVerify;

  /// The transaction data encoding (must be 'base64').
  final TransactionEncoding encoding;

  /// If true, the transaction recent blockhash will be replaced with the most recent blockhash. 
  /// (default: `false`, conflicts with [sigVerify]).
  final bool? replaceRecentBlockhash;

  /// The maximum number of times for the RPC node to retry sending the transaction to the leader. 
  /// If this parameter not provided, the RPC node will retry the transaction until it is finalised 
  /// or until the blockhash expires.
  final AccountsFilter? accounts;

  @override
  Map<String, dynamic> object() => {
    'sigVerify': sigVerify,
    'commitment': commitment?.name,
    'encoding': encoding.name,
    'replaceRecentBlockhash': replaceRecentBlockhash,
    'accounts': accounts?.toJson(),
    'minContextSlot': minContextSlot,
  };
}