/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/public_key.dart';
import 'package:solana_web3/src/utils/convert.dart';


/// Logs Filter
/// ------------------------------------------------------------------------------------------------

class LogsFilter<T extends Object> {

  /// The filter criteria for the logs to receive results by account type.
  const LogsFilter(this.value);

  /// 
  final T value;

  /// Subscribes to all transactions except for simple vote transactions.
  static LogsFilter all() => const LogsFilter("all");

  /// Subscribes to all transactions including simple vote transactions.
  static LogsFilter allWithVotes() => const LogsFilter("allWithVotes");
    
  /// Subscribes to all transactions that mention the provided [PublicKey].
  static LogsFilter mentions(final List<PublicKey> accounts) {
    final mentions = list.decode(accounts, (final PublicKey account) => account.toBase58());
    return LogsFilter({ 'mentions': mentions });
  }
}