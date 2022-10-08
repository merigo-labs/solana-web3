/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data';
import 'package:solana_common/models/serializable.dart';
import 'package:solana_common/utils/buffer.dart';
import 'buffer_layout.dart' as buffer_layout;
import 'layout.dart' as layout;
import 'message/message.dart';
import '../exceptions/instruction_exception.dart';


/// Instruction Input Data
/// ------------------------------------------------------------------------------------------------

abstract class InstructionInputData {
  const InstructionInputData(this.instruction);
  final int instruction;
}


/// Instruction Type
/// ------------------------------------------------------------------------------------------------

class InstructionType<T extends buffer_layout.Layout> {
  const InstructionType({
    required this.index, 
    required this.layout,
  });
  /// The Instruction index (from solana upstream program).
  final int index;
  /// The BufferLayout to use to build data.
  final T layout;
}


/// Instruction
/// ------------------------------------------------------------------------------------------------

class Instruction extends Serializable {
  
  /// An instruction to execute by a program.
  const Instruction({
    required this.programIdIndex,
    required this.accounts,
    required this.data,
  });

  /// Index into the [Message.accountKeys] array indicating the program account that executes this 
  /// instruction.
  final int programIdIndex;

  /// List of ordered indices into the message.accountKeys array indicating which accounts to pass 
  /// to the program.
  final Iterable<int> accounts;

   /// The program's input data encoded as a `base-58` string.
  final String data;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// Instruction.fromJson({ '<parameter>': <value> });
  /// ```
  factory Instruction.fromJson(final Map<String, dynamic> json) => Instruction(
    programIdIndex: json['programIdIndex'],
    accounts: Iterable.castFrom(json['accounts']),
    data: json['data'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'programIdIndex': programIdIndex,
    'accounts': accounts,
    'data': data,
  };

  /// Populates a buffer of instruction data using an [InstructionType].
  static Uint8List encodeData<T extends buffer_layout.Layout>(
    InstructionType<T> type, [
    Map<String, dynamic> fields = const {},
  ]) {
    final int allocLength = type.layout.span >= 0 
      ? type.layout.span 
      : layout.getAlloc(type.layout as buffer_layout.StructureLayout, fields);
    final Buffer data = Buffer(allocLength);
    final Map<String, dynamic> layoutFields = { 'instruction': type.index }..addAll(fields);
    type.layout.encode(layoutFields, data);
    return data.asUint8List();
  }

  /// Decodes instruction data buffer using an [InstructionType].
  static Map<String, dynamic> decodeData<T extends buffer_layout.Layout>(
    final InstructionType<T> type,
    final Buffer buffer,
  ) {
    try {
      final Map<String, dynamic>  data = type.layout.decode(buffer);
      final int? instruction = data.remove('instruction');
      if (instruction != type.index) {
        throw 'index mismatch $instruction != ${type.index}';
      }
      return data;
    } catch (error) {
      throw InstructionException('Invalid instruction $error');
    }
  }
}