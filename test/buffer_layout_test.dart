/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter_test/flutter_test.dart';
import 'package:solana_web3/src/buffer.dart';
import 'package:solana_web3/src/buffer_layout.dart';
import 'package:solana_web3/src/config/account_filter.dart';
import 'package:solana_web3/src/config/commitment.dart';
import 'package:solana_web3/src/rpc_config/get_largest_accounts_config.dart';
import 'package:solana_web3/src/rpc_config/get_supply_config.dart';
import 'package:solana_web3/src/rpc_config/send_transaction_config.dart';


/// Buffer Layout Tests
/// ------------------------------------------------------------------------------------------------

void main() {

  bool shouldThrow(final Function test) {
    try {
      test();
      return false;
    } catch (_) {
      return true;
    }
  }

  test('create a zero initialised buffer', () {
    final SendTransactionConfig config = SendTransactionConfig(
      preflightCommitment: null,
    );
    print(config.object());     //  {
                                //    ...,
                                //    'preflightCommitment': null,
                                //  }

    final SendTransactionConfig configCopy = config.applyDefault(
      preflightCommitment: Commitment.finalized,
    );
    print(configCopy.object()); //  {
                                //    ...,
                                //    'preflightCommitment': 'finalized',
                                //  }
    // final e = ns64;
    // const int bytes = 8;
    
    // final Buffer buffer = Buffer(bytes);
    // final int maxValue = 9007199254740991;//maxInt64;// pow(2, bytes*8).toInt() - 1;
    
    // print('Max $maxValue');
    // final int minValue = 0;
    // print('Min $minValue');
    // final int maxResult = e().encode(maxValue, buffer);
    // assert(maxResult == bytes);
    // print('Max Buffer $buffer');
    // // final int minResult = e().encode(minValue, buffer);
    // // assert(minResult == bytes);
    // // print('Min Buffer $buffer');
    // // final int result = e().encode(7687786, buffer);
    // // assert(result == bytes);
    // // print('Reg Buffer $buffer');
    // //assert(shouldThrow(() => e().encode(-1, buffer)));
    // //assert(shouldThrow(() => e().encode(maxValue+1, buffer)));
    // print('\nBUFFER CHECK ${e().decode(buffer)}');
  });
}