/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_web3/src/models/serialisable.dart';
import 'package:solana_web3/src/utils/types.dart' show u16, u32;


/// Cluster Node
/// ------------------------------------------------------------------------------------------------

class ClusterNode extends Serialisable {
  
  /// Information about a cluster node.
  const ClusterNode({
    required this.pubkey,
    required this.gossip,
    required this.tpu,
    required this.rpc,
    required this.version,
    required this.featureSet,
    required this.shredVersion,
  });

  /// The node's public key, as base-58 encoded string.
  final String pubkey;

  /// The node's gossip network address.
  final String? gossip;

  /// The node's TPU network address.
  final String? tpu;

  /// The node's JSON RPC network address, or null if the JSON RPC service is not enabled.
  final String? rpc;
  
  /// The node's software version, or null if the version information is not available.
  final String? version;
  
  /// The unique identifier of the node's feature set.
  final u32? featureSet;
  
  /// The shred version the node has been configured to use.
  final u16? shredVersion;

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// ```
  /// ClusterNode.fromJson({ '<parameter>': <value> });
  /// ```
  factory ClusterNode.fromJson(final Map<String, dynamic> json) => ClusterNode(
    pubkey: json['pubkey'],
    gossip: json['gossip'],
    tpu: json['tpu'],
    rpc: json['rpc'],
    version: json['version'],
    featureSet: json['featureSet'],
    shredVersion: json['shredVersion'],
  );

  /// Creates an instance of `this` class from the constructor parameters defined in the [json] 
  /// object.
  /// 
  /// Returns `null` if [json] is omitted.
  /// 
  /// ```
  /// ClusterNode.fromJson({ '<parameter>': <value> });
  /// ```
  static ClusterNode? tryFromJson(final Map<String, dynamic>? json) {
    return json != null ? ClusterNode.fromJson(json) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
    'pubkey': pubkey,
    'gossip': gossip,
    'tpu': tpu,
    'rpc': rpc,
    'version': version,
    'featureSet': featureSet,
    'shredVersion': shredVersion,
  };
}