/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter/foundation.dart' show protected;
import 'package:solana_common/protocol/json_rpc_subscribe_response.dart';
import 'package:solana_common/utils/types.dart';
import 'package:solana_web3/exceptions/subscription_exception.dart';
import 'web_socket_manager_lookup.dart';
import '../rpc/rpc_notification_response.dart';


/// Web Socket Subscription
/// ------------------------------------------------------------------------------------------------

class WebSocketSubscription<T> {

  /// Stores a web socket stream subscription.
  /// 
  /// Use the [on] method to attach handlers to the stream.
  WebSocketSubscription(
    this.id, {
    required this.exchangeId,
    required final StreamSubscription<T> streamSubscription,
  }): _streamSubscription = streamSubscription,
      createdAt = DateTime.now().toUtc();

  /// The subscription id.
  final int id;

  /// The `subscribe` request/response id.
  final int exchangeId;

  /// The stream subscription.
  @protected
  final StreamSubscription<T> _streamSubscription;

  /// The UTC created date time.
  final DateTime createdAt;

  /// The completer used to convert the subscription into a future.
  Completer<T>? _completer;

  /// Converts the subscription into a future. This will override all methods set by any previous 
  /// calls to [on].
  Future<T> asFuture() {
    Completer<T>? completer = (_completer ??= Completer());
    on(completer.complete, 
      onError: completer.completeError,
      onDone: () => _completeError(completer));
    return completer.future;
  }

  /// Cancels the stream subscription.
  @protected
  Future<void> cancel() {
    _completeError(_completer);
    return _streamSubscription.cancel();
  }

  /// Attaches the provided handlers to the stream subscription.
  void on(
    void Function(T data)? onData, {
    void Function(Object error, [StackTrace? stackTrace])? onError,
    void Function()? onDone,
  }) {
    assert(_completer == null, 'The method [on] cannot be called after a call to [asFuture].');
    _streamSubscription
      ..onData(onData)
      ..onError(onError)
      ..onDone(onDone);
  }

  /// Completes the [completer] with an error.
  void _completeError(
    final Completer<T>? completer, [
    final Object? error, 
    final StackTrace? stackTrace,
  ]) {
    if (completer != null && !completer.isCompleted) {
      completer.completeError(error ?? const SubscriptionException('Cancelled.'), stackTrace);
    }
  }
}


/// Web Socket Subscription Manager
/// ------------------------------------------------------------------------------------------------

class WebSocketSubscriptionManager {

  /// Adds and removes stream listeners for a web socket subscription.
  WebSocketSubscriptionManager();

  /// Maps a subscription `id` to a [StreamController].
  final _subscriptionIdToController = WebSocketManagerLookup<MultiKey<int>, StreamController>();

  /// Returns `true` if there are no subscriptions.
  bool get isEmpty => _subscriptionIdToController.isEmpty;

  /// Returns `true` if there's at least one subscriber.
  bool get isNotEmpty => _subscriptionIdToController.isNotEmpty;

  /// Returns the stream controller for [subscriptionId].
  StreamController<T>? _controller<T>({ required final SubscriptionId subscriptionId })
    => _subscriptionIdToController.at(subscriptionId, index: 0) as StreamController<T>?;

  /// Closes all stream controllers.
  void dispose() {
    for (final controller in _subscriptionIdToController.values) {
      controller.close().ignore();
    }
    _subscriptionIdToController.clear();
  }

  /// Closes the stream controller for [exchangeId].
  Future<void> close({ required final int exchangeId }) {
    final StreamController? controller = _subscriptionIdToController.at(exchangeId, index: 1);
    return controller?.close() ?? Future.value();
  }

  /// Returns true if there's a subscriber on the [Stream].
  bool hasListener(final SubscriptionId subscriptionId) {
    final StreamController? controller = _controller(subscriptionId: subscriptionId);
    return controller != null && controller.hasListener;
  }

  /// Adds a subscriber to the [Stream] associated with the `subscribe` [response].
  WebSocketSubscription<T> subscribe<T>(final JsonRpcSubscribeResponse response) {

    // Debug the response.
    assert(response.id != null, 'The response.id must not be null.');
    assert(response.isSuccess, 'The response must contain a result.');

    // The subscription id.
    final int subscriptionId = response.result!;
    
    // The request/response id.
    final int exchangeId = response.id!;

    // Get or create a stream controller for the subscription.
    StreamController<T>? controller = _controller<T>(subscriptionId: subscriptionId);
    if (controller == null || controller.isClosed) {
      final MultiKey<int> key = MultiKey([subscriptionId, exchangeId]);
      _subscriptionIdToController[key] = controller = StreamController.broadcast(sync: true);
    }
    
    // Create a stream listener.
    return WebSocketSubscription(
      subscriptionId, 
      exchangeId: exchangeId, 
      streamSubscription: controller.stream.listen(null),
    );
  }

  /// Removes a subscriber from the [Stream] associated with the [subscription].
  Future<void> unsubscribe<T>(final WebSocketSubscription<T> subscription) async {
    await subscription.cancel();
    final StreamController? controller = _controller(subscriptionId: subscription.id);
    if(controller != null && !controller.hasListener) {
      assert(controller.stream.isBroadcast);  // close() will never complete for non-broadcast 
      await controller.close();               // streams that are never listened to.
      _subscriptionIdToController.remove(subscription.id);
    }
  }

  /// Sends a [notification] to all stream subscribers.
  void onNotification<T>(final RpcNotificationResponse<T> notification) {
    _controller(subscriptionId: notification.params.subscription)?.add(notification.params.result);
  }

  @override
  String toString() => _subscriptionIdToController.toString();
}