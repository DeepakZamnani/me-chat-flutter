//import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:me_chat_update/commons/RequiredWidgets.dart';
import 'package:me_chat_update/commons/pallete.dart';

//import 'package:me_chat_update/models/UserData.dart';
import 'package:me_chat_update/models/UserModel.dart';

import 'package:me_chat_update/screens/HomeScree.dart';
import 'package:routemaster/routemaster.dart';
import 'AuthScreen.dart';

var defaultProfile =
    'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

final AuthRepositoryProvider =
    StateNotifierProvider<AuthRepository, bool>((ref) => AuthRepository());
final AuthStateProvider = StreamProvider((ref) {
  return ref.watch(AuthRepositoryProvider.notifier).authStatechange;
});
final userProvider = Provider((ref) {
  return ref.watch(AuthRepositoryProvider.notifier)._users;
});
final uidProvider = Provider((ref) {
  return ref.watch(AuthRepositoryProvider.notifier).userid;
});
final userDataProvider = StateProvider<UserModel?>((ref) {
  return null;
});
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
GoogleSignIn signIn = GoogleSignIn();

class AuthRepository extends StateNotifier<bool> {
  Stream<User?> get authStatechange => auth.authStateChanges();
  CollectionReference get _users => _firestore.collection('users');
  String userid = '';
  AuthRepository() : super(false);

  void CreateUserWithEmail(String email, String password, String name) async {
    try {
      state = true;
      final userCred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await auth.signInWithEmailAndPassword(email: email, password: password);

      userid = userCred.user!.uid;
      UserModel model = UserModel(
          posts: [],
          username: name.replaceAll(' ', ''),
          name: name,
          uid: userCred.user!.uid,
          profilePic: defaultProfile,
          isOnline: true,
          groupId: [],
          friends: []);
      await _users.doc(userCred.user!.uid).set(model.toMap());
      state = false;
      print(userCred.user!.uid);
    } on FirebaseAuthException catch (e) {
      showSnackBar(text: e.message!);
    }
  }

  void SignInWithgoogle() async {
    try {
      state = true;
      final GoogleSignInAccount? acc = await signIn.signIn();
      final googleAuth = await acc?.authentication;

      final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential cred = await auth.signInWithCredential(credentials);
      userid = cred.user!.uid;

      print(userid);
      print(cred.user?.email);
      UserModel model;

      if (cred.additionalUserInfo!.isNewUser) {
        model = UserModel(
            posts: [],
            friends: [],
            username: cred.user!.displayName!.replaceAll(' ', ''),
            name: cred.user!.displayName!.replaceAll(' ', '') ?? 'No Name',
            uid: cred.user!.uid,
            profilePic: cred.user!.photoURL!,
            isOnline: true,
            groupId: []);
        await _users.doc(cred.user!.uid).set(model.toMap());

        // print(ProfileDataList[0].name);
      }
      model = await getUserdata(cred.user!.uid).first;
      state = false;
    } catch (e) {
      print(e);
    }
  }

  void SignInWithEmail(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (e) {
      showSnackBar(text: e.message!);
    }
  }

  String receivedID = '';
  Future<int> autoSignInUserWithMobileNumer(String mobile) async {
    int flag = 0;
    FirebaseAuth auth = FirebaseAuth.instance;
    state = true;
    await auth.verifyPhoneNumber(
      phoneNumber: '+91$mobile',
      verificationCompleted: (PhoneAuthCredential credential) async {
        final response = await auth.signInWithCredential(credential);

        flag = 1;
        state = false;
      },
      verificationFailed: (FirebaseAuthException e) {
        flag = 0;
      },
      codeSent: (String verificationId, int? resendToken) {
        receivedID = verificationId;
        // StaticData.veriicationID = verificationId;
        if (verificationId.isNotEmpty) {
          //Fluttertoast.showToast(msg: "OTP Sent");
          print('otp sent');
        } else {
          //Fluttertoast.showToast(msg: "There might be an technical issue");
          print('error');
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return flag;
  }

  Future<int> verifyOTP(String otp) async {
    try {
      state = true;
      PhoneAuthCredential cred = PhoneAuthProvider.credential(
          verificationId: receivedID, smsCode: otp);
      FirebaseAuth auth = FirebaseAuth.instance;
      final response = await auth.signInWithCredential(cred);
      UserModel model = UserModel(
          posts: [],
          username: response.user!.phoneNumber!,
          friends: [],
          name: response.user!.phoneNumber!,
          uid: response.user!.uid,
          profilePic: defaultProfile,
          isOnline: true,
          groupId: []);
      await _users.doc(response.user!.uid).set(model.toMap());
      state = false;
      if (response.user != null) {
        return 1;
      } else {
        return 0;
      }
    } catch (err) {
      return 0;
    }
  }

  Stream<UserModel> getUserdata(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void LogOut() async {
    await auth.signOut();
  }
}
