/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter_test/flutter_test.dart';
import 'package:solana_web3/rpc_models/slot_notification.dart';


/// Playground Tests
/// ------------------------------------------------------------------------------------------------

void main() {

  test('playground', () async {
    final jsonData = {
      "parent": 75,
      "root": 44,
      "slot": 76
    };
    final instance = SlotNotification.fromJson(jsonData);
    print(instance.toJson());
  });
}