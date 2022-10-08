/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/utils/library.dart' as utils show tryCall;


/// Methods
/// ------------------------------------------------------------------------------------------------

enum Method {

  getAccountInfo,
  getBalance,
  getBlock,
  getBlockHeight,
  getBlockProduction,
  getBlockCommitment,
  getBlocks,
  getBlocksWithLimit,
  getBlockTime,
  getClusterNodes,
  getEpochInfo,
  getEpochSchedule,
  getFeeForMessage,
  getFirstAvailableBlock,
  getGenesisHash,
  getHealth,
  getHighestSnapshotSlot,
  getIdentity,
  getInflationGovernor,
  getInflationRate,
  getInflationReward,
  getLargestAccounts,
  getLatestBlockhash,
  getLeaderSchedule,
  getMaxRetransmitSlot,
  getMaxShredInsertSlot,
  getMinimumBalanceForRentExemption,
  getMultipleAccounts,
  getProgramAccounts,
  getRecentPerformanceSamples,
  getSignaturesForAddress,
  getSignatureStatuses,
  getSlot,
  getSlotLeader,
  getSlotLeaders,
  getStakeActivation,
  getSupply,
  getTokenAccountBalance,
  getTokenAccountsByDelegate,
  getTokenAccountsByOwner,
  getTokenLargestAccounts,
  getTokenSupply,
  getTransaction,
  getTransactionCount,
  getVersion,
  getVoteAccounts,
  isBlockhashValid,
  minimumLedgerSlot,
  requestAirdrop,
  sendTransaction,
  simulateTransaction,

  accountSubscribe,
  accountUnsubscribe,
  logsSubscribe,
  logsUnsubscribe,
  programSubscribe,
  programUnsubscribe,
  signatureSubscribe,
  signatureUnsubscribe,
  slotSubscribe,
  slotUnsubscribe,
  rootSubscribe,
  rootUnsubscribe,
  ;

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Throws an [ArgumentError] if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// Method.fromName('getAccountInfo');
  /// ```
  factory Method.fromName(final String name) => values.byName(name);

  /// Returns the enum variant where [EnumName.name] is equal to [name].
  /// 
  /// Returns `null` if [name] cannot be matched to an existing variant.
  /// 
  /// ```
  /// Method.tryFromName('getAccountInfo');
  /// ```
  static Method? tryFromName(final String? name) {
    return name != null ? utils.tryCall(() => Method.fromName(name)) : null;
  }
}