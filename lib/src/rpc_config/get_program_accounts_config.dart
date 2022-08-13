/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/config/account_encoding.dart';
import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/models/data_slice.dart';
import 'package:solana_web3/src/models/program_filter.dart';
import 'package:solana_web3/src/models/serialisable.dart';
import 'package:solana_web3/src/rpc/rpc_request_config.dart';
import 'package:solana_web3/src/utils/convert.dart' as convert show list;
import 'package:solana_web3/src/utils/types.dart' show u64;


/// Get Program Accounts Config
/// ------------------------------------------------------------------------------------------------

class GetProgramAccountsConfig extends RpcRequestConfig {

  /// JSON-RPC configurations for `getAccountInfo` methods.
  GetProgramAccountsConfig({
    super.id,
    super.headers,
    super.timeout,
    this.commitment,
    this.encoding = AccountEncoding.base64,
    this.dataSlice,
    this.filters,
    this.minContextSlot,
  }): assert(encoding.isAccount, 'Invalid encoding.'),
      assert(dataSlice == null || encoding.isBinary, 'Must use binary encoding for [DataSlice].'),
      assert(minContextSlot == null || minContextSlot >= 0);

  /// The type of block to query for the request (default: [Commitment.finalized]).
  final Commitment? commitment;

  /// The account data's encoding (default: [AccountEncoding.base64]). 
  /// 
  /// If [dataSlice] is provided, encoding is limited to `base58`, `base64` or `base64+zstd`.
  final AccountEncoding encoding;

  /// Limit the returned account data to the range [DataSlice.offset] : [DataSlice.offset] + 
  /// [DataSlice.length].
  final DataSlice? dataSlice;

  /// The filters applied to the results. An account must meet all filter criteria to be included in 
  /// results.
  final List<ProgramFilter>? filters;

  /// The minimum slot that the request can be evaluated at.
  final u64? minContextSlot;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'encoding': encoding.name,
    'dataSlice': dataSlice?.toJson(),
    'filters': convert.list.tryEncode(filters),
    'minContextSlot': minContextSlot,
  };
}