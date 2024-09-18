import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:me_chat_update/messaging/MessageService.dart';

class Chattrail extends StatefulWidget {
  const Chattrail({super.key});

  @override
  State<Chattrail> createState() => _ChattrailState();
}

class _ChattrailState extends State<Chattrail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: null,
        builder: (context, snapshot) {
          print("In Chat Trail");
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {}
          return Container();
        },
      ),
    );
  }
}
