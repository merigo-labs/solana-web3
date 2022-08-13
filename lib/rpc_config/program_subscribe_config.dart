/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/account_encoding.dart';
import 'package:solana_web3/config/commitment.dart';
import 'package:solana_web3/models/program_filter.dart';
import 'package:solana_web3/rpc/rpc_subscribe_config.dart';
import 'package:solana_web3/utils/convert.dart' show list;


/// Program Subscribe Config
/// ------------------------------------------------------------------------------------------------

class ProgramSubscribeConfig extends RpcSubscribeConfig {

  /// Defines the configurations for JSON-RPC `ProgramSubscribe` requests.
  ProgramSubscribeConfig({
    super.timeout,
    this.commitment = Commitment.finalized,
    this.encoding = AccountEncoding.base64,
    final List<ProgramFilter>? filters,
  }): filters = filters == null || filters.isEmpty ? null : filters,
      assert(encoding.isAccount);

  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment commitment;

  /// The Program data's encoding (default: [AccountEncoding.base64]).
  final AccountEncoding encoding;

  /// The filters applied to the results. An account must meet all filter criteria to be included in 
  /// results.
  final List<ProgramFilter>? filters;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment.name,
    'encoding': encoding.name,
    'filters': list.tryEncode(filters),
  };
}