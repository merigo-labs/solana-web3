/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/instruction.dart';
import 'package:solana_web3/models/serialisable.dart';
import 'package:solana_web3/utils/convert.dart' as convert show list;


/// Inner Instruction
/// ------------------------------------------------------------------------------------------------

class InnerInstruction extends Serialisable {

  /// The Solana runtime records the cross-program instructions that are invoked during transaction 
  /// processing and makes these available for greater transparency of what was executed on-chain 
  /// per transaction instruction.
  const InnerInstruction({
    required this.index,
    required this.instructions,
  });

  /// The index of the transaction instruction from which the inner instruction(s) originated.
  final num index;

  /// An ordered list of inner program instructions that were invoked during a single transaction 
  /// instruction.
  final List<Instruction> instructions;

  /// Create an instance of this class from the given [json] object.
  /// 
  /// @param [json]: A map containing the class' constructor parameters.
  factory InnerInstruction.fromJson(final Map<String, dynamic> json) => InnerInstruction(
    index: json['index'], 
    instructions: convert.list.decode(json['instructions'], Instruction.fromJson),
  );

  @override
  Map<String, dynamic> toJson() => {
    'index': index,
    'instructions': convert.list.encode(instructions),
  };
}