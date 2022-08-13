/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/config/protocol.dart';


/// Clusters
/// ------------------------------------------------------------------------------------------------

class Cluster {

  /// Defines the HTTP and WebSocket urls of a cluster.
  /// 
  /// ```
  /// const String domain = 'api.devnet.solana.com';  // Shared domain
  /// 
  /// Cluster cluster = Cluster._(domain, true);      // Secure
  /// print(cluster.http);                            // 'https://api.devnet.solana.com'
  /// print(cluster.ws);                              // 'wss://api.devnet.solana.com'
  /// 
  /// cluster = Cluster._(domain, false);             // Unsecure
  /// print(cluster.http);                            // 'http://api.devnet.solana.com'
  /// print(cluster.ws);                              // 'ws://api.devnet.solana.com'
  /// ```
  const Cluster._(
    this.domain, [
    this.secure = true,
  ]);

  /// The cluster's domain name (e.g. 'api.devnet.solana.com').
  final String domain;

  /// If true, connect to the cluster's secure endpoint (https or wss).
  final bool secure;

  /// Defines the `devnet` cluster's endpoints.
  static Cluster get devnet => const Cluster._('api.devnet.solana.com');

  /// Defines the `testnet` cluster's endpoints.
  static Cluster get testnet => const Cluster._('api.testnet.solana.com');

  /// Defines the `mainnet` cluster's endpoints.
  static Cluster get mainnet => const Cluster._('api.mainnet-beta.solana.com');

  /// Creates `test validator` endpoints.
  /// 
  /// The default [domain] is `localhost:8899`.
  factory Cluster.localhost([final String? domain, final bool secure = false]) {
    return Cluster._(domain ?? 'localhost:8899', secure);
  }

  /// Creates a url to the cluster for a specific [protocol].
  /// 
  /// ```
  /// final Cluster cluster = Cluster._('api.devnet.solana.com');
  /// print(cluster._endpoint(Protocol.ws));    // 'ws://api.devnet.solana.com'
  /// print(cluster._endpoint(Protocol.wss));   // 'wss://api.devnet.solana.com'
  /// ```
  Uri _endpoint(final Protocol protocol, [final String? path]) {
    return Uri.parse(['${protocol.name}://$domain', path ?? ''].join('/'));
  }

  /// Returns the cluster's HTTP url.
  Uri http([final String? path]) {
    return _endpoint(secure ? Protocol.https : Protocol.http, path);
  }

  /// Returns the cluster's Websocket url.
  Uri ws([final String? path]) {
    return _endpoint(secure ? Protocol.wss : Protocol.ws, path);
  }
}