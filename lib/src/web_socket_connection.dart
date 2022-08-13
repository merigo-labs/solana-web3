/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:solana_web3/src/config/cluster.dart';


/// Web Socket Connection
/// ------------------------------------------------------------------------------------------------

class WebSocketConnection {

  /// Creates a web socket connection to the [cluster].
  WebSocketConnection(
    this.cluster, 
    this.onData, {
    this.onError,
    this.onConnect,
    this.onDisconnect,
  });

  /// The cluster to connect to.
  final Cluster cluster; 

  /// The data callback function.
  final void Function(Map<String, dynamic>)? onData;

  /// The error callback function.
  final void Function(Object error, [StackTrace? stackTrace])? onError;

  /// The connect callback function.
  final void Function(WebSocket connection)? onConnect;

  /// The disconnect callback function.
  final void Function()? onDisconnect;

  /// The connection.
  WebSocket? _connection;

  /// The [_connection] stream subscription.
  StreamSubscription? _subscription;

  /// The [_connection] completer.
  Completer<WebSocket>? _connectionCompleter;

  /// The UTC date time at which the [_connection] was established.
  DateTime? _connectedAt;

  /// Returns true if the socket is open.
  bool get isConnected {
    final WebSocket? connection = _connection;
    return connection != null && connection.readyState == WebSocket.open;
  }

  /// Returns the UTC date time at which the [_connection] was established.
  DateTime? get connectedAt => _connectedAt;

  /// Connects to the web socket [cluster].
  /// 
  /// Calling [connect] multiple times returns the same instance.
  Future<WebSocket> connect() async {
    return _connection ??= await (_connectionCompleter?.future ?? _connect());
  }

  /// Disconnects from the web socket [cluster].
  Future<void> disconnect() async {
    const String reason = '[WebSocketConnection] disconnected.';
    _connection?.close(WebSocketStatus.normalClosure, reason).ignore();
    _subscription?.cancel().ignore();
    _completeError(_connectionCompleter, const WebSocketException(reason));
    _connection = _subscription = _connectionCompleter = _connectedAt = null;
  }

  /// Decodes the web socket [data] into a JSON object and calls the [onData] handler.
  void _onData(final dynamic data) {
    if (data is String && data.isNotEmpty) {
      final Map<String, dynamic> body = json.decode(data);
      onData?.call(body);
    }
  }

  /// Creates a new connection to the web socket [cluster].
  Future<WebSocket> _connect() async {

    // Do not use `await`. Two (or more) calls to connect() will cause the pending connections to 
    // disconnect when dart time slices the async connect() calls.
    disconnect().ignore();

    final Completer<WebSocket> connectionCompleter = Completer.sync();
    _connectionCompleter = connectionCompleter;

    try {
      final WebSocket connection = await WebSocket.connect(cluster.ws().toString());
      connection.pingInterval = const Duration(seconds: 10);
      _connection = connection;
      _subscription = connection.listen(_onData, onError: onError, onDone: onDisconnect);
      _connectedAt = DateTime.now().toUtc();
      onConnect?.call(connection);
      _complete(connectionCompleter, connection);
      return connection;
    } catch (error, stackTrace) {
      onError?.call(error, stackTrace);
      _completeError(connectionCompleter, error, stackTrace);
      return Future<WebSocket>.error(error, stackTrace);
    }
  }

  /// Calls [Completer.complete] at most once with the provided [connection].
  _complete(final Completer<WebSocket>? completer, final WebSocket connection) {
    if (completer != null && !completer.isCompleted) {
      completer.complete(connection);
    }
  }

  /// Calls [Completer.completeError] at most once with the provided connection [error].
  _completeError(
    final Completer<WebSocket>? completer, 
    final Object error, [
    final StackTrace? stackTrace,
  ]) {
    if (completer != null && !completer.isCompleted) {
      completer.completeError(error, stackTrace);
    }
  }
}