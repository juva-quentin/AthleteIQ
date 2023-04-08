

import 'package:cloud_firestore/cloud_firestore.dart';

class Groups {
  final String id;
  final String admin;
  final String groupIcon;
  final String groupName;
  final List members;
  final String type;
  final String recentMessage;
  final String recentMessageSender;
  final DateTime recentMessageTime;

  const Groups({
    required this.id,
    required this.admin,
    required this.groupIcon,
    required this.groupName,
    required this.members,
    required this.type,
    required this.recentMessage,
    required this.recentMessageSender,
    required this.recentMessageTime,
  });

  Groups copyWith({
    String? id,
    String? admin,
    String? groupIcon,
    String? groupName,
    List? members,
    String? type,
    String? recentMessage,
    String? recentMessageSender,
    DateTime? recentMessageTime,
  }) {
    return Groups(
      id: id ?? this.id,
      admin: admin ?? this.admin,
      groupIcon: groupIcon ?? this.groupIcon,
      groupName: groupName ?? this.groupName,
      members: members ?? this.members,
      type: type ?? this.type,
      recentMessage: recentMessage ?? this.recentMessage,
      recentMessageSender: recentMessageSender ?? this.recentMessageSender,
      recentMessageTime: recentMessageTime ?? this.recentMessageTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'admin': admin,
      'groupIcon': groupIcon,
      'groupName': groupName,
      'members': members,
      'type': type,
      'recentMessage': recentMessage,
      'recentMessageSender': recentMessageSender,
      'recentMessageTime': Timestamp.fromDate(recentMessageTime),
    };
  }

  factory Groups.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Groups(
      id: doc.id,
      admin: map['admin'] ?? '',
      groupIcon: map['groupIcon'] ?? '',
      groupName: map['groupName'] ?? '',
      members: map['members'] ?? [],
      type: map['type'] ?? '',
      recentMessage: map['recentMessage'] ?? '',
      recentMessageSender: map['recentMessageSender'] ?? '',
      recentMessageTime: map['recentMessageTime'].toDate(),
    );
  }

  factory Groups.empty() => Groups(
    id: '',
    admin: '',
    groupIcon: '',
    groupName: '',
    members: [],
    type: 'Public',
    recentMessage: '',
    recentMessageSender: '',
    recentMessageTime: DateTime.now(),
  );

}