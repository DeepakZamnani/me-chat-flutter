import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_chat_update/auth/AuthPage.dart';
import 'package:me_chat_update/commons/pallete.dart';

class MailLoginPage extends ConsumerStatefulWidget {
  const MailLoginPage({super.key});

  @override
  ConsumerState<MailLoginPage> createState() => _MailLoginPageState();
}

class _MailLoginPageState extends ConsumerState<MailLoginPage> {
  @override
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  var name = '';
  var password = '';
  var email = '';
  bool isUser = true;
  void dispose() {
    super.dispose();
    nameController.dispose();
    passController.dispose();
    emailController.dispose();
  }

  void SignUp() async {
    setState(() {
      name = nameController.text;
      password = passController.text;
      email = emailController.text;
    });
    ref
        .watch(AuthRepositoryProvider.notifier)
        .CreateUserWithEmail(email, password, name);
    Navigator.pop(context);
  }

  void Login() async {
    setState(() {
      //name = nameController.text;
      password = passController.text;
      email = emailController.text;
    });
    ref.watch(AuthRepositoryProvider.notifier).SignInWithEmail(email, password);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColour,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.2,
          height: !isUser
              ? MediaQuery.of(context).size.height / 2
              : MediaQuery.of(context).size.height / 2.5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25), color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width / 1.4,
                child: TextFormField(
                  //maxLength: 8,
                  decoration: InputDecoration(
                      hintText: 'Email', border: InputBorder.none),
                  controller: emailController,
                  autofocus: true,
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width / 1.4,
                child: TextFormField(
                  maxLength: 8,
                  decoration: InputDecoration(
                      hintText: 'Password', border: InputBorder.none),
                  controller: passController,
                  autofocus: true,
                ),
              ),
              if (!isUser)
                Container(
                  width: MediaQuery.sizeOf(context).width / 1.4,
                  child: TextFormField(
                    maxLength: 8,
                    decoration: InputDecoration(
                        hintText: 'Name', border: InputBorder.none),
                    controller: nameController,
                    autofocus: true,
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      if (!isUser) {
                        isUser = true;
                      } else {
                        isUser = false;
                      }
                    });
                  },
                  child: Text(!isUser
                      ? "Already have an account?Login"
                      : "Create an account")),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (!isUser) {
                        name = nameController.text;
                      }
                      password = passController.text;
                      email = emailController.text;
                    });

                    setState(() {
                      ref
                          .watch(AuthRepositoryProvider.notifier)
                          .SignInWithEmail(email, password);
                    });

                    if (!isUser) {
                      ref
                          .watch(AuthRepositoryProvider.notifier)
                          .CreateUserWithEmail(email, password, name);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(isUser ? "Login" : "Sign Up"))
            ],
          ),
        ),
      ),
    );
  }
}
