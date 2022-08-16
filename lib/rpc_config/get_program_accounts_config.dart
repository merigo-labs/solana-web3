/// Imports
/// ------------------------------------------------------------------------------------------------

import 'commitment_config.dart';
import '../src/models/data_slice.dart';
import '../src/models/program_filter.dart';
import '../src/utils/convert.dart' as convert show list;
import '../src/utils/types.dart' show u64;
import '../types/account_encoding.dart';


/// Get Program Accounts Config
/// ------------------------------------------------------------------------------------------------

class GetProgramAccountsConfig extends CommitmentConfig {

  /// JSON-RPC configurations for `getAccountInfo` methods.
  GetProgramAccountsConfig({
    super.id,
    super.headers,
    super.timeout,
    super.commitment,
    this.encoding = AccountEncoding.base64,
    this.dataSlice,
    this.filters,
    this.minContextSlot,
  }): assert(encoding.isAccount, 'Invalid encoding.'),
      assert(dataSlice == null || encoding.isBinary, 'Must use binary encoding for [DataSlice].'),
      assert(minContextSlot == null || minContextSlot >= 0);

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