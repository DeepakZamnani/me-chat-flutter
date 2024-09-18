import 'package:flutter/material.dart';
import 'package:me_chat_update/models/UserPostsModel.dart';

class UserModel {
  final String username;
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final List<String> friends;
  //final String phoneNumber;
  final List<String> groupId;
  final List<Map<String, dynamic>> posts;
  UserModel(
      {required this.username,
      required this.name,
      required this.uid,
      required this.profilePic,
      required this.isOnline,
      required this.groupId,
      required this.friends,
      required this.posts});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      // 'phoneNumber': phoneNumber,
      'groupId': groupId,
      'friends': friends,
      'posts': posts
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        username: map['username'] ?? '',
        name: map['name'] ?? '',
        uid: map['uid'] ?? '',
        profilePic: map['profilePic'] ?? '',
        isOnline: map['isOnline'] ?? false,
        //  phoneNumber: map['phoneNumber'] ?? '',
        groupId: List<String>.from(map['groupId']),
        friends: List<String>.from(map['friends']),
        posts: List<Map<String, dynamic>>.from(map['posts']));
  }
}
