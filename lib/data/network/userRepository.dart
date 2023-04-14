import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../model/User.dart';

final userRepositoryProvider = Provider.autoDispose((ref) => UserRepository());

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> writeUser(UserModel user, {File? file}) async {
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

  Future updateUser(UserModel data) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .update(data.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future updateFriendToFirestore({
     required UserModel dataUserFriend,
      required UserModel dataUser}) async {
    try {
      await _firestore.collection('users').doc(dataUserFriend.id).update(dataUserFriend.toMap());
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .update(dataUser.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<UserModel> get currentUserStream =>
      _firestore.collection('users').doc(_auth.currentUser?.uid).snapshots().map((snapshot) => UserModel.fromFirestore(snapshot));

  Stream<QuerySnapshot<Map<String, dynamic>>> get usersStream => _firestore
      .collection('users')
      .where('id', isNotEqualTo: _auth.currentUser?.uid)
      .snapshots();

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStreamWithID(
      String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  Future<UserModel> getUserWithId({required String userId}) async {
    try {
      var docRef = _firestore.collection('users').doc(userId);
      final result =
          docRef.get().then((value) => UserModel.fromFirestore(value));
      return result;
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getUserWithPseudo({required String pseudo}) async {
    try {
      var docRef =
          _firestore.collection('users').where('pseudo', isEqualTo: pseudo);
      final querySnapshot = await docRef.get();
      final result = querySnapshot.docs
          .map((e) =>
              UserModel.fromFirestore(e.data() as DocumentSnapshot<Object?>))
          .toList();
      return result;
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await _firestore.collection("users").doc(id).delete();
    } on FirebaseException catch (e) {
      rethrow;
    }
  }
}
