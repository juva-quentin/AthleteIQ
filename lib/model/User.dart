import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String pseudo;
  final String image;
  final String email;
  final List friends;
  final List awaitFriends;
  final List pendingFriendRequests;
  final String sex;
  final double objectif;
  final DateTime createdAt;
  final double totalDist;
  const UserModel({
    required this.id,
    required this.pseudo,
    required this.image,
    required this.email,
    required this.friends,
    required this.awaitFriends,
    required this.pendingFriendRequests,
    required this.sex,
    required this.objectif,
    required this.createdAt,
    required this.totalDist,
  });

  UserModel copyWith({
    String? id,
    String? pseudo,
    String? image,
    String? email,
    List? friends,
    List? awaitFriends,
    List? pendingFriendRequests,
    String? sex,
    double? objectif,
    DateTime? createdAt,
    double? totalDist,
  }) {
    return UserModel(
      id: id ?? this.id,
      pseudo: pseudo ?? this.pseudo,
      image: image ?? this.image,
      email: email ?? this.email,
      friends: friends ?? this.friends,
      awaitFriends: awaitFriends ?? this.awaitFriends,
      pendingFriendRequests: pendingFriendRequests ?? this.pendingFriendRequests,
      sex: sex ?? this.sex,
      objectif: objectif ?? this.objectif,
      createdAt: createdAt ?? this.createdAt,
      totalDist: totalDist ?? this.totalDist,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pseudo': pseudo,
      'image': image,
      'email': email,
      'friends': friends,
      'awaitFriends': awaitFriends,
      'pendingFriendRequests': pendingFriendRequests,
      'sex': sex,
      'objectif': objectif.toDouble(),
      'createdAt': Timestamp.fromDate(createdAt),
      'totalDist': totalDist.toDouble(),
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      pseudo: map['pseudo'] ?? '',
      image: map['image'] ?? '',
      email: map['email'] ?? '',
      friends: map['friends'] ?? [],
      awaitFriends: map['awaitFriends'] ?? [],
      pendingFriendRequests: map['pendingFriendRequests'] ?? [],
      sex: map['sex'] ?? '',
      objectif: map['objectif'].toDouble() ?? 0,
      createdAt: map['createdAt'].toDate(),
      totalDist: map['totalDist'].toDouble() ?? 0,
    );
  }

  factory UserModel.empty() => UserModel(
    id: '',
    pseudo: '',
    image: '',
    email: '',
    friends: [],
    awaitFriends: [],
    pendingFriendRequests: [],
    sex: '',
    objectif: 0,
    createdAt: DateTime.now(),
    totalDist: 0,
  );
}