import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyshare/features/profilepage/services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userEmail;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;

  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('user_email');
    if (userEmail != null) {
      try {
        userData = await _profileService.fetchUserData(userEmail!);
      } catch (e) {
        errorMessage = e.toString();
        print('Error fetching user data: $e');
      }
    } else {
      errorMessage = "Email not found.";
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : errorMessage != null
                ? Text(errorMessage!)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userData?['imageUrl'] ??
                            'https://via.placeholder.com/150'),
                      ),
                      SizedBox(height: 20),
                      Text("${userData?['firstName']} ${userData?['lastName']}",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(userData?['email'] ?? 'No Email',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600])),
                      ElevatedButton(onPressed: () {}, child: Text("Logout"))
                    ],
                  ),
      ),
    );
  }
}
