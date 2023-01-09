/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:typed_data' show Uint8List;
import 'package:solana_common/utils/convert.dart' as convert show base58;
import 'message.dart';
import '../instruction.dart';
import 'package:solana_common/models/serializable.dart';
import '../utils/shortvec.dart' as shortvec;


/// Message Instruction
/// ------------------------------------------------------------------------------------------------

class MessageInstruction extends Serializable {

  /// Message instruction.
  MessageInstruction({
    required this.programIdIndex,
    required this.keyIndicesCount,
    required this.keyIndices,
    required this.dataLength,
    required this.data,
  });

  /// Index into the [Message.accountKeys] array indicating the program account that executes this 
  /// instruction.
  final int programIdIndex;

  /// The `shortvec` encoded length of [Instruction.accounts].
  final Uint8List keyIndicesCount;

  /// The [Instruction.accounts] indices.
  final Iterable<int> keyIndices;
  
  /// The `shortvec` encoded length of [data].
  final Uint8List dataLength;

  // The program's decoded input data.
  final Uint8List data;

  /// Creates an instance of this class from an [instruction].
  factory MessageInstruction.fromInstruction(final Instruction instruction) {
    final Uint8List data = convert.base58.decode(instruction.data);
    return MessageInstruction(
      programIdIndex: instruction.programIdIndex, 
      keyIndicesCount: Uint8List.fromList(shortvec.encodeLength(instruction.accounts.length)), 
      keyIndices: instruction.accounts, 
      dataLength: Uint8List.fromList(shortvec.encodeLength(data.length)), 
      data: data,
    );
  }

  /// {@macro solana_common.Serializable.fromJson}
  factory MessageInstruction.fromJson(final Map<String, dynamic> json) => MessageInstruction(
    programIdIndex: json['programIdIndex'],
    keyIndicesCount: json['keyIndicesCount'],
    keyIndices: json['keyIndices'],
    dataLength: json['dataLength'],
    data: json['data'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'programIdIndex': programIdIndex,
    'keyIndicesCount': keyIndicesCount,
    'keyIndices': keyIndices,
    'dataLength': dataLength,
    'data': data,
  };
}