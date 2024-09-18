import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:me_chat_update/auth/AuthPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:me_chat_update/commons/common_functions.dart';
import 'package:me_chat_update/commons/pallete.dart';

//Edit Profile Section
class ProfileScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    {
      return _profile();
    }
  }
}

class _profile extends ConsumerState<ProfileScreen> {
  @override
  var isEditablle = false;
  var controller = TextEditingController();
  ImagePicker picker = ImagePicker();

  File? image;
  void pickImage() async {
    final user = ref.watch(userDataProvider);
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedImage!.path);
    });
    //print(image!.path);
    try {
      final storgeRef =
          await FirebaseStorage.instance.ref().child('${user!.uid}.jpg');
      await storgeRef.putFile(
          image!, SettableMetadata(contentType: 'image/jpeg'));
      final imgUrl = await storgeRef.getDownloadURL();
      final userinfo = ref.watch(userProvider);
      userinfo.doc(user.uid).update({'profilePic': imgUrl});
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  void captureImage() async {
    final user = ref.watch(userDataProvider);
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      image = File(pickedImage!.path);
    });
    //print(image!.path);
    try {
      final storgeRef =
          await FirebaseStorage.instance.ref().child('${user!.uid}.jpg');
      await storgeRef.putFile(
          image!, SettableMetadata(contentType: 'image/jpeg'));
      final imgUrl = await storgeRef.getDownloadURL();
      final userinfo = ref.watch(userProvider);
      userinfo.doc(user.uid).update({'profilePic': imgUrl});
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    final user = ref.watch(userDataProvider)!;
    String username = user.name;

    Widget textEditor;
    final userRef = ref.watch(userProvider);
    var key = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Profile'),
        ),
        body: Center(
          child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  // pickImage();
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return Dialog(
                          child: Container(
                            height: 165,
                            padding: EdgeInsets.all(25),
                            child: Column(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    captureImage();
                                  },
                                  label: Text('Camera'),
                                  icon: Icon(Icons.camera),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    pickImage();
                                  },
                                  label: Text('Gallery'),
                                  icon: Icon(Icons.photo_album),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Stack(children: [
                  Opacity(
                      opacity: 0.4,
                      child: CircleAvatar(
                        radius: 90,
                        //  child: ,
                        backgroundImage: NetworkImage(user.profilePic),
                      )),
                  Positioned(
                      top: 80,
                      left: 75,
                      child: Icon(
                        Icons.edit,
                        size: 35,
                        color: Colors.black,
                      ))
                ]),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                  width: 300,
                  child: isEditablle
                      ? Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                maxLength: 8,
                                decoration:
                                    InputDecoration(hintText: 'Username'),
                                controller: controller,
                                autofocus: true,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                onPressed: () {
                                  print(username);
                                  if (isEditablle == false) {
                                    isEditablle = true;
                                  } else {
                                    setState(() {
                                      username = controller.text;
                                      final userinfo = ref.watch(userProvider);
                                      userinfo
                                          .doc(user.uid)
                                          .update({'name': controller.text});
                                      isEditablle = false;
                                    });
                                  }
                                },
                                icon: Icon(Icons.done))
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (isEditablle == false) {
                                      isEditablle = true;
                                    } else {
                                      isEditablle = false;
                                    }
                                  });
                                },
                                icon: Icon(Icons.edit))
                          ],
                        )),
            ],
          ),
        ));
  }
}

//Viewing the profile
class Viewprofile extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _profileV();
  }
}

class _profileV extends ConsumerState<Viewprofile> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider)!;
    // TODO: implement build
    return Scaffold(
        endDrawer: ProfileDrawer(),
        backgroundColor: Color.fromARGB(255, 167, 210, 246),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 10, color: textColor))),
              height: MediaQuery.sizeOf(context).height / 2.2,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).height / 4,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(80)),
                        color: Color.fromARGB(255, 101, 170, 249)),
                  ),
                  Positioned(
                    left: 28,
                    top: 100,
                    child: Container(
                      height: MediaQuery.sizeOf(context).height / 3.3,
                      width: MediaQuery.sizeOf(context).width / 1.2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: Stack(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Positioned(
                            top: MediaQuery.sizeOf(context).height / 40,
                            left: MediaQuery.sizeOf(context).width / 4.2,
                            child: Center(
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(
                                  user.profilePic,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Positioned(
                            //top: MediaQuery.sizeOf(context).height / 4.6,
                            //left: MediaQuery.sizeOf(context).width / 3.5,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 120.0),
                              child: Center(
                                child: Text(
                                  user.name ?? 'Error',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: textColor),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 30,
                            right: MediaQuery.sizeOf(context).width / 18,
                            child: InkWell(
                              child: Icon(
                                Icons.edit,
                                color: textColor,
                                size: 30,
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => ProfileScreen()));
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 100,
                color: Colors.white,
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / user.posts.length),
                    itemBuilder: (ctx, inddex) {
                      return FutureBuilder(
                          future: getPostsFromUid(user.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            }
                            return user.posts.length < (inddex + 1)
                                ? Container()
                                : Image.network(
                                    snapshot.data![inddex].imageUrl,
                                    fit: BoxFit.fill,
                                    height:
                                        MediaQuery.sizeOf(context).width / 10,
                                    width: MediaQuery.sizeOf(context).width / 2,
                                  );
                          });
                    }),
              ),
            ),
          ],
        ));
  }
}

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              //style: ,
              hoverColor: backgroundColour,
              contentPadding: EdgeInsets.only(left: 20, right: 20, top: 10),
              leading: Icon(
                Icons.settings,
                color: textColor,
                size: 40,
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                    color: textColor,
                    fontSize: 23,
                    fontWeight: FontWeight.w700),
              ),
            ),
            // const Spacer(),
            ListTile(
              //style: ,
              //hoverColor: backgroundColour,
              contentPadding: EdgeInsets.only(left: 20, right: 20, top: 10),
              leading: Icon(
                color: textColor,
                Icons.logout,
                size: 40,
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              title: Text(
                'Log Out',
                style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }
}
