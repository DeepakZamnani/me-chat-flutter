import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_chat_update/auth/AuthPage.dart';
import 'package:me_chat_update/commons/common_functions.dart';
import 'package:me_chat_update/commons/pallete.dart';
import 'package:me_chat_update/commons/static_data.dart';
import 'package:me_chat_update/main.dart';
import 'package:me_chat_update/messaging/MessageService.dart';
import 'package:me_chat_update/models/MessageModel.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String currentUserUid;
  final String otherUserUid;

  ChatScreen({required this.currentUserUid, required this.otherUserUid});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  TextEditingController _chatController = TextEditingController();
  void dispose() {
    super.dispose();
    _chatController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColour,
        appBar: AppBar(
          backgroundColor: backgroundColour,
          title: Text('Chat'),
        ),
        body: Column(
          children: [
            Expanded(
                child:
                    Container(color: Colors.white, child: _buildMessageItem())),
            Container(padding: EdgeInsets.all(20), child: _messageInput())
          ],
        ));
  }

  Widget _buildMessageItem() {
    return Container(
      color: backgroundColour,
      child: StreamBuilder(
          stream: Messageservice()
              .getMessages(widget.currentUserUid, widget.otherUserUid),
          builder: (ctx, snapshots) {
            if (snapshots.hasError) {
              return Text('Error${snapshots.error}');
            }
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              reverse: true,
              children: snapshots.data!.docs
                  .map((document) => _messageItem(document))
                  .toList(),
            );
          }),
    );
  }

  Widget _messageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == ref.watch(userDataProvider)!.uid)
        ? TextAlign.right
        : TextAlign.left;

    return FutureBuilder(
        future: getUserFromUid(widget.otherUserUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(alignment == TextAlign.left
                  ? snapshot.data!.profilePic
                  : ref.watch(userDataProvider)!.profilePic),
            ),
            // subtitle: Text(data['timestamp']),
            title: Text(
              data['message'],
              textAlign: alignment,
            ),
          );
        });
  }

  Widget _messageInput() {
    return Row(
      children: [
        Expanded(
            child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter a message',
              ),
              controller: _chatController,
            ),
          ),
        )),
        IconButton(
            style: IconButton.styleFrom(backgroundColor: textColor),
            onPressed: () {
              Messageservice().sendMessage(widget.currentUserUid,
                  widget.otherUserUid, _chatController.text);
            },
            icon: Icon(
              Icons.send,
              color: backgroundColour,
            ))
      ],
    );
  }
}
