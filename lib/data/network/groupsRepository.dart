import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/Groups.dart';

final groupsRepositoryProvider =
    Provider.autoDispose((ref) => GroupsRepository());

class GroupsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  Future<void> writeGroups(Groups group, {File? file}) async {
    try {
      final ref = _firestore
          .collection("groups")
          .doc(group.id.isEmpty ? null : group.id);
      final String? imageUrl = file != null
          ? await (await _storage.ref("images").child(ref.id).putFile(file))
              .ref
              .getDownloadURL()
          : null;
      await ref.set(
        group.copyWith(groupIcon: imageUrl).toMap(),
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  Stream<List<Groups>> get myGroupsStream => _firestore
      .collection('groups')
      .orderBy('recentMessageTime', descending: true)
      .where('members', arrayContains: _auth.currentUser?.uid)
      .snapshots()
      .map((event) => event.docs
          .map(
            (e) => Groups.fromFirestore(e),
          )
          .toList());

  Future<void> deleteGroup(String id) async {
    try {
      await _firestore.collection("groups").doc(id).delete();
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  Future<Groups> getGroupById(String id) async{
    try {
      var docRef = _firestore.collection('groups').doc(id);
      final result =
      docRef.get().then((value) => Groups.fromFirestore(value));
      return result;
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getmyGroupsStreamById(
      String id) {
    return _firestore.collection('groups').doc(id).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get groupsStream => _firestore
      .collection('groups')
      .where('type', isEqualTo: "Public")
      .snapshots();

  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'],
    });
  }

  Future<void> updateGroup(String groupId, Groups group, {File? file}) async {
    try {
      final String? imageUrl = file != null
          ? await (await _storage.ref("images").child(groupId).putFile(file))
              .ref
              .getDownloadURL()
          : null;
      imageUrl == null ? null : group.copyWith();
      await groupCollection.doc(groupId).update(
          (imageUrl == null ? group : group.copyWith(groupIcon: imageUrl))
              .toMap());
    } on FirebaseException catch (e) {
      rethrow;
    }
  }
}
