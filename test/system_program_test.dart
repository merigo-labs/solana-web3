/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter_test/flutter_test.dart';
import 'package:solana_web3/src/buffer_layout.dart';
import 'package:solana_web3/src/instruction.dart';
import 'package:solana_web3/programs/system.dart';


/// System Program Tests
/// ------------------------------------------------------------------------------------------------

void main() {

  /// SYSTEM PROGRAM TESTS
  
  test('playground', () {
    // const String source = '9818446744073709551615';
    // final BigInt bigInt = BigInt.parse(source);
    // final Uint8List list = bigInt.toUint8List();
    // print(list);
    // print(BigIntExtension.fromUint8List(list));
    // print(BigIntExtension.fromUint8List(list).toString() == source);
    // print(BigIntExtension.fromUint8List(list).asSigned());
    // print(BigIntExtension.fromUint8List(list).toSigned(list.length * 8));
    // print(BigIntExtension.fromUint8List(list).asSigned().toString() == source);
  });


  test('system instruction type', () {
    final int length = SystemInstructionType.values.length;
    for (int i = 0; i < length; ++i) {
      SystemInstructionType.fromIndex(i);
    }
  });

  void _testInstructionType(InstructionType<Structure> layout, SystemInstructionType type) {
    assert(
      layout.index == type.index, 
      '[InstructionType.index] does not match [SystemInstructionType.index]',
    );
  }

  test('instruction instruction layout', () {
    for (final SystemInstructionType type in SystemInstructionType.values) {
      switch(type) {
        case SystemInstructionType.create:
          _testInstructionType(SystemInstructionLayout.create(), type);
          break;
        case SystemInstructionType.assign:
          _testInstructionType(SystemInstructionLayout.assign(), type);
          break;
        case SystemInstructionType.transfer:
          _testInstructionType(SystemInstructionLayout.transfer(), type);
          break;
        case SystemInstructionType.createWithSeed:
          _testInstructionType(SystemInstructionLayout.createWithSeed(), type);
          break;
        case SystemInstructionType.advanceNonceAccount:
          _testInstructionType(SystemInstructionLayout.advanceNonceAccount(), type);
          break;
        case SystemInstructionType.withdrawNonceAccount:
          _testInstructionType(SystemInstructionLayout.withdrawNonceAccount(), type);
          break;
        case SystemInstructionType.initializeNonceAccount:
          _testInstructionType(SystemInstructionLayout.initializeNonceAccount(), type);
          break;
        case SystemInstructionType.authorizeNonceAccount:
          _testInstructionType(SystemInstructionLayout.authorizeNonceAccount(), type);
          break;
        case SystemInstructionType.allocate:
          _testInstructionType(SystemInstructionLayout.allocate(), type);
          break;
        case SystemInstructionType.allocateWithSeed:
          _testInstructionType(SystemInstructionLayout.allocateWithSeed(), type);
          break;
        case SystemInstructionType.assignWithSeed:
          _testInstructionType(SystemInstructionLayout.assignWithSeed(), type);
          break;
        case SystemInstructionType.transferWithSeed:
          _testInstructionType(SystemInstructionLayout.transferWithSeed(), type);
          break;
        case SystemInstructionType.upgradeNonceAccount:
          _testInstructionType(SystemInstructionLayout.upgradeNonceAccount(), type);
          break;
      }
    }
  });

}
