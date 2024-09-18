import 'dart:core';
import 'dart:io';
import 'package:me_chat_update/models/UserPostsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:me_chat_update/main.dart';
import 'package:me_chat_update/models/UserModel.dart';

Future<UserModel> getUserFromUid(String Uid) async {
  DocumentSnapshot snapshot =
      await firestore.collection('users').doc(Uid).get();
  return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
}

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await File(file.path);
  }
}

Future<List<UserPosts>> getPostsFromUid(String uid) async {
  List<UserPosts> postList = [];
  var snapshot = await getUserFromUid(uid);
  for (Map<String, dynamic> map in snapshot.posts) {
    UserPosts posts = UserPosts.fromMap(map);
    postList.add(posts);
  }
  return postList;
}
