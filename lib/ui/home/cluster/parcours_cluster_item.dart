import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParcoursClusterItem implements ClusterItem {
  final String id;
  final LatLng position;
  final BitmapDescriptor icon;
  final String title;
  final String snippet;
  final List<LatLng> allPoints;

  ParcoursClusterItem({
    required this.id,
    required this.position,
    required this.icon,
    required this.title,
    required this.snippet,
    required this.allPoints,
  });

  @override
  LatLng get location => position;

  @override
  String get geohash => Geohash.encode(position);
}
