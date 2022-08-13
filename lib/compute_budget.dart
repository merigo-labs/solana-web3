/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/buffer_layout.dart' as buffer_layout;
import 'package:solana_web3/public_key.dart';
import 'package:solana_web3/utils/library.dart' show require;
import 'package:solana_web3/web3.dart';


/// Compute Budget Instruction
/// ------------------------------------------------------------------------------------------------

class ComputeBudgetInstruction {
  
  /// Compute budget instruction.
  const ComputeBudgetInstruction();

  /// Decodes a compute budget instruction and retrieve the instruction type.
  static ComputeBudgetInstructionType decodeInstructionType(
    final TransactionInstruction instruction,
  ) {  
    _checkProgramId(instruction.programId);
    final instructionTypeLayout = buffer_layout.u8('instruction');
    final typeIndex = instructionTypeLayout.decode(instruction.data);
    return ComputeBudgetInstructionType.fromIndex(typeIndex); // Throws an exception.
  }

  /// Decodes request units compute budget instruction and retrieves the instruction params.
  static RequestUnitsParams decodeRequestUnits(final TransactionInstruction instruction) {
    _checkProgramId(instruction.programId);
    final Map<String, dynamic> data = Instruction.decodeData(
      ComputeBudgetInstructionLayout.requestUnits(),
      instruction.data,
    );
    return RequestUnitsParams(
      units: data['units'], 
      additionalFee: data['additionalFee'],
    );
  }

  /// Decodes a request heap frame compute budget instruction and retrieves the instruction params.
  static RequestHeapFrameParams decodeRequestHeapFrame(final TransactionInstruction instruction) {
    _checkProgramId(instruction.programId);
    final Map<String, dynamic> data = Instruction.decodeData(
      ComputeBudgetInstructionLayout.requestHeapFrame(),
      instruction.data,
    );
    return RequestHeapFrameParams(data['bytes']);
  }

  /// Decode set compute unit limit compute budget instruction and retrieve the instruction params.
  static SetComputeUnitLimitParams decodeSetComputeUnitLimit(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    final Map<String, dynamic> data = Instruction.decodeData(
      ComputeBudgetInstructionLayout.setComputeUnitLimit(),
      instruction.data,
    );
    return SetComputeUnitLimitParams(data['units']);
  }

  /// Decode set compute unit price compute budget instruction and retrieve the instruction params.
  static SetComputeUnitPriceParams decodeSetComputeUnitPrice(
    final TransactionInstruction instruction,
  ) {
    _checkProgramId(instruction.programId);
    final Map<String, dynamic> data = Instruction.decodeData(
      ComputeBudgetInstructionLayout.setComputeUnitPrice(),
      instruction.data,
    );
    return SetComputeUnitPriceParams(data['microLamports']);
  }

  /// Asserts that [programId] is the [ComputeBudgetProgram.programId].
  /// 
  /// Throws an [AssertionError].
  static _checkProgramId(final PublicKey programId) {
    require(
      programId.equals(ComputeBudgetProgram.programId), 
      'Invalid instruction; programId is not ComputeBudgetProgram',
    );
  }
}


/// Compute Budget Instruction Type
/// ------------------------------------------------------------------------------------------------

enum ComputeBudgetInstructionType {

  // The variants MUST be ordered by their [InstructionType.index].
  requestUnits,           // 0
  requestHeapFrame,       // 1
  setComputeUnitLimit,    // 2
  setComputeUnitPrice,    // 3
  ;

  /// Returns the enum variant where [Enum.index] is equal to [index].
  /// 
  /// Throws an [RangeError] if [index] does not satisy the relations `0` ≤ `index` < 
  /// `values.length`.
  /// 
  /// ```
  /// ComputeBudgetInstructionType.fromIndex(0); // [ComputeBudgetInstructionType.requestUnits]
  /// ComputeBudgetInstructionType.fromIndex(1); // [ComputeBudgetInstructionType.requestHeapFrame]
  /// // ComputeBudgetInstructionType.fromIndex(ComputeBudgetInstructionType.values.length); // Throws RangeError.
  /// ```
  factory ComputeBudgetInstructionType.fromIndex(final int index) => values[index];
}


/// Request Units Params
/// ------------------------------------------------------------------------------------------------

class RequestUnitsParams {

  /// Request units instruction params.
  const RequestUnitsParams({
    required this.units,
    required this.additionalFee,
  });

