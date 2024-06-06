import 'dart:io';
import 'chat.dart';
import 'package:flutter/material.dart';
import 'package:skyshare/features/posts_of_excess_luggage/services/posts_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  Future<List<dynamic>>? _posts;
  String? flightNumber;

  @override
  void initState() {
    super.initState();
    _loadFlightNumber();
  }

  void _loadFlightNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedFlightNumber = prefs.getString('flightNumber');
    if (savedFlightNumber != null) {
      setState(() {
        flightNumber = savedFlightNumber;
        _posts = PostsService.getPosts(flightNumber!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts of Excess Luggage')),
      body: flightNumber == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<dynamic>>(
              future: _posts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: EdgeInsets.all(
                          10), // Increased space around the cards
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var post = snapshot.data![index];
                        double amount = double.tryParse(post['amount']) ??
                            0; // Safely parse the amount
                        return Card(
                          margin: EdgeInsets.all(
                              10), // Increased space between cards
                          child: Padding(
                            padding:
                                EdgeInsets.all(16), // Increased inner padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(post['userName'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight
                                            .bold)), // Increased font size
                                SizedBox(height: 10),
                                Text('Weight: ${post['weight']} KG',
                                    style: TextStyle(
                                        fontSize: 18)), // Increased font size
                                SizedBox(height: 10),
                                Image.network(
                                    'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/${post['pictureUrl']}',
                                    height: 200,
                                    fit: BoxFit.cover),
                                SizedBox(height: 10),
                                Text(post['description'],
                                    style: TextStyle(
                                        fontSize: 18)), // Increased font size
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('₹${amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors
                                                .green)), // Increased font size
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        backgroundColor:
                                            Colors.orange, // Text color
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) => Chat()));
                                      },
                                      child: Text('Connect',
                                          style: TextStyle(
                                              fontSize:
                                                  18)), // Increased font size
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                }
                return CircularProgressIndicator();
              },
            ),
    );
  }
}
