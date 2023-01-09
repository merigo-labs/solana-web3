/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solana_common/exceptions/json_rpc_exception.dart';
import 'package:solana_web3/solana_web3.dart';
import 'package:solana_web3/src/keypair.dart';
import 'package:solana_web3/types/account_encoding.dart';
import 'package:solana_web3/types/transaction_detail.dart';
import 'package:solana_web3/types/transaction_encoding.dart';
import 'package:solana_web3/types/commitment.dart';
import 'package:solana_web3/types/health_status.dart';
import 'package:solana_common/models/serializable.dart';
import 'package:solana_web3/src/public_key.dart';
import 'package:solana_web3/rpc_config/get_account_info_config.dart';
import 'package:solana_web3/rpc_config/get_balance_config.dart';
import 'package:solana_web3/rpc_config/get_block_commitment_config.dart';
import 'package:solana_web3/rpc_config/get_block_config.dart';
import 'package:solana_web3/rpc_config/get_block_height_config.dart';
import 'package:solana_web3/rpc_config/get_block_production_config.dart';
import 'package:solana_web3/rpc_config/get_block_time_config.dart';
import 'package:solana_web3/rpc_config/get_blocks_config.dart';
import 'package:solana_web3/rpc_config/get_blocks_with_limit_config.dart';
import 'package:solana_web3/rpc_config/get_cluster_nodes_config.dart';
import 'package:solana_web3/rpc_config/get_epoch_info_config.dart';
import 'package:solana_web3/rpc_config/get_epoch_schedule_config.dart';
import 'package:solana_web3/rpc_config/get_fee_for_message_config.dart';
import 'package:solana_web3/rpc_config/get_first_available_block_config.dart';
import 'package:solana_web3/rpc_config/get_genesis_hash_config.dart';
import 'package:solana_web3/rpc_config/get_health_config.dart';
import 'package:solana_web3/rpc_config/get_highest_snapshot_slot_config.dart';
import 'package:solana_web3/rpc_config/get_identity_config.dart';
import 'package:solana_web3/rpc_config/get_inflation_governor_config.dart';
import 'package:solana_web3/rpc_config/get_inflation_rate_config.dart';
import 'package:solana_web3/rpc_config/get_inflation_reward_config.dart';
import 'package:solana_web3/rpc_config/get_largest_accounts_config.dart';
import 'package:solana_web3/rpc_config/get_latest_blockhash_config.dart';
import 'package:solana_web3/rpc_config/get_leader_schedule_config.dart';
import 'package:solana_web3/rpc_config/get_max_retransmit_slot_config.dart';
import 'package:solana_web3/rpc_config/get_max_shred_insert_slot_config.dart';
import 'package:solana_web3/rpc_config/get_minimum_balance_for_rent_exemption_config.dart';
import 'package:solana_web3/rpc_config/get_multiple_accounts_config.dart';
import 'package:solana_web3/rpc_config/get_program_accounts_config.dart';
import 'package:solana_web3/rpc_config/get_recent_performance_samples_config.dart';
import 'package:solana_web3/rpc_config/get_signature_statuses_config.dart';
import 'package:solana_web3/rpc_config/get_signatures_for_address_config.dart';
import 'package:solana_web3/rpc_config/get_slot_config.dart';
import 'package:solana_web3/rpc_config/get_slot_leader_config.dart';
import 'package:solana_web3/rpc_config/get_slot_leaders_config.dart';
import 'package:solana_web3/rpc_config/get_stake_activation_config.dart';
import 'package:solana_web3/rpc_config/get_supply_config.dart';
import 'package:solana_web3/rpc_config/get_token_account_balance_config.dart';
import 'package:solana_web3/rpc_config/get_token_accounts_by_delegate_config.dart';
import 'package:solana_web3/rpc_config/get_token_accounts_by_owner_config.dart';
import 'package:solana_web3/rpc_config/get_token_largest_accounts_config.dart';
import 'package:solana_web3/rpc_config/get_token_supply_config.dart';
import 'package:solana_web3/rpc_config/get_transaction_config.dart';
import 'package:solana_web3/rpc_config/get_transaction_count_config.dart';
import 'package:solana_web3/rpc_config/get_version_config.dart';
import 'package:solana_web3/rpc_config/get_vote_accounts_config.dart';
import 'package:solana_web3/rpc_config/is_blockhash_valid_config.dart';
import 'package:solana_web3/rpc_config/minimum_ledger_slot.dart';
import 'package:solana_web3/rpc_config/request_airdrop_config.dart';
import 'package:solana_web3/rpc_config/send_transaction_config.dart';
import 'package:solana_web3/types/token_accounts_filter.dart';
import 'package:solana_web3/solana_web3.dart' as web3 show Cluster, Connection, Transaction;


