import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../model/User.dart' as user;
import '../../ui/auth/providers/auth_view_model_provider.dart';

final userRepositoryProvider = Provider.autoDispose((ref) => UserRepository());

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

    try {
      await ref.set(
        user.copyWith(image: imageUrl).toMap(),
        SetOptions(merge: true),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future updateDataToFirestore(
      Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser?.uid).update(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> get userStream =>
      _firestore.collection('users').doc(_auth.currentUser?.uid).snapshots();

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStreamWithID(String userId){
    return  _firestore.collection('users').doc(userId).snapshots();
  }

  Future<user.User> getUserWithId({required String userId}) async {
    var docRef = _firestore.collection('users').doc(userId);
    final result = docRef.get().then((value) => user.User.fromFirestore(value));
    return result;
  }

  void delete(String id) {
    _firestore.collection("users").doc(id).delete();
  }
}
