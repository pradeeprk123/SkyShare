import 'package:flutter/material.dart';
import 'package:skyshare/features/Share%20Luggage%20Service/screens/baggagedetails_screen.dart';
import 'package:skyshare/features/posts_of_excess_luggage/screens/posts_screen.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  String? _selectedService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child:
              Text('SkyShare Services', style: TextStyle(color: Colors.white)),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Image.asset('assets/images/logo.png', width: 200),
              SizedBox(height: 20),
              _buildServiceButton('Share Luggage', 'share'),
              SizedBox(height: 20),
              _buildServiceButton('Offer Space', 'offer'),
              SizedBox(height: 20),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceButton(String text, String service) {
    return Container(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              _selectedService == service ? Colors.teal[200] : Colors.grey[850],
          textStyle: TextStyle(fontSize: 16),
        ),
        onPressed: () {
          setState(() {
            _selectedService = service;
          });
        },
        child: Text(text),
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return Colors.redAccent;
            return Colors.white; // Use the component's default.
          },
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      ),
      onPressed: _selectedService != null ? _navigateToNextPage : null,
      icon: Icon(Icons.arrow_forward, color: Colors.black),
      label: Text('Continue', style: TextStyle(color: Colors.black)),
    );
  }

  void _navigateToNextPage() {
    if (_selectedService == 'share') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => BaggageDetailsScreen()));
    } else if (_selectedService == 'offer') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) =>  PostsScreen()));
    }
    // Reset selected service after navigation
    setState(() {
      _selectedService = null;
    });
  }
}
