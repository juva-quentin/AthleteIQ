import 'dart:convert';
import 'dart:io';

import 'package:athlete_iq/model/Parcour.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

final parcourRepositoryProvider =
    Provider.autoDispose((ref) => ParcourRepository());

class ParcourRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> writeParcours(Parcours parcours) async {
    final ref = _firestore
        .collection("parcours")
        .doc(parcours.id.isEmpty ? null : parcours.id);
    try {
      await ref.set(
        parcours.toMap(),
        SetOptions(merge: true),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future updateDataToFirestore(
      Map<String, dynamic> data, String collectionName, String docName) async {
    try {
      await _firestore.collection(collectionName).doc(docName).update(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<Parcours>> get parcoursPublicStream =>
      _firestore
          .collection('parcours')
          .where('type', isEqualTo: "Public")
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((e) => Parcours.fromFirestore(e)).toList());

  MergeStream<List<Parcours>> parcoursProtectedStream() {
    var first = _firestore
        .collection('parcours')
        .where('owner', isEqualTo: _auth.currentUser?.uid)
        .where('type', isEqualTo: "Protected")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => Parcours.fromFirestore(e)).toList());
    var second = _firestore
        .collection('parcours')
        .where('shareTo', arrayContains: _auth.currentUser?.uid)
        .where('type', isEqualTo: "Protected")
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((e) => Parcours.fromFirestore(e)).toList());
    return MergeStream([first, second]);
  }

  Stream<List<Parcours>>
      get parcoursPrivateStream => _firestore
          .collection('parcours')
          .where('owner', isEqualTo: _auth.currentUser?.uid)
          .where('type', isEqualTo: "Private")
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((e) => Parcours.fromFirestore(e)).toList());

  Stream<List<Parcours>> get parcoursStream => _firestore
      .collection('parcours')
      .orderBy('createdAt', descending: true)
      .where('owner', isEqualTo: _auth.currentUser?.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((e) => Parcours.fromFirestore(e)).toList());

  void delete(String id) {
    _firestore.collection("parcours").doc(id).delete();
  }
}
