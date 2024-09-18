import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:me_chat_update/commons/common_functions.dart';
import 'package:me_chat_update/main.dart';

class UserPosts {
  final String imageUrl;
  final String caption;
  final String uid;
  final int likes;
  UserPosts(
      {required this.uid,
      required this.imageUrl,
      required this.caption,
      required this.likes});

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'caption': caption,
      'uid': uid,
      'likes': likes
    };
  }

  factory UserPosts.fromMap(Map<String, dynamic> map) {
    return UserPosts(
        uid: map['uid'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        caption: map['caption'],
        likes: map['likes'] ?? 0);
  }
}

Future<List<UserPosts>> getPostsList() async {
  List<UserPosts> postsList = [];
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('feed').get();

    snapshot.docs.forEach((docs) {
      UserPosts post = UserPosts.fromMap(docs.data());
      postsList.add(post);
    });
    return postsList;
  } catch (e) {
    return [];
  }
}

uploadPost(String uid, String caption, String imgUrl, int likes) async {
  final user = await getUserFromUid(uid);
  List<Map<String, dynamic>> prevPosts = user.posts;
  UserPosts post =
      UserPosts(uid: uid, imageUrl: imgUrl, caption: caption, likes: likes);
  prevPosts.add(post.toMap());
  firestore.collection('feed').add(post.toMap());
  firestore.collection('users').doc(uid).update({'posts': prevPosts});
}
