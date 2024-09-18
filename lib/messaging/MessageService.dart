import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:me_chat_update/main.dart';
import 'package:me_chat_update/models/MessageModel.dart';

class Messageservice {
  Future<void> sendMessage(
      String senderId, String recieverId, String message) async {
    List ids = [senderId, recieverId];
    ids.sort();
    final chat_name = ids.join('_');
    try {
      await firestore
          .collection('chats')
          .doc(chat_name)
          .collection('messages')
          .add({
        'senderId': senderId,
        'receiverId': recieverId,
        'message': message,
        'timestamp': Timestamp.now()
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getMessages(String senderid, String receiverId) {
    List ids = [senderid, receiverId];
    ids.sort();
    final chat_doc = ids.join('_');
    var snapshots = firestore
        .collection('chats')
        .doc(chat_doc)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return snapshots;
  }
}
