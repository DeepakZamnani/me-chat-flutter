import 'package:flutter/material.dart';
import 'package:me_chat_update/auth/AuthPage.dart';
import 'package:me_chat_update/auth/AuthScreen.dart';
import 'package:me_chat_update/auth/PhoneNoScreen.dart';
import 'package:me_chat_update/auth/mail_page.dart';
import 'package:me_chat_update/screens/HomeScree.dart';
import 'package:me_chat_update/screens/profile_screen.dart';
import 'package:routemaster/routemaster.dart';
import '';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: AuthScreen()),
  '/number': (_) => MaterialPage(child: otpAuth()),
  '/profile': (_) => MaterialPage(child: Home()),
  '/mail': (_) => MaterialPage(child: MailLoginPage())
});
final loggedInROute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: HomeScreen()),
  //'/main': (_) => MaterialPage(child: Home()),
});
