import 'package:flutter/material.dart';
import 'message.dart'; // Importing the Message screen

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Your ChatRoom',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true, // Align the title to the center
      ),
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (context, index) => Divider(color: Colors.grey),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              // Replace with your chat icon
              child: Icon(Icons.person),
            ),
            title: Text(
              chat.name,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              chat.message,
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              chat.time,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessageScreen(name: chat.name)),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatModel {
  final String name;
  final String message;
  final String time;

  ChatModel({required this.name, required this.message, required this.time});
}

List<ChatModel> chats = [
  ChatModel(
    name: 'Emily Johnson',
    message: 'Hey, I am here to share.',
    time: '08:45 pm',
  ),
  ChatModel(
    name: 'Michael Thompson',
    message: 'Yes, I am ready to share my space.',
    time: '08:45 pm',
  ),
  ChatModel(
    name: 'Jessica Taylor',
    message: 'Hi!',
    time: '08:45 pm',
  ),
];
