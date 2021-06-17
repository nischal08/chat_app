import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data?.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatSnapshot.data!.docs.length,
          itemBuilder: (context, index) => MessageBubble(
            userImage:chatDocs![index]['userImage'],
            username: chatDocs[index]['username'],
            key: ValueKey(chatDocs[index].id),
            isMe: chatDocs[index]['userId'] ==
                FirebaseAuth.instance.currentUser!.uid,
            message: chatDocs[index]['text'],
          ),
        );
      },
    );
  }
}