  /// Units to request for transaction-wide compute.
  final int units;


  /// Prioritization fee lamports.
  final int additionalFee;
}


/// Request Heap Frame Params
/// ------------------------------------------------------------------------------------------------

class RequestHeapFrameParams {

  /// Request heap frame instruction params.
  const RequestHeapFrameParams(this.bytes);

  /// Requested transaction-wide program heap size in bytes. Must be multiple of 1024. Applies to 
  /// each program, including CPIs.
  final int bytes;
}


/// Set Compute Unit Limit Params
/// ------------------------------------------------------------------------------------------------

class SetComputeUnitLimitParams {
  
  /// Set compute unit limit instruction params.
  const SetComputeUnitLimitParams(this.units);
  
  /// Transaction-wide compute unit limit.
  final int units;
}


/// Set Compute Unit Price Params
/// ------------------------------------------------------------------------------------------------

class SetComputeUnitPriceParams {

  // Set compute unit price instruction params.
  const SetComputeUnitPriceParams(this.microLamports);
  
  /// Transaction compute unit price used for prioritization fees.
  final BigInt microLamports;
}


/// Compute Budget Instruction Layout
/// ------------------------------------------------------------------------------------------------

class ComputeBudgetInstructionLayout {
  
  /// Compute budget instruction layout.
  const ComputeBudgetInstructionLayout();

  /// Request units.
  static InstructionType<buffer_layout.Structure> requestUnits() => InstructionType(
    index: 0,
    layout: buffer_layout.struct([
      buffer_layout.u8('instruction'),
      buffer_layout.u32('units'),
      buffer_layout.u32('additionalFee'),
    ]),
  );

  /// Request heap frame.
  static InstructionType<buffer_layout.Structure> requestHeapFrame() => InstructionType(
    index: 1,
    layout: buffer_layout.struct([
      buffer_layout.u8('instruction'), 
      buffer_layout.u32('bytes'),
    ]),
  );

  /// Set compute unit limit.
  static InstructionType<buffer_layout.Structure> setComputeUnitLimit() => InstructionType(
    index: 2,
    layout: buffer_layout.struct([
      buffer_layout.u8('instruction'), 
      buffer_layout.u32('units'),
    ]),
  );

  /// Set compute unit price.
  static InstructionType<buffer_layout.Structure> setComputeUnitPrice() => InstructionType(
    index: 3,
    layout: buffer_layout.struct([
      buffer_layout.u8('instruction'), 
      buffer_layout.nu64('microLamports'),
    ])
  );
}


/// Compute Budget Program
/// ------------------------------------------------------------------------------------------------

class ComputeBudgetProgram {
  
  /// Defines transaction instructions to interact with the Compute Budget program.
  const ComputeBudgetProgram();

  /// The public key that identifies the Compute Budget program.
  static final PublicKey programId = PublicKey.fromString(
    'ComputeBudget111111111111111111111111111111',
  );

  static TransactionInstruction requestUnits({
    required final int units,
    required final int additionalFee,
  }) {
    final type = ComputeBudgetInstructionLayout.requestUnits();
    final data = Instruction.encodeData(type, {
      'units': units,
      'additionalFee': additionalFee,
    });
    return TransactionInstruction(
      keys: [],
      programId: ComputeBudgetProgram.programId,
      data: data,
    );
  }

  static TransactionInstruction requestHeapFrame(final int bytes) {
    final type = ComputeBudgetInstructionLayout.requestHeapFrame();
    final data = Instruction.encodeData(type, { 
      'bytes': bytes,
    });
    return TransactionInstruction(
      keys: [],
      programId: ComputeBudgetProgram.programId,
      data: data,
    );
  }

  static TransactionInstruction setComputeUnitLimit(final int units) {
    final type = ComputeBudgetInstructionLayout.setComputeUnitLimit();
    final data = Instruction.encodeData(type, {
      'units': units,
    });
    return TransactionInstruction(
      keys: [],
      programId: ComputeBudgetProgram.programId,
      data: data,
    );
  }

  static TransactionInstruction setComputeUnitPrice(final BigInt microLamports) {
    final type = ComputeBudgetInstructionLayout.setComputeUnitPrice();
    final data = Instruction.encodeData(type, {
      'microLamports': microLamports,
    });
    return TransactionInstruction(
      keys: [],
      programId: ComputeBudgetProgram.programId,
      data: data,
    );
  }
}