/// Tests
/// ------------------------------------------------------------------------------------------------

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  /// Cluster connections.
  final cluster = web3.Cluster.testnet;
  final connection = web3.Connection(cluster);


  /// Accounts
  final pubKey1 = PublicKey.fromBase58("BKY3nztnk29ugvyMXtFyXVDvUp4uenUt9oBC6bMq97yA");
  final pubKey2 = PublicKey.fromBase58("2HabZecqJ74vXBx63iy9k3Lu6mSL1tf73jJAz95SmBX9");
  final programId = PublicKey.fromBase58('B6evYB1Jq3WUcZpPrw2z5Xu3FQ5WAwVcGHCWX6h4LKSC');

  /// Print RPC response.
  void _printResponse(String method, dynamic response) {
    print('[Response] $method: $response');
  }

  /// Print [RpcException]
  void _printRpcException(String method, JsonRpcException error) {
    print('[RpcException] $method = ${error.code} : ${error.message} : ${error.data}');
  }
  
  /// Print Unknown Exception.
  void _printUnknownException(String method, Object error) {
    print('[UnknownException] $method = ${error.toString()}');
  }

  /// Print RPC error and throw the [error].
  void _printException(
    final String method, 
    final Object error, { 
    final StackTrace? stack, 
  }) {
    error is JsonRpcException 
      ? _printRpcException(method, error) 
      : _printUnknownException(method, error);
    if (stack != null) { 
      print('[StackTrace]: $stack'); 
    }
  }

  /// Connection
  test('connection', () {
    assert(cluster.http == connection.cluster.http);
  });

  /// Health
  test('health check', () async {
    final HealthStatus status = await connection.health();
    _printResponse('health', status);
  });

  
  Future<T> _testRequest<T>(final String method, final Future<T> request) async {
    try {
      final response = await request;
      _printResponse(method, response is Serializable ? response.toJson() : response);
      return response;
    } catch(e, stack) {
      _printException(method, e, stack: stack);
      return Future.error(e);
    }
  }

  /// Get Account Info
  final accountInfoConfig = GetAccountInfoConfig(
    encoding: AccountEncoding.base64,
    // dataSlice: DataSlice(offset: 0, length: 64),
  );
  test('get account info raw', () async {
    await _testRequest(
      'get account info raw',
      connection.getAccountInfoRaw(pubKey1, config: accountInfoConfig),
    );
  });
  test('get account info', () async {
    await _testRequest(
      'get account info',
      connection.getAccountInfo(pubKey1, config: accountInfoConfig),
    );
  });

  /// Get Balance
  const getBalanceConfig = GetBalanceConfig(
    commitment: Commitment.finalized,
  );
  test('get balance raw', () async {
    await _testRequest(
      'get balance raw',
      connection.getBalanceRaw(pubKey1, config: getBalanceConfig),
    );
  });
  test('get balance', () async {
    await _testRequest(
      'get balance',
      connection.getBalance(pubKey2, config: getBalanceConfig),
    );
  });

  /// Get Block
  final getBlockConfig = GetBlockConfig(
    transactionDetails: TransactionDetail.signatures,
    encoding: TransactionEncoding.jsonParsed,
    // maxSupportedTransactionVersion: 0,
  );
  test('get block raw', () async {
    final blockHeight = await connection.getBlockHeight();
    await _testRequest(
      'get block raw',
      connection.getBlockRaw(blockHeight, config: getBlockConfig),
    );
  });
  test('get block', () async {
    final blockHeight = await connection.getBlockHeight();
    await _testRequest(
      'get block',
      connection.getBlock(blockHeight, config: getBlockConfig),
    );
  });

  /// Get Block Height
  const getBlockHeightConfig = GetBlockHeightConfig(
    minContextSlot: 50000,
  );
  test('get block height raw', () async {
    await _testRequest(
      'get block height raw',
      connection.getBlockHeightRaw(config: getBlockHeightConfig),
    );
  });
  test('get block height', () async {
    await _testRequest(
      'get block height',
      connection.getBlockHeight(config: getBlockHeightConfig),
    );
  });

  /// Get Block Production
  const getBlockProductionConfig = GetBlockProductionConfig(
  );
  test('get block production raw', () async {
    await _testRequest(
      'get block production raw',
      connection.getBlockProductionRaw(config: getBlockProductionConfig),
    );
  });
  test('get block production', () async {
    await _testRequest(
      'get block production',
      connection.getBlockProduction(config: getBlockProductionConfig),
    );
  });

  /// Get Block Commitment
  const getBlockCommitmentConfig = GetBlockCommitmentConfig(
  );
  test('get block commitment raw', () async {
    final slot = await connection.getBlockHeight();
    await _testRequest(
      'get block commitment raw',
      connection.getBlockCommitmentRaw(slot, config: getBlockCommitmentConfig),
    );
  });
  test('get block commitment', () async {
    final slot = await connection.getBlockHeight();
    await _testRequest(
      'get block commitment',
      connection.getBlockCommitment(slot, config: getBlockCommitmentConfig),
    );
  });

  /// Get Blocks
  const getBlocksConfig = GetBlocksConfig(
  );
  test('get blocks raw', () async {
    final slot = await connection.getBlockHeight();
    await _testRequest(
      'get blocks raw',
      connection.getBlocksRaw(slot - 10, endSlot: slot, config: getBlocksConfig),
    );
  });
  test('get blocks', () async {
    final slot = await connection.getBlockHeight();
    await _testRequest(
      'get blocks',
      connection.getBlocks(slot - 10, endSlot: slot, config: getBlocksConfig),
    );
  });

  /// Get Blocks With Limit
  final getBlocksWithLimitConfig = GetBlocksWithLimitConfig();
  test('get blocks with limit raw', () async {
    final slot = await connection.getBlockHeight();
    await _testRequest(
      'get blocks with limit raw',
      connection.getBlocksWithLimitRaw(slot - 100, limit: 5, config: getBlocksWithLimitConfig),
    );
  });
  test('get blocks with limit', () async {
    final slot = await connection.getBlockHeight();
    await _testRequest(
      'get blocks with limit',
      connection.getBlocksWithLimit(slot - 100, limit: 5, config: getBlocksWithLimitConfig),
    );
  });

  /// Get Block Time
  const getBlockTimeConfig = GetBlockTimeConfig(
  );
  test('get block time raw', () async {
    final slot = await connection.getBlockHeight();
    await _testRequest(
      'get block time raw',
      connection.getBlockTimeRaw(slot - 100, config: getBlockTimeConfig),
    );
  });
  test('get block time', () async {
    final slot = await connection.getBlockHeight();
    await _testRequest(
      'get block time',
      connection.getBlockTime(slot - 100, config: getBlockTimeConfig),
    );
  });


  /// Get Cluster Nodes
  const getClusterNodesConfig = GetClusterNodesConfig(
  );
  test('get cluster nodes raw', () async {
    await _testRequest(
      'get cluster nodes raw',
      connection.getClusterNodesRaw(config: getClusterNodesConfig),
    );
  });
  test('get cluster nodes', () async {
    await _testRequest(
      'get cluster nodes',
      connection.getClusterNodes(config: getClusterNodesConfig),
    );
  });

  /// Get Epoch Info
  const getEpochInfoConfig = GetEpochInfoConfig(
  );
  test('get epoch info raw', () async {
    await _testRequest(
      'get epoch info raw',
      connection.getEpochInfoRaw(config: getEpochInfoConfig),
    );
  });
  test('get epoch info', () async {
    await _testRequest(
      'get epoch info',
      connection.getEpochInfo(config: getEpochInfoConfig),
    );
  });

  /// Get Epoch Schedule
  const getEpochScheduleConfig = GetEpochScheduleConfig(
  );
  test('get epoch schedule raw', () async {
    await _testRequest(
      'get epoch schedule raw',
      connection.getEpochScheduleRaw(config: getEpochScheduleConfig),
    );
  });
  test('get epoch schedule', () async {
    await _testRequest(
      'get epoch schedule',
      connection.getEpochSchedule(config: getEpochScheduleConfig),
    );
  });

  /// Get Fee For Message
  const getFeeForMessageConfig = GetFeeForMessageConfig();
  Future<web3.Transaction> _emptyTransaction() async {
    final bh = await connection.getLatestBlockhash();
    return web3.Transaction(
      recentBlockhash: bh.blockhash,
      feePayer: pubKey1,
    );
  }
  test('get fee for message raw', () async {
    final transaction = await _emptyTransaction();
    await _testRequest(
      'get fee for message raw',
      connection.getFeeForMessageRaw(transaction.compileMessage(), config: getFeeForMessageConfig),
    );
  });
  test('get fee for message', () async {
    final transaction = await _emptyTransaction();
    await _testRequest(
      'get fee for message',
      connection.getFeeForMessage(transaction.compileMessage(), config: getFeeForMessageConfig),
    );
  });

  /// Get First Available Block Config
  const getFirstAvailableBlockConfig = GetFirstAvailableBlockConfig();
  test('get first available block raw', () async {
    await _testRequest(
      'get first available block raw',
      connection.getFirstAvailableBlockRaw(config: getFirstAvailableBlockConfig),
    );
  });
  test('get first available block', () async {
    await _testRequest(
      'get first available block',
      connection.getFirstAvailableBlock(config: getFirstAvailableBlockConfig),
    );
  });

  /// Get Genesis Hash Config
  const getGenesisHashConfig = GetGenesisHashConfig();
  test('get genesis hash raw', () async {
    await _testRequest(
      'get genesis hash raw',
      connection.getGenesisHashRaw(config: getGenesisHashConfig),
    );
  });
  test('get genesis hash', () async {
    await _testRequest(
      'get genesis hash',
      connection.getGenesisHash(config: getGenesisHashConfig),
    );
  });

  /// Get Genesis Hash Config
  const getHealthConfig = GetHealthConfig();
  test('get health raw', () async {
    await _testRequest(
      'get health raw',
      connection.getHealthRaw(config: getHealthConfig),
    );
  });
  test('get health', () async {
    await _testRequest(
      'get health',
      connection.getHealth(config: getHealthConfig),
    );
  });

  const getHighestSnapshotSlotConfig = GetHighestSnapshotSlotConfig();
  test('get highest snapshot slot raw', () async {
    await _testRequest(
      'get highest snapshot slot raw',
      connection.getHighestSnapshotSlotRaw(config: getHighestSnapshotSlotConfig),
    );
  });
  test('get highest snapshot slot', () async {
    await _testRequest(
      'get highest snapshot slot',
      connection.getHighestSnapshotSlot(config: getHighestSnapshotSlotConfig),
    );
  });

  const getIdentityConfig = GetIdentityConfig();
  test('get identity raw', () async {
    await _testRequest(
      'get identity raw',
      connection.getIdentityRaw(config: getIdentityConfig),
    );
  });
  test('get identity', () async {
    await _testRequest(
      'get identity',
      connection.getIdentity(config: getIdentityConfig),
    );
  });

  const getInflationGovernorConfig = GetInflationGovernorConfig();
  test('get inflation governor raw', () async {
    await _testRequest(
      'get inflation governor raw',
      connection.getInflationGovernorRaw(config: getInflationGovernorConfig),
    );
  });
  test('get inflation governor', () async {
    await _testRequest(
      'get inflation governor',
      connection.getInflationGovernor(config: getInflationGovernorConfig),
    );
  });

  const getInflationRateConfig = GetInflationRateConfig();
  test('get inflation rate raw', () async {
    await _testRequest(
      'get inflation rate raw',
      connection.getInflationRateRaw(config: getInflationRateConfig),
    );
  });
  test('get inflation rate', () async {
    await _testRequest(
      'get inflation rate',
      connection.getInflationRate(config: getInflationRateConfig),
    );
  });

  const getInflationRewardConfig = GetInflationRewardConfig();
  final addr1 = PublicKey.fromBase58('6dmNQ5jwLeLk5REvio1JcMshcbvkYMwy26sJ8pbkvStu');
  final addr2 = PublicKey.fromBase58('BGsqMegLpV6n6Ve146sSX2dTjUMj3M92HnU8BbNRMhF2');
  test('get inflation reward raw', () async {
    await _testRequest(
      'get inflation reward raw',
      connection.getInflationRewardRaw([addr1, addr2], config: getInflationRewardConfig),
    );
  });
  test('get inflation reward', () async {
    await _testRequest(
      'get inflation reward',
      connection.getInflationReward([addr1, addr2], config: getInflationRewardConfig),
    );
  });

  const getLargestAccountsConfig = GetLargestAccountsConfig();
  test('get largest accounts raw', () async {
    await _testRequest(
      'get largest accounts raw',
      connection.getLargestAccountsRaw(config: getLargestAccountsConfig),
    );
  });
  test('get largest accounts', () async {
    await _testRequest(
      'get largest accounts',
      connection.getLargestAccounts(config: getLargestAccountsConfig),
    );
  });

  const getLatestBlockhashConfig = GetLatestBlockhashConfig();
  test('get latest blockhash raw', () async {
    await _testRequest(
      'get latest blockhash raw',
      connection.getLatestBlockhashRaw(config: getLatestBlockhashConfig),
    );
  });
  test('get latest blockhash', () async {
    await _testRequest(
      'get latest blockhash',
      connection.getLatestBlockhash(config: getLatestBlockhashConfig),
    );
  });

  final getLeaderScheduleConfig = GetLeaderScheduleConfig(
    identity: PublicKey.fromBase58('XkCriyrNwS3G4rzAXtG5B1nnvb5Ka1JtCku93VqeKAr'),
  );
  test('get leader schedule raw', () async {
    await _testRequest(
      'get leader schedule raw',
      connection.getLeaderScheduleRaw(config: getLeaderScheduleConfig),
    );
  });
  test('get leader schedule', () async {
    await _testRequest(
      'get leader schedule',
      connection.getLeaderSchedule(config: getLeaderScheduleConfig),
    );
  });

  const getMaxRetransmitSlotConfig = GetMaxRetransmitSlotConfig();
  test('get max retransmit slot raw', () async {
    await _testRequest(
      'get max retransmit slot raw',
      connection.getMaxRetransmitSlotRaw(config: getMaxRetransmitSlotConfig),
    );
  });
  test('get max retransmit slot', () async {
    await _testRequest(
      'get max retransmit slot',
      connection.getMaxRetransmitSlot(config: getMaxRetransmitSlotConfig),
    );
  });

  const getMaxShredInsertSlotConfig = GetMaxShredInsertSlotConfig();
  test('get max shred insert slot raw', () async {
    await _testRequest(
      'get max shred insert slot raw',
      connection.getMaxShredInsertSlotRaw(config: getMaxShredInsertSlotConfig),
    );
  });
  test('get max shred insert slot', () async {
    await _testRequest(
      'get max shred insert slot',
      connection.getMaxShredInsertSlot(config: getMaxShredInsertSlotConfig),
    );
  });

  const getMinimumBalanceForRentExemptionConfig = GetMinimumBalanceForRentExemptionConfig();
  test('get minimum balance for rent exemption raw', () async {
    await _testRequest(
      'get minimum balance for rent exemption raw',
      connection.getMinimumBalanceForRentExemptionRaw(
        10240000, 
        config: getMinimumBalanceForRentExemptionConfig,
      ),
    );
  });
  test('get minimum balance for rent exemption', () async {
    await _testRequest(
      'get minimum balance for rent exemption',
      connection.getMinimumBalanceForRentExemption(
        10240000, 
        config: getMinimumBalanceForRentExemptionConfig,
      ),
    );
  });

  final getMultipleAccountsConfig = GetMultipleAccountsConfig();
  test('get multiple accounts raw', () async {
    await _testRequest(
      'get multiple accounts raw',
      connection.getMultipleAccountsRaw(
        [pubKey1, pubKey2], 
        config: getMultipleAccountsConfig,
      ),
    );
  });
  test('get multiple accounts', () async {
    await _testRequest(
      'get multiple accounts',
      connection.getMultipleAccounts(
        [pubKey1, pubKey2], 
        config: getMultipleAccountsConfig,
      ),
    );
  });

  final getProgramAccountsConfig = GetProgramAccountsConfig();
  test('get program accounts raw', () async {
    await _testRequest(
      'get program accounts raw',
      connection.getProgramAccountsRaw(
        programId, 
        config: getProgramAccountsConfig ,
      ),
    );
  });
  test('get program accounts', () async {
    await _testRequest(
      'get program accounts',
      connection.getProgramAccounts(
        programId, 
        config: getProgramAccountsConfig ,
      ),
    );
  });

  const getRecentPerformanceSamplesConfig = GetRecentPerformanceSamplesConfig();
  test('get recent performance samples raw', () async {
    await _testRequest(
      'get recent performance samples raw',
      connection.getRecentPerformanceSamplesRaw(
        limit: 24, 
        config: getRecentPerformanceSamplesConfig ,
      ),
    );
  });
  test('get recent performance samples', () async {
    await _testRequest(
      'get recent performance samples',
      connection.getRecentPerformanceSamples(
        limit: 24, 
        config: getRecentPerformanceSamplesConfig ,
      ),
    );
  });

  const getSignaturesForAddressConfig = GetSignaturesForAddressConfig();
  test('get signatures for address raw', () async {
    await _testRequest(
      'get signatures for address raw',
      connection.getSignaturesForAddressRaw(
        pubKey1, 
        config: getSignaturesForAddressConfig ,
      ),
    );
  });
  test('get signatures for address', () async {
    await _testRequest(
      'get signatures for address',
      connection.getSignaturesForAddress(
        pubKey1, 
        config: getSignaturesForAddressConfig,
      ),
    );
  });


  const getSignatureStatusesConfig = GetSignatureStatusesConfig(
    searchTransactionHistory: true,
  );
  test('get signatures statuses raw', () async {
    await _testRequest(
      'get signatures statuses raw',
      connection.getSignatureStatusesRaw(
        [
          "2zjrwykjviryabtyjRKk4quWgQ2tURhKBR1YeuyQf1AWj2swwd57qqe2zyXUaoMdspinRJzx28wKygExgq4HWCWA",
          "5j7s6NiJS3JAkvgkoc18WVAsiSaci2pxB2A6ueCJP4tprA2TFg9wSyTLeYouxPBJEMzJinENTkpA52YStRW5Dia7",
        ], 
        config: getSignatureStatusesConfig ,
      ),
    );
  });
  test('get signatures statuses', () async {
    await _testRequest(
      'get signatures statuses',
      connection.getSignatureStatuses(
        [
          "2zjrwykjviryabtyjRKk4quWgQ2tURhKBR1YeuyQf1AWj2swwd57qqe2zyXUaoMdspinRJzx28wKygExgq4HWCWA",
          "5j7s6NiJS3JAkvgkoc18WVAsiSaci2pxB2A6ueCJP4tprA2TFg9wSyTLeYouxPBJEMzJinENTkpA52YStRW5Dia7",
        ], 
        config: getSignatureStatusesConfig,
      ),
    );
  });

  const getSlotConfig = GetSlotConfig();
  test('get slot raw', () async {
    await _testRequest(
      'get slot raw',
      connection.getSlotRaw(config: getSlotConfig),
    );
  });
  test('get slot', () async {
    await _testRequest(
      'get slot',
      connection.getSlot(config: getSlotConfig),
    );
  });

  const getSlotLeaderConfig = GetSlotLeaderConfig();
  test('get slot leader raw', () async {
    await _testRequest(
      'get slot leader raw',
      connection.getSlotLeaderRaw(config: getSlotLeaderConfig),
    );
  });
  test('get slot leader', () async {
    await _testRequest(
      'get slot leader',
      connection.getSlotLeader(config: getSlotLeaderConfig),
    );
  });
  
  const getSlotLeadersConfig = GetSlotLeadersConfig();
  test('get slot leaders raw', () async {
    const limit = 10;
    final slot = await connection.getSlot() - limit;
    await _testRequest(
      'get slot leaders raw',
      connection.getSlotLeadersRaw(start: slot, limit: limit, config: getSlotLeadersConfig),
    );
  });
  test('get slot leaders', () async {
    const limit = 10;
    final slot = await connection.getSlot() - limit;
    await _testRequest(
      'get slot leaders',
      connection.getSlotLeaders(start: slot, limit: limit, config: getSlotLeadersConfig),
    );
  });

  const getStakeActivationConfig = GetStakeActivationConfig();
  final PublicKey stakeAccount = PublicKey.fromBase58('GREENr9zSeapgunqdMeTg8MCh2cDDn2y3py1mBGUzJYe');
  test('get stake activation raw', () async {
    await _testRequest(
      'get stake activation raw',
      connection.getStakeActivationRaw(stakeAccount, config: getStakeActivationConfig),
    );
  });
  test('get stake activation', () async {
    await _testRequest(
      'get stake activation',
      connection.getStakeActivation(stakeAccount, config: getStakeActivationConfig),
    );
  });

  const getSupplyConfig = GetSupplyConfig();
  test('get supply raw', () async {
    await _testRequest(
      'get supply raw',
      connection.getSupplyRaw(config: getSupplyConfig),
    );
  });
  test('get supply', () async {
    await _testRequest(
      'get supply',
      connection.getSupply(config: getSupplyConfig),
    );
  });

  const getTokenAccountBalanceConfig = GetTokenAccountBalanceConfig();
  /// USDT Mint Address.
  final usdtMint = PublicKey.fromBase58('Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB');
  final usdcMintTestnet = PublicKey.fromBase58('CpMah17kQEL2wqyMKt3mZBdTnZbkbfx4nqmQMFDP5vwp');
  final getTokenAccountFilter = TokenAccountsFilter.mint(usdcMintTestnet);
  final tokenOwner = PublicKey.fromBase58('DmkBSr5YVxHmoFdkzZ8VqBw4RVPWBE6nGppyViRsoXge');
  test('get token account balance raw', () async {
    final tokenAccounts = await connection.getTokenAccountsByOwner(tokenOwner, filter: getTokenAccountFilter);
    await _testRequest(
      'get token account balance raw',
      connection.getTokenAccountBalanceRaw(
        PublicKey.fromBase58(tokenAccounts.first.pubkey), 
        config: getTokenAccountBalanceConfig,
      ),
    );
  });
  test('get token account balance', () async {
    final tokenAccounts = await connection.getTokenAccountsByOwner(tokenOwner, filter: getTokenAccountFilter);
    await _testRequest(
      'get token account balance',
      connection.getTokenAccountBalance(
        PublicKey.fromBase58(tokenAccounts.first.pubkey), 
        config: getTokenAccountBalanceConfig,
      ),
    );
  });

  final getTokenAccountsByDelegateConfig = GetTokenAccountsByDelegateConfig();
  test('get token accounts by delegate raw', () async {
    await _testRequest(
      'get token accounts by delegate raw',
      connection.getTokenAccountsByDelegateRaw(tokenOwner, filter: getTokenAccountFilter, config: getTokenAccountsByDelegateConfig),
    );
  });
  test('get token accounts by delegate', () async {
    await _testRequest(
      'get token accounts by delegate',
      connection.getTokenAccountsByDelegate(pubKey1, filter: getTokenAccountFilter, config: getTokenAccountsByDelegateConfig),
    );
  });

  final getTokenAccountsByOwnerConfig = GetTokenAccountsByOwnerConfig();
  test('get token accounts by owner raw', () async {
    await _testRequest(
      'get token accounts by owner raw',
      connection.getTokenAccountsByOwnerRaw(pubKey1, filter: getTokenAccountFilter, config: getTokenAccountsByOwnerConfig),
    );
  });
  test('get token accounts by owner', () async {
    await _testRequest(
      'get token accounts by owner',
      connection.getTokenAccountsByOwner(tokenOwner, filter: getTokenAccountFilter, config: getTokenAccountsByOwnerConfig),
    );
  });

  const getTokenLargestAccountsConfig = GetTokenLargestAccountsConfig();
  test('get token largest accounts raw', () async {
    await _testRequest(
      'get token largest accounts raw',
      connection.getTokenLargestAccountsRaw(usdcMintTestnet, config: getTokenLargestAccountsConfig),
    );
  });
  test('get token largest accounts', () async {
    await _testRequest(
      'get token largest accounts',
      connection.getTokenLargestAccounts(usdcMintTestnet, config: getTokenLargestAccountsConfig),
    );
  });

  const getTokenSupplyConfig = GetTokenSupplyConfig();
  test('get token supply raw', () async {
    await _testRequest(
      'get token supply raw',
      connection.getTokenSupplyRaw(usdtMint, config: getTokenSupplyConfig),
    );
  });
  test('get token supply', () async {
    await _testRequest(
      'get token supply',
      connection.getTokenSupply(usdcMintTestnet, config: getTokenSupplyConfig),
    );
  });

  final getTransactionConfig = GetTransactionConfig();
  const usdcTxSignatureTestnet = 'W7Fr3y1gGRVD39Mo9cuD3tfPtHkzA5Sa4cZieLS9i6SU4q8gA91eM6aLryYYiuL8WvntDRaqVcLf46mvpsQ3Xep';
  test('get transaction raw', () async {
    await _testRequest(
      'get transaction raw',
      connection.getTransactionRaw(usdcTxSignatureTestnet, config: getTransactionConfig),
    );
  });
  test('get transaction', () async {
    await _testRequest(
      'get transaction',
      connection.getTransaction(usdcTxSignatureTestnet, config: getTransactionConfig),
    );
  });

  const getTransactionCountConfig = GetTransactionCountConfig();
  test('get transaction count raw', () async {
    await _testRequest(
      'get transaction count raw',
      connection.getTransactionCountRaw(config: getTransactionCountConfig),
    );
  });
  test('get transaction count', () async {
    await _testRequest(
      'get transaction count',
      connection.getTransactionCount(config: getTransactionCountConfig),
    );
  });

  const getVersionConfig = GetVersionConfig();
  test('get version raw', () async {
    await _testRequest(
      'get version raw',
      connection.getVersionRaw(config: getVersionConfig),
    );
  });
  test('get version', () async {
    await _testRequest(
      'get version',
      connection.getVersion(config: getVersionConfig),
    );
  });

  const getVoteAccountsConfig = GetVoteAccountsConfig();
  test('get vote accounts raw', () async {
    await _testRequest(
      'get vote accounts raw',
      connection.getVoteAccountsRaw(config: getVoteAccountsConfig),
    );
  });
  test('get vote accounts', () async {
    await _testRequest(
      'get vote accounts',
      connection.getVoteAccounts(config: getVoteAccountsConfig),
    );
  });

  const isBlockhashValidConfig = IsBlockhashValidConfig();
  test('get is blockhash valid raw', () async {
    final latest = await connection.getLatestBlockhash();
    await _testRequest(
      'get is blockhash valid raw',
      connection.isBlockhashValidRaw(latest.blockhash, config: isBlockhashValidConfig),
    );
  });
  test('get is blockhash valid', () async {
    final latest = await connection.getLatestBlockhash();
    await _testRequest(
      'get is blockhash valid',
      connection.isBlockhashValid(latest.blockhash, config: isBlockhashValidConfig),
    );
  });

  const minimumLedgerSlotConfig = MinimumLedgerSlotConfig();
  test('get minimum ledger slot raw', () async {
    await _testRequest(
      'get minimum ledger slot raw',
      connection.minimumLedgerSlotRaw(config: minimumLedgerSlotConfig),
    );
  });
  test('get minimum ledger slot', () async {
    await _testRequest(
      'get minimum ledger slot',
      connection.minimumLedgerSlot(config: minimumLedgerSlotConfig),
    );
  });

  const requestAirdropConfig = RequestAirdropConfig();
  test('get request airdrop raw', () async {
    await _testRequest(
      'get request airdrop raw',
      connection.requestAirdropRaw(pubKey1, 1, config: requestAirdropConfig),
    );
  });
  test('get request airdrop', () async {
    await _testRequest(
      'get request airdrop',
      connection.requestAirdrop(pubKey1, 1, config: requestAirdropConfig),
    );
  });

  final sendTransactionConfig = SendTransactionConfig();
  test('get send transaction raw', () async {
    final transaction = web3.Transaction();
    await _testRequest(
      'get send transaction raw',
      connection.sendTransactionRaw(transaction, config: sendTransactionConfig),
    );
  });
  test('get send transaction', () async {
    final transaction = web3.Transaction();
    await _testRequest(
      'get send transaction',
      connection.sendTransaction(transaction, config: sendTransactionConfig),
    );
  });

  test('get simulate transaction raw', () async {
    final transaction = web3.Transaction();
    await _testRequest(
      'get simulate transaction raw',
      connection.simulateTransactionRaw(transaction),
    );
  });
  test('get simulate transaction', () async {
    final transaction = web3.Transaction();
    await _testRequest(
      'get simulate transaction',
      connection.simulateTransaction(transaction),
    );
  });
}
