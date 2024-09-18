import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_chat_update/commons/common_functions.dart';
import 'package:me_chat_update/commons/pallete.dart';
import 'package:me_chat_update/auth/AuthPage.dart';
import 'package:me_chat_update/main.dart';
import 'package:me_chat_update/models/UserPostsModel.dart';
import 'package:me_chat_update/screens/SearchScreen.dart';
import 'package:me_chat_update/screens/add_post_screen.dart';
import 'package:me_chat_update/screens/all_friends_screen.dart';
import 'package:me_chat_update/screens/friend_profile_screen.dart';
import 'package:me_chat_update/screens/profile_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

var selectedIndex = 0;

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _HomeScreen();
  }
}

class _HomeScreen extends ConsumerState<HomeScreen> {
  @override
  var title = '';
  Widget build(BuildContext context) {
    Widget currentScreen = Home();
    if (selectedIndex == 4) {
      setState(() {
        currentScreen = Viewprofile();
      });
    }
    if (selectedIndex == 1) {
      setState(() {
        currentScreen = Searchscreen();
        ;
      });
    }
    if (selectedIndex == 3) {
      setState(() {
        currentScreen = AllFriendsScreen();
      });
    }
    if (selectedIndex == 2) {
      setState(() {
        currentScreen = AddPostScreen();
      });
    }

    return Scaffold(
      backgroundColor: backgroundColour,
      bottomNavigationBar: CircleNavBar(
          activeIndex: selectedIndex,
          activeIcons: [
            Icon(Icons.home),
            Icon(Icons.search),
            Icon(Icons.add),
            Icon(Icons.people),
            Icon(Icons.person),
          ],
          inactiveIcons: [
            Icon(Icons.home),
            Icon(Icons.search),
            Icon(Icons.add),
            Icon(Icons.people),
            Icon(Icons.person),
          ],
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          height: 80,
          circleWidth: 80,
          color: Colors.white),
      body: currentScreen,
    );
  }
}

class Home extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _home();
  }
}

class _home extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider);

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 167, 210, 246),
        appBar: AppBar(
          backgroundColor: backgroundColour,
          title: Text('Home'),
        ),
        //   drawer: Viewprofile(),
        body: FutureBuilder(
            future: getPostsList(),
            builder: (ctx, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshots.data!.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        Container(
                            child:
                                Image.network(snapshots.data![index].imageUrl)),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.thumb_up_sharp)),
                          ],
                        )
                      ],
                    );
                  });
            })
        //       : ListView.builder(
        //           //reverse: true,
        //           itemCount: 4,
        //           itemBuilder: (ctx, index) {
        //             return FutureBuilder(
        //                 future: getPostsFromUid(user.friends[index]),
        //                 builder: (context, snapshot) {
        //                   if (snapshot.connectionState == ConnectionState.waiting) {
        //                     return Center(
        //                       child: CircularProgressIndicator(),
        //                     );
        //                   }

        //                   return Container(
        //                     decoration: BoxDecoration(
        //                         color: Colors.white,
        //                         border: Border(
        //                             bottom: BorderSide(
        //                                 width: 2, color: backgroundColour))),
        //                     child: Column(
        //                       children: [
        //                         Padding(
        //                           padding: const EdgeInsets.all(8.0),
        //                           child: FutureBuilder(
        //                               future:
        //                                   getUserFromUid(snapshot.data![index].uid),
        //                               builder: (context, snapshot) {
        //                                 if (snapshot.connectionState ==
        //                                     ConnectionState.waiting) {
        //                                   return Container();
        //                                 }
        //                                 return Row(
        //                                   children: [
        //                                     CircleAvatar(
        //                                       radius: 30,
        //                                       backgroundImage: NetworkImage(
        //                                           snapshot.data!.profilePic),
        //                                     ),
        //                                     const SizedBox(
        //                                       width: 10,
        //                                     ),
        //                                     Text(
        //                                       snapshot.data!.username,
        //                                       style: TextStyle(
        //                                           fontSize: 25,
        //                                           fontWeight: FontWeight.bold),
        //                                     )
        //                                   ],
        //                                 );
        //                               }),
        //                         ),
        //                         Container(
        //                           height: MediaQuery.sizeOf(context).height / 3,
        //                           width: double.infinity,
        //                           decoration: BoxDecoration(
        //                               border: Border.all(
        //                                   width: 5, color: Colors.white)),
        //                           child: Image.network(
        //                             snapshot.data![index].imageUrl,
        //                             fit: BoxFit.fill,
        //                           ),
        //                         ),
        //                         Row(
        //                           children: [
        //                             Icon(
        //                               Icons.heart_broken,
        //                               size: 30,
        //                             ),
        //                             const SizedBox(
        //                               width: 10,
        //                             ),
        //                             Text(
        //                               snapshot.data![index].caption,
        //                               style: TextStyle(fontSize: 15),
        //                             )
        //                           ],
        //                         )
        //                       ],
        //                     ),
        //                   );
        //                 });
        //           }),
        //
        );
  }
}
