/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solana_web3/solana_web3.dart';
import 'package:solana_web3/programs.dart' show SystemProgram;


/// Tests
/// ------------------------------------------------------------------------------------------------

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  /// Cluster connections.
  final cluster = Cluster.testnet;
  final connection = Connection(cluster);

  /// Accounts
  final pubkey1 = Pubkey.fromBase58("BKY3nztnk29ugvyMXtFyXVDvUp4uenUt9oBC6bMq97yA");
  final pubkey2 = Pubkey.fromBase58("2HabZecqJ74vXBx63iy9k3Lu6mSL1tf73jJAz95SmBX9");
  final programId = Pubkey.fromBase58('B6evYB1Jq3WUcZpPrw2z5Xu3FQ5WAwVcGHCWX6h4LKSC');

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
    expect(cluster.uri, connection.httpCluster.uri);
    expect(cluster.toWebsocket().uri, connection.websocketCluster.uri);
  });

  /// Health
  test('health check', () async {
    final HealthStatus status = await connection.health();
    _printResponse('health', status);
  });

  /// Send
  test('send', () async {
    final pubkey = Pubkey.fromBase58('CM78CPUeXjn8o3yroDHxUtKsZZgoy4GPkPPXfouKNH12');
    final method = GetAccountInfo(pubkey);
    final result = await connection.send(method);
    _printResponse('send', result);
  });

  /// Send All
  test('send all', () async {
    final builder = JsonRpcMethodBuilder();
    builder.add(GetBalance(Pubkey.fromBase58('CM78CPUeXjn8o3yroDHxUtKsZZgoy4GPkPPXfouKNH12')));
    builder.add(GetEpochInfo());
    final result = await connection.sendAll(builder);
    expect(result.length, builder.length);
    expect(result.first is JsonRpcSuccessResponse<JsonRpcResponseContext<int>>, true);
    expect(result.last is JsonRpcSuccessResponse<EpochInfo>, true);
    _printResponse('send all', result);
  });

  /// Print method response.
  Future<T> _testRequest<T>(final String method, final Future<T> request) async {
    try {
      final response = await request;
      _printResponse(method, (response is SerializableMixin) ? response.toJson() : response);
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
      connection.getAccountInfoRaw(pubkey1, config: accountInfoConfig),
    );
  });
  test('get account info', () async {
    await _testRequest(
      'get account info',
      connection.getAccountInfo(pubkey2, config: accountInfoConfig),
    );
  });

  /// Get Balance
  const getBalanceConfig = GetBalanceConfig(
    commitment: Commitment.finalized,
  );
  test('get balance raw', () async {
    await _testRequest(
      'get balance raw',
      connection.getBalanceRaw(pubkey1, config: getBalanceConfig),
    );
  });
  test('get balance', () async {
    await _testRequest(
      'get balance',
      connection.getBalance(pubkey1, config: getBalanceConfig),
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
  test('get block commitment raw', () async {
    final slot = await connection.getBlockHeight();
    await _testRequest(
      'get block commitment raw',
      connection.getBlockCommitmentRaw(slot),
    );
  });
  test('get block commitment', () async {
    final slot = await connection.getBlockHeight();
    await _testRequest(
      'get block commitment',
      connection.getBlockCommitment(slot),
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
      connection.getBlocks(slot - 2, endSlot: slot, config: getBlocksConfig),
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
  test('get block time raw', () async {
    final slot = await connection.getBlockHeight();
    await _testRequest(
      'get block time raw',
      connection.getBlockTimeRaw(slot - 100),
    );
  });
  test('get block time', () async {
    final slot = await connection.getBlockHeight();
    await _testRequest(
      'get block time',
      connection.getBlockTime(slot - 100),
    );
  });


  /// Get Cluster Nodes
  test('get cluster nodes raw', () async {
    await _testRequest(
      'get cluster nodes raw',
      connection.getClusterNodesRaw(),
    );
  });
  test('get cluster nodes', () async {
    await _testRequest(
      'get cluster nodes',
      connection.getClusterNodes(),
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
  test('get epoch schedule raw', () async {
    await _testRequest(
      'get epoch schedule raw',
      connection.getEpochScheduleRaw(),
    );
  });
  test('get epoch schedule', () async {
    await _testRequest(
      'get epoch schedule',
      connection.getEpochSchedule(),
    );
  });

  /// Get Fee For Message
  const getFeeForMessageConfig = GetFeeForMessageConfig();
  Future<Transaction> _emptyTransaction() async {
    final bh = await connection.getLatestBlockhash();
    return Transaction.v0(
      payer: pubkey1,
      recentBlockhash: bh.blockhash,
      instructions: const []
    );
  }
  test('get fee for message raw', () async {
    final transaction = await _emptyTransaction();
    await _testRequest(
      'get fee for message raw',
      connection.getFeeForMessageRaw(transaction.message, config: getFeeForMessageConfig),
    );
  });
  test('get fee for message', () async {
    final transaction = await _emptyTransaction();
    await _testRequest(
      'get fee for message',
      connection.getFeeForMessage(transaction.message, config: getFeeForMessageConfig),
    );
  });

  /// Get First Available Block Config
  test('get first available block raw', () async {
    await _testRequest(
      'get first available block raw',
      connection.getFirstAvailableBlockRaw(),
    );
  });
  test('get first available block', () async {
    await _testRequest(
      'get first available block',
      connection.getFirstAvailableBlock(),
    );
  });

  /// Get Genesis Hash Config
  test('get genesis hash raw', () async {
    await _testRequest(
      'get genesis hash raw',
      connection.getGenesisHashRaw(),
    );
  });
  test('get genesis hash', () async {
    await _testRequest(
      'get genesis hash',
      connection.getGenesisHash(),
    );
  });

  /// Get Genesis Hash Config
  test('get health raw', () async {
    await _testRequest(
      'get health raw',
      connection.getHealthRaw(),
    );
  });
  test('get health', () async {
    await _testRequest(
      'get health',
      connection.getHealth(),
    );
  });

  test('get highest snapshot slot raw', () async {
    await _testRequest(
      'get highest snapshot slot raw',
      connection.getHighestSnapshotSlotRaw(),
    );
  });
  test('get highest snapshot slot', () async {
    await _testRequest(
      'get highest snapshot slot',
      connection.getHighestSnapshotSlot(),
    );
  });

  test('get identity raw', () async {
    await _testRequest(
      'get identity raw',
      connection.getIdentityRaw(),
    );
  });
  test('get identity', () async {
    await _testRequest(
      'get identity',
      connection.getIdentity(),
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

  test('get inflation rate raw', () async {
    await _testRequest(
      'get inflation rate raw',
      connection.getInflationRateRaw(),
    );
  });
  test('get inflation rate', () async {
    await _testRequest(
      'get inflation rate',
      connection.getInflationRate(),
    );
  });

  const getInflationRewardConfig = GetInflationRewardConfig();
  final addr1 = Pubkey.fromBase58('6dmNQ5jwLeLk5REvio1JcMshcbvkYMwy26sJ8pbkvStu');
  final addr2 = Pubkey.fromBase58('BGsqMegLpV6n6Ve146sSX2dTjUMj3M92HnU8BbNRMhF2');
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
    // identity: Pubkey.fromBase58('XkCriyrNwS3G4rzAXtG5B1nnvb5Ka1JtCku93VqeKAr'),
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

  test('get max retransmit slot raw', () async {
    await _testRequest(
      'get max retransmit slot raw',
      connection.getMaxRetransmitSlotRaw(),
    );
  });
  test('get max retransmit slot', () async {
    await _testRequest(
      'get max retransmit slot',
      connection.getMaxRetransmitSlot(),
    );
  });

  test('get max shred insert slot raw', () async {
    await _testRequest(
      'get max shred insert slot raw',
      connection.getMaxShredInsertSlotRaw(),
    );
  });
  test('get max shred insert slot', () async {
    await _testRequest(
      'get max shred insert slot',
      connection.getMaxShredInsertSlot(),
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
        [pubkey1, pubkey2], 
        config: getMultipleAccountsConfig,
      ),
    );
  });
  test('get multiple accounts', () async {
    await _testRequest(
      'get multiple accounts',
      connection.getMultipleAccounts(
        [pubkey1, pubkey2], 
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

  test('get recent performance samples raw', () async {
    await _testRequest(
      'get recent performance samples raw',
      connection.getRecentPerformanceSamplesRaw(
        limit: 24, 
      ),
    );
  });
  test('get recent performance samples', () async {
    await _testRequest(
      'get recent performance samples',
      connection.getRecentPerformanceSamples(
        limit: 24, 
      ),
    );
  });

  test('get recent prioritization fees raw', () async {
    await _testRequest(
      'get recent prioritization fees raw',
      connection.getRecentPrioritizationFeesRaw(
        [Pubkey.fromBase58('CxELquR1gPP8wHe33gZ4QxqGB3sZ9RSwsJ2KshVewkFY')], 
      ),
    );
  });
  test('get recent prioritization fees', () async {
    await _testRequest(
      'get recent prioritization fees',
      connection.getRecentPrioritizationFees(
        [Pubkey.fromBase58('CxELquR1gPP8wHe33gZ4QxqGB3sZ9RSwsJ2KshVewkFY')],
      ),
    );
  });

  const getSignaturesForAddressConfig = GetSignaturesForAddressConfig();
  test('get signatures for address raw', () async {
    await _testRequest(
      'get signatures for address raw',
      connection.getSignaturesForAddressRaw(
        pubkey1, 
        config: getSignaturesForAddressConfig ,
      ),
    );
  });
  test('get signatures for address', () async {
    await _testRequest(
      'get signatures for address',
      connection.getSignaturesForAddress(
        pubkey1, 
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
  
  test('get slot leaders raw', () async {
    const limit = 10;
    final slot = await connection.getSlot() - limit;
    await _testRequest(
      'get slot leaders raw',
      connection.getSlotLeadersRaw(slot, limit: limit),
    );
  });
  test('get slot leaders', () async {
    const limit = 10;
    final slot = await connection.getSlot() - limit;
    await _testRequest(
      'get slot leaders',
      connection.getSlotLeaders(slot, limit: limit),
    );
  });

  const getStakeActivationConfig = GetStakeActivationConfig();
  // THIS IS A *MAINNET* STAKE ACCOUNT!
  final Pubkey stakeAccount = Pubkey.fromBase58('GREENr9zSeapgunqdMeTg8MCh2cDDn2y3py1mBGUzJYe');
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
  final usdtMint = Pubkey.fromBase58('Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB');
  final usdcMintTestnet = Pubkey.fromBase58('CpMah17kQEL2wqyMKt3mZBdTnZbkbfx4nqmQMFDP5vwp');
  final getTokenAccountFilter = TokenAccountsFilter.mint(usdcMintTestnet);
  final tokenOwner = Pubkey.fromBase58('DmkBSr5YVxHmoFdkzZ8VqBw4RVPWBE6nGppyViRsoXge');
  test('get token account balance raw', () async {
    final tokenAccounts = await connection.getTokenAccountsByOwner(tokenOwner, filter: getTokenAccountFilter);
    await _testRequest(
      'get token account balance raw',
      connection.getTokenAccountBalanceRaw(
        Pubkey.fromBase58(tokenAccounts.first.pubkey), 
        config: getTokenAccountBalanceConfig,
      ),
    );
  });
  test('get token account balance', () async {
    final tokenAccounts = await connection.getTokenAccountsByOwner(tokenOwner, filter: getTokenAccountFilter);
    await _testRequest(
      'get token account balance',
      connection.getTokenAccountBalance(
        Pubkey.fromBase58(tokenAccounts.first.pubkey), 
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
      connection.getTokenAccountsByDelegate(pubkey1, filter: getTokenAccountFilter, config: getTokenAccountsByDelegateConfig),
    );
  });

  final getTokenAccountsByOwnerConfig = GetTokenAccountsByOwnerConfig();
  test('get token accounts by owner raw', () async {
    await _testRequest(
      'get token accounts by owner raw',
      connection.getTokenAccountsByOwnerRaw(pubkey1, filter: getTokenAccountFilter, config: getTokenAccountsByOwnerConfig),
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

  test('get version raw', () async {
    await _testRequest(
      'get version raw',
      connection.getVersionRaw(),
    );
  });
  test('get version', () async {
    await _testRequest(
      'get version',
      connection.getVersion(),
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

  test('get minimum ledger slot raw', () async {
    await _testRequest(
      'get minimum ledger slot raw',
      connection.minimumLedgerSlotRaw(),
    );
  });
  test('get minimum ledger slot', () async {
    await _testRequest(
      'get minimum ledger slot',
      connection.minimumLedgerSlot(),
    );
  });

  const requestAirdropConfig = RequestAirdropConfig();
  test('get request airdrop raw', () async {
    await _testRequest(
      'get request airdrop raw',
      connection.requestAirdropRaw(pubkey1, 1, config: requestAirdropConfig),
    );
  });
  test('get request airdrop', () async {
    await _testRequest(
      'get request airdrop',
      connection.requestAirdrop(pubkey1, 1, config: requestAirdropConfig),
    );
  });

  final sendTransactionConfig = SendTransactionConfig();
  final signer = Keypair.fromSeckeySync(Uint8List.fromList([
    128, 51, 160, 52, 171, 166, 169, 66, 132, 150, 192, 12, 25, 230, 245, 134, 232, 55, 35, 79, 
    123, 218, 85, 199, 242, 115, 122, 214, 79, 206, 122, 15, 228, 6, 185, 235, 146, 84, 148, 251, 
    25, 199, 195, 33, 35, 151, 151, 77, 122, 6, 10, 1, 27, 148, 69, 50, 73, 250, 70, 64, 247, 204, 
    53, 239,
  ]));

  Future<Transaction> _transferTx() async {
    final bh = await connection.getLatestBlockhash();
    final transaction = Transaction(
      message: Message.v0(
        payer: signer.pubkey, 
        recentBlockhash: bh.blockhash,
        instructions: [
          SystemProgram.transfer(
            fromPubkey: signer.pubkey, 
            toPubkey: pubkey1, 
            lamports: solToLamports(0.01),
          ),
        ]
      ),
    );
    transaction.sign([signer]);
    return transaction;
  }

  test('send transaction raw', () async {
    final transaction = await _transferTx();
    await _testRequest(
      'send transaction raw',
      connection.sendTransactionRaw(transaction, config: sendTransactionConfig),
    );
  });
  test('send transaction', () async {
    final transaction = await _transferTx();
    await connection.requestAirdrop(signer.pubkey, solToLamports(1).toInt());
    await _testRequest(
      'send transaction',
      connection.sendTransaction(transaction, config: sendTransactionConfig),
    );
  });

  test('simulate transaction raw', () async {
    final transaction = await _transferTx();
    await _testRequest(
      'simulate transaction raw',
      connection.simulateTransactionRaw(transaction),
    );
  });
  test('simulate transaction', () async {
    final transaction = await _transferTx();
    await _testRequest(
      'simulate transaction',
      connection.simulateTransaction(transaction),
    );
  });
}
