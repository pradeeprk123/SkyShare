import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skyshare/features/flightcheckin/services/checkin_service.dart';
import 'package:skyshare/features/skyshare_services/screens/services_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInPage extends StatefulWidget {
  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _flightNumberController = TextEditingController();
  final TextEditingController _airlineController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ticketNumberController = TextEditingController();
  final TextEditingController _seatNumberController = TextEditingController();
  DateTime? _departureDate;
  String? _selectedClass;

  final CheckInService _checkInService = CheckInService();
  String? token;

  @override
  void initState() {
    super.initState();
    fetchToken(); // Method to retrieve the token
  }

  void fetchToken() async {
    // Retrieve token from storage or app state
    // Example: token = await storage.read(key: 'jwt_token');
    // For demonstration, let's assume token is fetched here
    token = 'your_token_here'; // Replace with actual token retrieval logic
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      bool isSuccess = await _checkInService.checkIn({
        'flightNumber': _flightNumberController.text,
        'airline': _airlineController.text,
        'departureDate': DateFormat('yyyy-MM-dd').format(_departureDate!),
        'name': _nameController.text,
        'ticketNumber': _ticketNumberController.text,
        'seatNumber': _seatNumberController.text,
        'class': _selectedClass,
      }, token!);

      if (isSuccess) {
        // Save the flightNumber using shared_preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('flightNumber', _flightNumberController.text);
        print('Flight number saved: ${_flightNumberController.text}');

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => ServicePage()));
        // Show a success Snackbar upon navigation
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Check-in successful! Details are correct.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid or incorrect details')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication token not found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Check-In'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _flightNumberController,
                decoration: InputDecoration(labelText: 'Flight Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter flight number' : null,
              ),
              TextFormField(
                controller: _airlineController,
                decoration: InputDecoration(labelText: 'Airline'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter airline name' : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              TextFormField(
                controller: _ticketNumberController,
                decoration: InputDecoration(labelText: 'Ticket Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter ticket number' : null,
              ),
              TextFormField(
                controller: _seatNumberController,
                decoration: InputDecoration(labelText: 'Seat Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter seat number' : null,
              ),
              ListTile(
                title: Text(
                    'Departure Date: ${_departureDate != null ? DateFormat('yyyy-MM-dd').format(_departureDate!) : 'Select Date'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 10)),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _departureDate = picked);
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedClass,
                items: ['economy', 'business', 'first'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedClass = newValue;
                  });
                },
                decoration: InputDecoration(labelText: 'Class'),
                validator: (value) => value == null ? 'Select class' : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
