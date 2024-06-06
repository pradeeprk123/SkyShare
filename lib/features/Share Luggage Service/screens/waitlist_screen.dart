import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Success')),
      body: Center(
        child: Text(
            'Your baggage details have been posted successfully. Wait until someone connects with you.'),
      ),
    );
  }
}
