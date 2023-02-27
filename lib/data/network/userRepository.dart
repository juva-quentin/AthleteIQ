import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../model/User.dart' as user;
import '../../ui/auth/providers/auth_view_model_provider.dart';

final UserRepositoryProvider = Provider((ref) => UserRepository());

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> writeUser(user.User user, {File? file}) async {
    final ref =
    _firestore.collection("users").doc(user.id.isEmpty ? null : user.id);
    final String? imageUrl = file != null
        ? await (await _storage.ref("images").child(ref.id).putFile(file))
        .ref
        .getDownloadURL()
        : null;

    try {await ref.set(
      user.copyWith(image: imageUrl).toMap(),
      SetOptions(merge: true),
    );}catch (e){
      print(e);
    }
  }

  Future updateDataToFirestore(Map<String, dynamic> data, String collectionName, String docName) async {
    try {
     await _firestore.collection(collectionName).doc(docName).update(data);
    }catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Stream<user.User> get userStream => _firestore
      .collection('users').doc(_auth.currentUser!.uid)
      .snapshots()
      .map(
        (event) => user.User.fromFirestore(event),
  );

  void delete(String id) {
    _firestore.collection("items").doc(id).delete();
  }

}