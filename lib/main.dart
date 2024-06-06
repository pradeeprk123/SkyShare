import 'package:flutter/material.dart';
import 'features/auth/screens/auth_screen.dart'; // Import the AuthScreen
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'SkyShare',
        theme: ThemeData(
          primaryColor: const Color(0xFFF88264),
          brightness: Brightness.dark, // Ensures dark theme with white text
        ),
        home: const HomePage(), // Set HomePage as the initial screen
        // Define other routes here
      ),
    );
  }
}

// HomePage with the landing page design
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo.png'), // Your logo here
            const SizedBox(height: 150), // Adjust this value as needed
            const Text(
              'SkyShare®',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const Text(
              'SkyShare Technologies',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24), // Add some space between the text and the button
            ElevatedButton(
              onPressed: () {
                // Navigate to AuthScreen when 'Get Started' is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFF88264)),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
