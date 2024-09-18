import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_chat_update/auth/AuthPage.dart';
import 'package:me_chat_update/commons/common_functions.dart';
import 'package:me_chat_update/commons/pallete.dart';
import 'package:me_chat_update/main.dart';
import 'package:me_chat_update/messaging/MessageScreen.dart';
import 'package:me_chat_update/models/UserModel.dart';
import 'package:me_chat_update/commons/static_data.dart';
import 'package:me_chat_update/screens/SearchScreen.dart';
import 'package:me_chat_update/screens/chattrail.dart';
import 'package:me_chat_update/screens/profile_screen.dart';

class FriendProfileScreens extends ConsumerStatefulWidget {
  const FriendProfileScreens({super.key});

  @override
  ConsumerState<FriendProfileScreens> createState() =>
      _FriendProfileScreensState();
}

class _FriendProfileScreensState extends ConsumerState<FriendProfileScreens> {
  @override
  var isFriend = false;
  UserModel? friend;

  Widget build(BuildContext context) {
    // TODO: implement build
    final user = ref.watch(userDataProvider)!;

    void addFriend() async {
      final friend = await getUserFromUid(friendUid);
      final existingList1 = user!.friends;
      final existingList2 = friend!.friends;
      existingList1.add(friend.uid);
      existingList2.add(user.uid);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'friends': existingList1});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(friend.uid)
          .update({'friends': existingList2});
      isFriend = true;
    }

    void removeFriend() async {
      final existingList = user!.friends;
      existingList.remove(await getUserFromUid(friendUid));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'friends': existingList});
      isFriend = false;
    }

    return Scaffold(
      backgroundColor: backgroundColour,
      appBar: AppBar(
        title: Text(friendUsername),
        backgroundColor: backgroundColour,
      ),
      body: FutureBuilder(
          future: getUserFromUid(friendUid),
          builder: (ctx, snapshot) {
            final friend = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height / 3,
                  //color: blueShade,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(friend!.profilePic),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          friend.name.toUpperCase(),
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          addFriend();
                          Navigator.of(context).pop();
                        },
                        child: Text('Add friend')),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => ChatScreen(
                                currentUserUid: user.uid,
                                otherUserUid: friendUid)));
                      },
                      child: Text('Message'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: textColor, width: 10))),
                    child: Expanded(
                      child: FutureBuilder(
                          future: getPostsFromUid(friendUid),
                          builder: (ctx, snapshots) {
                            if (snapshots.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return ListView.builder(
                                itemCount: snapshots.data!.length,
                                itemBuilder: (ctx, index) {
                                  return Image.network(
                                      snapshots.data![index].imageUrl);
                                });
                          }),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
