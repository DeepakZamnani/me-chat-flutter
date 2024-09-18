import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_chat_update/auth/AuthPage.dart';
import 'package:me_chat_update/auth/PhoneNoScreen.dart';
import 'package:me_chat_update/auth/mail_page.dart';
import 'package:me_chat_update/commons/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AuthScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  var key = GlobalKey<FormState>();
  var phoneNumber = '';

  Widget build(BuildContext context) {
    // TODO: implement build
    final isLoading = ref.watch(AuthRepositoryProvider);
    return Scaffold(
      backgroundColor: backgroundColour,
      // appBar: AppBar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(children: [
              Positioned(
                  top: MediaQuery.sizeOf(context).height / 18,
                  //left: -MediaQuery.sizeOf(context).width / 100,
                  // right: 0,
                  child: Image.asset(
                    'assets/LoginIMG.png',
                    width: 273,
                    height: 416,
                  )),
              Positioned(
                bottom: MediaQuery.sizeOf(context).height / 2.8,
                left: MediaQuery.sizeOf(context).width / 9,
                child: ElevatedButton.icon(
                    onPressed: ref
                        .read(AuthRepositoryProvider.notifier)
                        .SignInWithgoogle,
                    label: Text(
                      'Continue with Google',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    icon: Image.asset(
                      'assets/google.png',
                      width: 50,
                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: 8,
                        shadowColor: Colors.blue.shade500,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
              ),
              Positioned(
                bottom: MediaQuery.sizeOf(context).height / 3.6,
                left: MediaQuery.sizeOf(context).width / 9,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) => otpAuth()));
                    },
                    label: Text(
                      'Continue with Number',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    icon: Icon(
                      Icons.phone,
                      size: 45,
                      color: Colors.blue.shade400,
                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: 8,
                        shadowColor: Colors.blue.shade500,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
              ),
              Positioned(
                width: MediaQuery.sizeOf(context).width / 1.25,
                bottom: MediaQuery.sizeOf(context).height / 5,
                left: MediaQuery.sizeOf(context).width / 9,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => MailLoginPage()));
                    },
                    label: Text(
                      '   Continue with Mail',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    icon: Icon(
                      Icons.mail,
                      size: 45,
                      color: Colors.blue.shade400,
                    ),
                    style: ElevatedButton.styleFrom(
                        //minimumSize: //,
                        elevation: 8,
                        shadowColor: Colors.blue.shade500,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
              )
            ]),
    );
  }
}
