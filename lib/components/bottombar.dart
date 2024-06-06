import 'package:flutter/material.dart';
import 'package:skyshare/features/chatspage/screens/chats_screen.dart';
import 'package:skyshare/features/profilepage/screens/profilepage_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;

  CustomBottomNavigationBar({this.currentIndex = 0});

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(chatId: '',)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
      ],
      currentIndex: widget.currentIndex,
      onTap: _onItemTapped,
    );
  }
}