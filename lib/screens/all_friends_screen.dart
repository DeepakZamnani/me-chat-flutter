import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_chat_update/auth/AuthPage.dart';
import 'package:me_chat_update/commons/common_functions.dart';
import 'package:me_chat_update/commons/pallete.dart';
import 'package:me_chat_update/main.dart';
import 'package:me_chat_update/models/UserModel.dart';
import 'package:me_chat_update/commons/static_data.dart';
import 'package:me_chat_update/screens/friend_profile_screen.dart';

class AllFriendsScreen extends ConsumerStatefulWidget {
  const AllFriendsScreen({super.key});

  @override
  ConsumerState<AllFriendsScreen> createState() => _AllFriendsScreenState();
}

class _AllFriendsScreenState extends ConsumerState<AllFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider)!;

    return Scaffold(
      backgroundColor: backgroundColour,
      appBar: AppBar(
        backgroundColor: backgroundColour,
        title: Text('All friends'),
      ),
      body: user.friends.isEmpty
          ? Center(child: Text('Add some friends'))
          : ListView.builder(
              itemCount: user.friends.length,
              itemBuilder: (ctx, index) {
                //  UserModel friend = UserModel.fromMap(user.friends[index]);

                return FutureBuilder(
                    future: getUserFromUid(user.friends[index]),
                    builder: (context, snapshot) {
                      final friend = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(friend!.profilePic),
                          ),
                          title: Text(friend.username),
                          onTap: () {
                            setState(() {
                              friendProfile = friend.profilePic;
                              friendUsername = friend.username;
                              friendUid = friend.uid;
                            });
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => FriendProfileScreens()));
                          },
                        );
                      }
                      return Center(child: Text('Add some friends'));
                    });
              }),
    );
  }
}
