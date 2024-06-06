import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skyshare/features/Share%20Luggage%20Service/screens/pricedetails_screen.dart';
import 'package:skyshare/features/Share%20Luggage%20Service/services/baggagedetails_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaggageDetailsScreen extends StatefulWidget {
  @override
  _BaggageDetailsScreenState createState() => _BaggageDetailsScreenState();
}

class _BaggageDetailsScreenState extends State<BaggageDetailsScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<XFile>? imageFileList = [];

  final ImagePicker _picker = ImagePicker();

  void pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    setState(() {
      if (selectedImages != null) {
        imageFileList = selectedImages;
      }
    });
  }

  void handleSubmit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? flightNumber =
        prefs.getString('flightNumber'); // Retrieve the flight number

    if (flightNumber == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Flight number not found')));
      return;
    }

    bool result = await BaggageDetailsService.postBaggageDetails(
      weight: weightController.text,
      description: descriptionController.text,
      flightNumber: flightNumber,
      imageFiles: imageFileList,
    );

    if (result) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('baggageWeight', weightController.text);
      print('Baggage weight saved: ${weightController.text}');

      String? baggageId = prefs.getString('baggageId');
      print('Baggage ID: $baggageId');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Success')));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PriceDetailsPage()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to submit details')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baggage Details')),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight of Bag (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.photo_library),
              label: Text('Upload Pictures'),
              onPressed: pickImages,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description about Items'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('POST'),
              onPressed: handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
