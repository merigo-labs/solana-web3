/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/public_key.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';


/// Get Vote Accounts Config
/// ------------------------------------------------------------------------------------------------

class GetVoteAccountsConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `getVoteAccounts` methods.
  const GetVoteAccountsConfig({
    super.id,
    super.headers,
    super.timeout,
    this.commitment,
    this.votePubkey,
    this.keepUnstakedDelinquents,
  });

  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment? commitment;

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