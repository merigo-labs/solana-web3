/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_common/models.dart';
import 'package:solana_jsonrpc/jsonrpc.dart' as jsonrpc;
import 'json_rpc_params_mixin.dart';


/// JSON RPC Method
/// ------------------------------------------------------------------------------------------------

/// A JSON RPC handler for method calls.
abstract class JsonRpcMethod<S, T> 
  extends jsonrpc.JsonRpcMethod<S, T> 
  with JsonRpcParamsMixin 
{  
  const JsonRpcMethod(
    super.method, {
    final List<Object?>? values,
    this.config,
  }): values = values ?? const [];

  @override
  final List<Object?> values;
  
  @override
  final Serializable? config;
}