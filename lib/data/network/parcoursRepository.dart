import 'dart:convert';
import 'dart:io';

import 'package:athlete_iq/model/Parcour.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final parcourRepositoryProvider = Provider((ref) => ParcourRepository());

class ParcourRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> writeParcours(Parcours parcours) async {
    final ref =
    _firestore.collection("parcours").doc(parcours.id.isEmpty ? null : parcours.id);

    try {
      await ref.set(
        parcours.toMap(),
        SetOptions(merge: true),
      );
    } catch (e) {
      print(e);
    }
  }

  Future updateDataToFirestore(
      Map<String, dynamic> data, String collectionName, String docName) async {
    try {
      await _firestore.collection(collectionName).doc(docName).update(data);
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get parcoursPublicStream =>
      _firestore.collection('parcours').where('type', isEqualTo: "public").snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> get parcoursProtectedStream =>
      _firestore.collection('parcours').where('type', isEqualTo: "protected").snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> get parcoursPrivateStream =>
      _firestore.collection('parcours').where('type', isEqualTo: "private").snapshots();


  void delete(String id) {
    _firestore.collection("parcours").doc(id).delete();
  }
}
