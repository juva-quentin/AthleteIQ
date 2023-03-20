import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String pseudo;
  final String image;
  final String email;
  final List friends;
  final String sex;
  final double objectif;
  final DateTime createdAt;
  final double totalDist;
  const User({
    required this.id,
    required this.pseudo,
    required this.image,
    required this.email,
    required this.friends,
    required this.sex,
    required this.objectif,
    required this.createdAt,
    required this.totalDist,
  });

  User copyWith({
    String? id,
    String? pseudo,
    String? image,
    String? email,
    List? friends,
    String? sex,
    double? objectif,
    DateTime? createdAt,
    double? totalDist,
  }) {
    return User(
      id: id ?? this.id,
      pseudo: pseudo ?? this.pseudo,
      image: image ?? this.image,
      email: email ?? this.email,
      friends: friends ?? this.friends,
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
      'sex': sex,
      'objectif': objectif.toDouble(),
      'createdAt': Timestamp.fromDate(createdAt),
      'totalDist': totalDist.toDouble(),
    };
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      pseudo: map['pseudo'] ?? '',
      image: map['image'] ?? '',
      email: map['email'] ?? '',
      friends: map['friends'] ?? [],
      sex: map['sex'] ?? '',
      objectif: map['objectif'].toDouble() ?? 0,
      createdAt: map['createdAt'].toDate(),
      totalDist: map['totalDist'].toDouble() ?? 0,
    );
  }

  factory User.empty() => User(
    id: '',
    pseudo: '',
    image: '',
    email: '',
    friends: [],
    sex: '',
    objectif: 0,
    createdAt: DateTime.now(),
    totalDist: 0,
  );
}