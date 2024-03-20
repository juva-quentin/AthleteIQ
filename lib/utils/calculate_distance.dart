import 'dart:math' show asin, atan2, cos, pi, sin, sqrt;

import 'package:google_maps_flutter/google_maps_flutter.dart';

double calculateDistance(LatLng start, LatLng end) {
  const double earthRadius = 6371e3; // Rayon de la Terre en mètres
  double dLat = _degreesToRadians(end.latitude - start.latitude);
  double dLon = _degreesToRadians(end.longitude - start.longitude);

  double lat1 = _degreesToRadians(start.latitude);
  double lat2 = _degreesToRadians(end.latitude);


  double a = sin(dLat/2) * sin(dLat/2) +
      cos(lat1) * cos(lat2) *
          sin(dLon/2) * sin(dLon/2);
  double c = 2 * atan2(sqrt(a), sqrt(1-a));

  double distance = earthRadius * c; // Résultat en mètres
  return distance;
}

double _degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}
