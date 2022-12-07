/// Imports
/// ------------------------------------------------------------------------------------------------

import 'commitment_subscribe_config.dart';
import '../types/account_encoding.dart';
import '../src/models/program_filters.dart';


/// Program Subscribe Config
/// ------------------------------------------------------------------------------------------------

class ProgramSubscribeConfig extends CommitmentSubscribeConfig {

  /// Defines the configurations for JSON-RPC `ProgramSubscribe` requests.
  ProgramSubscribeConfig({
    super.timeout,
    super.commitment,
    this.encoding = AccountEncoding.base64,
    this.filters,
  }): assert(encoding.isAccount);

  /// The Program data's encoding (default: [AccountEncoding.base64]).
  final AccountEncoding encoding;

  /// The filters applied to the results. An account must meet all filter criteria to be included in 
  /// results.
  final ProgramFilters? filters;

  @override
  Map<String, dynamic> object() => {
    'commitment': commitment?.name,
    'encoding': encoding.name,
    'filters': filters?.toJsonListCleaned(),
  };
}