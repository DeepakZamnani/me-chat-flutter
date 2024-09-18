import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_chat_update/auth/AuthPage.dart';
import 'package:me_chat_update/commons/common_functions.dart';
import 'package:me_chat_update/commons/pallete.dart';
import 'package:me_chat_update/commons/static_data.dart';
import 'package:me_chat_update/main.dart';
import 'package:me_chat_update/models/UserPostsModel.dart';

import 'package:me_chat_update/screens/friend_profile_screen.dart';

class Searchscreen extends ConsumerStatefulWidget {
  @override
  Searchscreen({super.key});
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _search();
  }
}

class _search extends ConsumerState<Searchscreen> {
  @override
  bool showUsers = false;
  FocusNode _focus = FocusNode();
  var _controller = TextEditingController();

  void dispose() {
    super.dispose();
    _controller.dispose();
    _focus.dispose();
  }

  Widget build(BuildContext context) {
    // TODO: implement build

    final user = ref.watch(userDataProvider);

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 167, 210, 246),
        appBar: AppBar(
          backgroundColor: backgroundColour,
          //leading: Icon(Icons.search),
          title: TextField(
            //   autofocus: false,
            controller: _controller,
            focusNode: _focus,
            onTap: () {
              _focus.requestFocus();
            },
            onSubmitted: (value) {
              setState(() {
                showUsers = true;
              });
            },
            decoration: InputDecoration(
                fillColor: AppbarColor,
                icon: Icon(Icons.search),
                hintText: 'Search for a User'),
          ),
        ),
        body: showUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('name', isEqualTo: _controller.text)
                    .get(),
                builder: (ctx, snapshot) {
                  // var getdata = snapshot.data as dynamic;
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return ListView.builder(
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (ctx, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              friendUid =
                                  (snapshot.data as dynamic).docs[index]['uid'];
                            });
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => FriendProfileScreens()));
                            print(friendUsername);
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  (snapshot.data as dynamic).docs[index]
                                      ['profilePic']),
                            ),
                            title: Text(
                                (snapshot.data as dynamic).docs[index]['name']),
                          ),
                        );
                      });
                })
            : Container());
  }
}
