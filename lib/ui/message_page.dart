import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/consts.dart';
import '../utils/size_config.dart';

class MessagePage extends StatelessWidget {
  MessagePage();

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream = FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No messages found.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final message = doc['message'] as String;
              final timestamp = doc['timestamp'] as Timestamp;
              final title = doc['title'] as String;
              final poster_path = doc['poster_path'] as String;

              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.smallPadding, vertical: SizeConfig.screenHeight! * 0.005),
                leading: CircleAvatar(
                  radius: SizeConfig.screenWidth! * 0.1,
                  backgroundImage: NetworkImage('$kImageUrl${poster_path}'),
                ),
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      TextSpan(
                        text: title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "\n$message"),
                    ],
                  ),
                ),
                subtitle: Text(
                  timestamp.toDate().toLocal().toString(),
                  style: TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}