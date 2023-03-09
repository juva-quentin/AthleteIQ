import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../model/Groups.dart' as groups;


final GroupsRepositoryProvider = Provider((ref) => GroupsRepository());

class GroupsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> writeGroups(groups.Groups groups, {File? file}) async {
    final ref = _firestore.collection("groups").doc(groups.id.isEmpty ? null : groups.id);
    final refUser = _firestore.collection("users").doc(_auth.currentUser!.uid);

    final String? imageUrl = file != null
        ? await (await _storage.ref("images").child(ref.id).putFile(file))
        .ref
        .getDownloadURL()
        : null;

    try {await ref.set(
      groups.copyWith(groupIcon: imageUrl).toMap(ref.id),
      SetOptions(merge: true),
    );
      await refUser.update({'groups': FieldValue.arrayUnion([ref.id])});
    }catch (e){
      print(e);
    }
  }

  Future updateDataToFirestore(Map<String, dynamic> data, String collectionName, String docName, Ref ref) async {
    try {
      await _firestore.collection(collectionName).doc(docName).update(data);
    }catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> get groupsStream => _firestore
      .collection('groups').doc()
      .snapshots();

  void delete(String id) {
    _firestore.collection("items").doc(id).delete();
  }
}