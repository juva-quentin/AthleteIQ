import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'Timer.dart';

class Parcours {
  final String id;
  final String owner;
  final String title;
  final String description;
  final String type;
  final List shareTo;
  final CustomTimer timer;
  final DateTime createdAt;
  final double VM;
  final double totalDistance;
  final List<LocationData> allPoints;

//<editor-fold desc="Data Methods">
  const Parcours({
    required this.id,
    required this.owner,
    required this.title,
    required this.description,
    required this.type,
    required this.shareTo,
    required this.timer,
    required this.createdAt,
    required this.VM,
    required this.totalDistance,
    required this.allPoints,
  });

  Parcours copyWith({
    String? id,
    String? owner,
    String? title,
    String? description,
    String? type,
    List? shareTo,
    CustomTimer? timer,
    DateTime? createdAt,
    double? VM,
    double? totalDistance,
    List<LocationData>? allPoints,
  }) {
    return Parcours(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      shareTo: shareTo ?? this.shareTo,
      timer: timer ?? this.timer,
      createdAt: createdAt ?? this.createdAt,
      VM: VM ?? this.VM,
      totalDistance: totalDistance ?? this.totalDistance,
      allPoints: allPoints ?? this.allPoints,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'owner': this.owner,
      'title': this.title,
      'description': this.description,
      'type': this.type,
      'shareTo': this.shareTo,
      'timer': this.timer.toMap(),
      'createdAt': this.createdAt,
      'VM': this.VM,
      'totalDistance': this.totalDistance,
      'allPoints': this.allPoints.map((pointItem) {
        return {
          'latitude': pointItem.latitude,
          'longitude': pointItem.longitude,
          'accuracy': pointItem.accuracy,
          'altitude': pointItem.altitude,
          'speed': pointItem.speed,
          'speedAccuracy': pointItem.speedAccuracy,
          'heading': pointItem.heading,
          'time': pointItem.time,
          'isMock': pointItem.isMock,
          'verticalAccuracy': pointItem.verticalAccuracy,
          'headingAccuracy': pointItem.headingAccuracy,
          'elapsedRealtimeNanos': pointItem.elapsedRealtimeNanos,
          'elapsedRealtimeUncertaintyNanos':
              pointItem.elapsedRealtimeUncertaintyNanos,
          'satelliteNumber': pointItem.satelliteNumber,
          'provider': pointItem.provider
        };
      }).toList(),
    };
  }

  factory Parcours.fromFirestore(QueryDocumentSnapshot doc) {

    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    final list =  map['allPoints'];
    List<LocationData> listLocation = [];
    list.map((value){listLocation.add(LocationData.fromMap(value));});
    return Parcours(
      id: doc.id,
      owner: map['owner'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      type: map['type'] as String,
      shareTo: map['shareTo'] as List,
      timer: CustomTimer.fromFirestore(map['timer']),
      createdAt: map['createdAt'].toDate(),
      VM: map['VM'] as double,
      totalDistance: map['totalDistance'] as double,
      allPoints: listLocation
    );
  }

  factory Parcours.empty() => Parcours(
        id: '',
        owner: '',
        title: '',
        description: '',
        type: '',
        shareTo: [],
        timer: CustomTimer.empty(),
        createdAt: DateTime.now(),
        VM: 0,
        totalDistance: 0,
        allPoints: [],
      );
}
