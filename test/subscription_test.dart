/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solana_common/web_socket/web_socket_subscription_manager.dart';
import 'package:solana_web3/rpc_models/account_info.dart';
import 'package:solana_web3/solana_web3.dart' as web3;
import 'utils.dart' as utils;


/// Subscription Tests
/// ------------------------------------------------------------------------------------------------

void main() {

  WidgetsFlutterBinding.ensureInitialized();
    
  final connection = web3.Connection(web3.Cluster.devnet);
  final address = utils.wallet.publicKey;

  test('account subscribe', () async {

    final accountInfo = await connection.getAccountInfo(address);
    print('Account Info ${accountInfo?.toJson()}');

    WebSocketSubscription<AccountInfo> subscription = await connection.accountSubscribe(address);
    subscription.on((data) async {
      print('Account Info Changed ${data.toJson()}');
      await connection.accountUnsubscribe(subscription);
      // await connection.requestAirdrop(utils.wallet.publicKey, web3.solToLamports(1).toInt());
      connection.debugWebSocketState();
    });

    final amount = web3.solToLamports(1).toInt();
    final airdropSignature = await connection.requestAirdrop(utils.wallet.publicKey, amount);
    

    // Keep test from closing.
    await Future.delayed(const Duration(seconds: 10));
  });
}