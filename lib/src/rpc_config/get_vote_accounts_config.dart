/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/public_key.dart';
import 'package:solana_web3/src/rpc_config/commitment_config.dart';


/// Get Vote Accounts Config
/// ------------------------------------------------------------------------------------------------

class GetVoteAccountsConfig extends CommitmentConfig {

  /// JSON-RPC configurations for `getVoteAccounts` methods.
  const GetVoteAccountsConfig({
    super.id,
    super.headers,
    super.timeout,
    super.commitment,
    this.votePubkey,
    this.keepUnstakedDelinquents,
  });

  /// If set, only return results for this validator vote address.
  final PublicKey? votePubkey;

  /// If true, do not filter out delinquent validators with no stake.
  final bool? keepUnstakedDelinquents;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'votePubkey': votePubkey?.toBase58(),
    'keepUnstakedDelinquents': keepUnstakedDelinquents,
  };
}