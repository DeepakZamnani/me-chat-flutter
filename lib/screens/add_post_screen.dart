import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:me_chat_update/auth/AuthPage.dart';
import 'package:me_chat_update/commons/RequiredWidgets.dart';
import 'package:me_chat_update/commons/common_functions.dart';
import 'package:me_chat_update/commons/pallete.dart';
import 'package:me_chat_update/main.dart';
import 'package:me_chat_update/models/UserPostsModel.dart';
import 'package:me_chat_update/screens/HomeScree.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  @override
  var caption = '';
  File? _file;
  TextEditingController _captionController = TextEditingController();

  void pickpostImage() {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: TextButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    File file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  },
                  label: Text('Camera'),
                  icon: Icon(Icons.camera),
                ),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: TextButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    File file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  },
                  label: Text('Gallery'),
                  icon: Icon(Icons.photo),
                ),
              )
            ],
          );
        });
  }

  void postImage(String uid) async {
    try {
      final storageRef =
          await FirebaseStorage.instance.ref().child('${_file!.path}.jpg');
      await storageRef.putFile(_file!);
      final imageUrl = await storageRef.getDownloadURL();
      uploadPost(uid, caption, imageUrl, 0);
      showSnackBar(text: 'Posted Succesfully!');
      // irestore.collection('feed').doc('posts').set()
    } catch (e) {
      showSnackBar(
        text: e.toString(),
      );
    }
  }

  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider);
    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () {
                  pickpostImage();
                },
                icon: Icon(Icons.upload)),
          )
        : Scaffold(
            backgroundColor: backgroundColour,
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 101, 170, 249),
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      _file = null;
                    });
                  },
                  icon: Icon(Icons.arrow_back)),
              title: Text('Create a new post'),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        caption = _captionController.text;
                        postImage(user!.uid);
                      });
                    },
                    child: Text(
                      'Post',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ))
              ],
            ),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(user!.profilePic)),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 70,
                  child: TextField(
                    controller: _captionController,
                    maxLines: 8,
                    decoration: InputDecoration(
                        hintText: 'Enter a caption.....',
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  height: 45,
                  width: 45,
                  child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                          decoration: BoxDecoration(
                        image: DecorationImage(
                            alignment: FractionalOffset.topCenter,
                            fit: BoxFit.fill,
                            image: FileImage(_file!)),
                      ))),
                ),
                const Divider()
              ],
            ));
  }
}
