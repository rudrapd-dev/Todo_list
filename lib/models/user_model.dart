import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String bio;
  final String profileImage;
  final Timestamp? createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required this.profileImage,
    this.createdAt,
  });

  /// Empty user
  factory UserModel.empty() {
    return UserModel(
      uid: '',
      name: '',
      email: '',
      phone: '',
      bio: '',
      profileImage: '',
      createdAt: null,
    );
  }

  /// Convert Firestore document to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      bio: map['bio'] ?? '',
      profileImage: map['profileImage'] ?? '',
      createdAt: map['createdAt'],
    );
  }

  /// Convert UserModel to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
      'profileImage': profileImage,
      'createdAt': createdAt,
    };
  }

  /// Create a modified copy of the current user
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? profileImage,
    Timestamp? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}