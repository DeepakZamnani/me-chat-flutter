//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_chat_update/auth/AuthScreen.dart';
import 'package:me_chat_update/models/UserModel.dart';
import 'package:me_chat_update/router.dart';
import 'package:me_chat_update/auth/AuthPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:me_chat_update/screens/HomeScree.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  runApp(ProviderScope(child: MyApp()));
}

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class MyApp extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _myapp();
  }
}

class _myapp extends ConsumerState<MyApp> {
  UserModel? userModel;
  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(AuthRepositoryProvider.notifier)
        .getUserdata(data.uid)
        .first;
    ref.read(userDataProvider.notifier).update((state) => userModel);
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              getData(ref, snapshot.data!);
              return HomeScreen();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return AuthScreen();
          }),
    );
  }
}
/*ref.watch(AuthStateProvider).when(
        data: (data) => MaterialApp.router(
              //home: AuthScreen(),
              routerDelegate: RoutemasterDelegate(routesBuilder: (ctx) {
                if (data != null) {
                  getData(ref, data);
                  if (userModel != null) {
                    return loggedInROute;
                  }
                }

                return loggedOutRoute;
              }),
              routeInformationParser: RoutemasterParser(),
            ),
        error: (error, StackTrace) => SnackBar(content: Text(error.toString())),
        loading: () {
          return CircularProgressIndicator();
        });*/