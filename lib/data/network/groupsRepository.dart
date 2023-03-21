import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/Groups.dart';

final GroupsRepositoryProvider = Provider((ref) => GroupsRepository());

class GroupsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final CollectionReference groupCollection =
  FirebaseFirestore.instance.collection("groups");

  Future<void> writeGroups(Groups group, {File? file}) async {
    final ref =
        _firestore.collection("groups").doc(group.id.isEmpty ? null : group.id);
    final String? imageUrl = file != null
        ? await (await _storage.ref("images").child(ref.id).putFile(file))
        .ref
        .getDownloadURL()
        : null;
    await ref.set(
      group.copyWith(groupIcon: imageUrl).toMap(),
      SetOptions(merge: true),
    );
  }

  Stream<List<Groups>> get groupsStream => _firestore
      .collection('groups')
      .orderBy('recentMessageTime', descending: true)
      .where('members', arrayContains: _auth.currentUser?.uid)
      .snapshots()
      .map((event) => event.docs
          .map(
            (e) => Groups.fromFirestore(e),
          )
          .toList());

  void delete(String id) {
    _firestore.collection("groups").doc(id).delete();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getGroupsStreamById(String id) {
    return _firestore
        .collection('groups').doc(id)
        .snapshots();
  }

  getChats(String groupId) async {
    print(groupId);
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'],
    });
  }
}
