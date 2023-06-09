/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solana_common/async.dart';
import 'package:solana_web3/solana_web3.dart';
import 'utils.dart' as utils;


/// Subscription Tests
/// ------------------------------------------------------------------------------------------------

void main() {

  WidgetsFlutterBinding.ensureInitialized();
    
  final connection = Connection(
    Cluster.localhost,
    websocketCluster: Cluster.localhost.toWebsocket(8900)
  );

  const String signature = '2EBVM6cB8vAAD93Ktr6Vd8p67XPbQzCJX47MpReuiCXJAtcjaxpvWpcg9Ege1Nr5Tk3a2GFrByT7WPBjdsTycY9b';

  dynamic Function() asyncBody(dynamic Function(SafeCompleter<void> completer) body) 
    => () async {
      final SafeCompleter testCompleter = SafeCompleter.sync();
      body(testCompleter);
      await testCompleter.future;
    }; 

  test('single subscription', asyncBody((completer) async {
    final Pubkey pubkey = utils.wallet.pubkey;
    final subscription = await connection.accountSubscribe(pubkey);
    expect(connection.debugNotifiers.length, 1);
    final result = await connection.accountUnsubscribe(subscription);
    expect(result, true);
    expect(connection.debugNotifiers.isEmpty, true);
    completer.complete();
  }));

  test('multiple subscriptions', asyncBody((completer) async {
    const int count = 5;
    final Pubkey pubkey = utils.wallet.pubkey;
    final List<WebsocketSubscription<AccountInfo>> subscriptions = [];
    for (int i = 0; i < count; ++i) {
      subscriptions.add(await connection.accountSubscribe(pubkey));
      expect(connection.debugNotifiers.length, 1);
    }
    for (int i = 0; i < count; ++i) {
      final WebsocketSubscription<AccountInfo> subscription = subscriptions[i];
      final bool result = await connection.accountUnsubscribe(subscription);
      expect(result, true);
      expect(connection.debugNotifiers.length, (i+1) < count ? 1 : 0);
    }
    completer.complete();
  }));

  test('timeout subscription', asyncBody((completer) async {
    const bool cancelOnError = true;
    await connection.signatureSubscribe(
      '2EBVM6cB8vAAD93Ktr6Vd8p67XPbQzCJX47MpReuiCXJAtcjaxpvWpcg9Ege1Nr5Tk3a2GFrByT7WPBjdsTycY9b',
      onData: (notification) {
        completer.completeError('Notification received.');
      },
      onError: (error, [stack]) async {
        expect(error is TimeoutException, true);
        await Future.delayed(const Duration(seconds: 2)); // Wait for unsubscribe.
        expect(connection.debugNotifiers.isEmpty, cancelOnError);
        completer.complete();
      },
      timeLimit: const Duration(seconds: 2),
      cancelOnError: cancelOnError
    );
  }));

  test('multiple timeout subscriptions', asyncBody((completer) async {
    const int total = 5;
    const bool cancelOnError = true;
    final List<Future> subscriptions = [];
    for (int i = 0; i < total; ++i) {
      subscriptions.add(connection.signatureSubscribe(
        '2EBVM6cB8vAAD93Ktr6Vd8p67XPbQzCJX47MpReuiCXJAtcjaxpvWpcg9Ege1Nr5Tk3a2GFrByT7WPBjdsTycY9b',
        onData: (notification) {
          completer.completeError('Notification received.');
        },
        onDone: () {
          completer.completeError('Subscription closed.');
        },
        onError: (error, [stack]) {
          expect(error is TimeoutException, true);
          completer.complete();
        },
        timeLimit: const Duration(seconds: 2),
        cancelOnError: cancelOnError,
      ));
    }
    await Future.wait(subscriptions);
    await Future.delayed(const Duration(seconds: 2)); // Wait for unsubscribe.
    expect(connection.debugNotifiers.isEmpty, cancelOnError);
  }));

  test('account subscribe', asyncBody((completer) async {
    const int amount = lamportsPerSol;
    final Keypair keypair = Keypair.generateSync();
    final Pubkey pubkey = keypair.pubkey;
    late final WebsocketSubscription<AccountInfo> subscription;
    subscription = await connection.accountSubscribe(
      pubkey,
      onData: (data) async {
        expect(data.lamports, amount);
        await connection.accountUnsubscribe(subscription);
        expect(connection.debugNotifiers.isEmpty, true);
        completer.complete();
      },
      onError: (error, [stack]) {
        completer.completeError(error);
      }
    );
    connection.requestAirdrop(pubkey, amount);
  }));

  test('signature subscribe', asyncBody((completer) async {
    final Pubkey pubkey = utils.wallet.pubkey;
    final signature = await connection.requestAirdrop(pubkey, lamportsPerSol);
    late final WebsocketSubscription<SignatureNotification> subscription;
    subscription = await connection.signatureSubscribe(
      signature,
      onData: (data) async {
        expect(data.err, null);
      },
      onError: (error, [stack]) {
        completer.completeError(error);
      },
      onDone: () {
        expect(connection.debugNotifiers.isEmpty, true);
        completer.complete();
      }
    );
  }));

  test('invalid subscription id', asyncBody((completer) async {
    final Pubkey pubkey = utils.wallet.pubkey;
    final signature = await connection.requestAirdrop(pubkey, lamportsPerSol);
    final subscription = await connection.signatureSubscribe(signature);
    final success = await connection.signatureUnsubscribe(subscription);
    expect(success, true);
    final failure = await connection.signatureUnsubscribe(subscription);
    expect(failure, false);
    completer.complete();
  }));

  // test('account subscribe', () async {
  //   final Completer testCompleter = Completer.sync();
  //   const int amount = lamportsPerSol;
  //   final Keypair wallet = utils.wallet;
  //   final int balance = await connection.getBalance(wallet.pubkey);
  //   late WebsocketSubscription<AccountInfo> subscription;
  //   subscription = await connection.accountSubscribe(
  //     wallet.pubkey,
  //     onData: (final AccountInfo data) async {
  //       expect(data.lamports, balance + amount);
  //       final result = await connection.accountUnsubscribe(subscription);
  //       expect(result, true);
  //       testCompleter.complete();
  //     }
  //   );
  //   await connection.requestAirdrop(wallet.pubkey, amount);
  //   await testCompleter.future;
  // });

  // test('account subscribe (closed)', () async {
  //   final Completer testCompleter = Completer.sync();
  //   final Keypair wallet = utils.wallet;
  //   await connection.accountSubscribe(
  //     wallet.pubkey,
  //     onData: (data) {
  //       testCompleter.completeError('Data received $data');
  //     },
  //     onDone: () {
  //       expect(connection.debugNotifiers.isEmpty, true);
  //       expect(connection.debugSubscriptions.isEmpty, true);
  //       testCompleter.complete('Subscription closed');
  //     }
  //   );
  //   connection.debugClose();
  //   await testCompleter.future;
  // });

  // test('multi account subscribe', () async {
  //   final Completer testCompleter = Completer.sync();
  //   const int amount = lamportsPerSol;

  //   final Keypair wallet = utils.wallet;
  //   final int balance = await connection.getBalance(wallet.pubkey);

  //   late List<WebsocketSubscription<AccountInfo>> subscriptions = [];
  //   const int count = 5;
  //   int unsubscribed = 0;
  //   for (int i = 0; i < count; ++i) {
  //     subscriptions.add(
  //       await connection.accountSubscribe(
  //         wallet.pubkey,
  //         onData: (final AccountInfo data) async {
  //           expect(data.lamports, balance + amount);
  //           expect(connection.debugNotifiers.length, 1);
  //           expect(connection.debugSubscriptions.length, 1);
  //           final result = await connection.accountUnsubscribe(subscriptions[i]);
  //           expect(result, true);
  //           ++unsubscribed;
  //           expect(connection.debugNotifiers.isEmpty, true);
  //           expect(unsubscribed < count, connection.debugSubscriptions.length == 1);
  //           expect(unsubscribed == count, connection.debugSubscriptions.isEmpty);
  //           if (unsubscribed == count) testCompleter.complete();
  //         }
  //       ),
  //     );
  //   }
  //   await connection.requestAirdrop(wallet.pubkey, amount);
  //   await testCompleter.future;
  // });

  // test('signature subscribe', () async {
  //   try {
  //     final Keypair wallet = utils.wallet;
  //     final int amount = solToLamports(1).toInt();
  //     final TransactionSignature signature = await connection.requestAirdrop(wallet.pubkey, amount);
  //     final SignatureNotification notification = await connection.signatureSubscribeOnce(
  //       signature,
  //     );
  //     expect(notification.err, null);
  //   } finally {
  //     expect(connection.debugNotifiers.isEmpty, true);
  //     expect(connection.debugSubscriptions.isEmpty, true);
  //   }
  // });

  // test('signature subscribe (error)', () async {
  //   try {
  //     final SignatureNotification notification = await connection.signatureSubscribeOnce(
  //       '2EBVM6cB8vAAD93Ktr6Vd8p67XPbQzCJX47MpReuiCXJAtcjaxpvWpcg9Ege1Nr5Tk3a2GFrByT7WPBjdsTycY9b',
  //       timeLimit: const Duration(seconds: 2)
  //     );
  //     expect(notification.err != null, true);
  //     throw Exception('Timeout expected');
  //   } catch (error) {
  //     print('ERROR $error');
  //     expect(error is TimeoutException, true);
  //   } finally {
  //     print('TEST FINALLY');
  //     expect(connection.debugNotifiers.isEmpty, true);
  //     expect(connection.debugSubscriptions.isEmpty, true);
  //   }
  // });

  // test('signature subscribe (closed)', () async {
  //   try {
  //     final Future<SignatureNotification> notification = connection.signatureSubscribeOnce(
  //       '2EBVM6cB8vAAD93Ktr6Vd8p67XPbQzCJX47MpReuiCXJAtcjaxpvWpcg9Ege1Nr5Tk3a2GFrByT7WPBjdsTycY9b',
  //       timeLimit: const Duration(seconds: 10)
  //     );
  //     await Future.delayed(const Duration(seconds: 1));
  //     connection.debugClose();
  //     await notification;
  //   } catch (error) {
  //     expect(error is WebSocketException, true);
  //   } finally {
  //     expect(connection.debugNotifiers.isEmpty, true);
  //     expect(connection.debugSubscriptions.isEmpty, true);
  //   }
  // });
}