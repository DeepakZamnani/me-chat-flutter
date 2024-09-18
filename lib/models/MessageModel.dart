import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageModel {
  String senderId;
  String receiverId;
  String message;
  String timeStamp;
  MessageModel(
      {required this.message,
      required this.receiverId,
      required this.senderId,
      required this.timeStamp});

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return MessageModel(
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      message: data['message'],
      timeStamp: data['timestamp'],
    );
  }
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
        message: map['message'],
        receiverId: map['receiverId'],
        senderId: map['senderId'],
        timeStamp: map['timestamp']);
  }
}
