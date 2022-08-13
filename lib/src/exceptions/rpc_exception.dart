/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/exceptions/library_exception.dart';


/// RPC Exception Code
/// ------------------------------------------------------------------------------------------------

enum RpcExceptionCode {

  serverErrorBlockCleanedUp(-32001),
  serverErrorSendTransactionPreflightFailure(-32002),
  serverErrorTransactionSignatureVerifcationFailure(-32003),
  serverErrorBlockNotAvailable(-32004),
  serverErrorNodeUnhealthy(-32005),
  serverErrorTransactionPrecompileVerificationFailure(-32006),
  serverErrorSlotSkipped(-32007),
  serverErrorNoSnapshot(-32008),
  serverErrorLongTermStorageSlotSkipped(-32009),
  serverErrorKeyExcludedFromSecondaryIndex(-32010),
  serverErrorTransactionHistoryNotAvailable(-32011),
  scanError(-32012),
  serverErrorTransactionSignatureLenMismatch(-32013),
  serverErrorBlockStatusNotAvailableYet(-32014),
  serverErrorUnsupportedTransactionVersion(-32015),
  serverErrorMinContextSlotNotReached(-32016),
  invalidSubscriptionId(-32602),
  ;

  /// Stores the error code's value as a property of the enum variant.
  const RpcExceptionCode(this.value);

  /// The variant's int code.
  final int value;
}


/// RPC Exception
/// ------------------------------------------------------------------------------------------------

class RpcException extends LibraryException {

  /// Creates an exception for a failed JSON-RPC request.
  const RpcException(
    super.message, {
    super.code,
    this.data,
  });

  /// Additional information about the error, defined by the server.
  final dynamic data;

  /// Creates an `unknown` exception for a failed JSON-RPC request.
  factory RpcException.unknown() {
    return const RpcException('JSON-RPC Unknown Exception.');
  }

  /// Returns true if [error] is an [RpcException] for the provided [code].
  static bool isType(Object? error, RpcExceptionCode? code) {
    return error is RpcException && (code == null || error.code == code.value);
  }

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// RpcException.fromJson({ '<parameter>': <value> });
  /// ```
  factory RpcException.fromJson(final Map<String, dynamic> json) => RpcException(
    json['message'],
    code: json['code'], 
    data: json['data'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'message': message,
    'code': code,
    'data': data,
  };
}