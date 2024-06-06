import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyshare/features/Share%20Luggage%20Service/screens/wallet_screen.dart';
import 'package:skyshare/features/Share%20Luggage%20Service/services/pricedetails_service.dart';

class PriceDetailsPage extends StatefulWidget {
  @override
  _PriceDetailsPageState createState() => _PriceDetailsPageState();
}

class _PriceDetailsPageState extends State<PriceDetailsPage> {
  double? distance;
  double? duration;
  double? weight;
  final double baseRatePerKg = 200; // Rs per kg
  final double distanceRatePerKm = 0.15; // Rs per km
  final double durationRatePerHour = 150; // Rs per hour
  double? totalPay;
  String? flightNumber;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    flightNumber = prefs.getString('flightNumber');
    String? baggageWeight = prefs.getString('baggageWeight');

    if (flightNumber != null && baggageWeight != null) {
      weight = double.tryParse(baggageWeight);
      fetchFlightDetails(flightNumber!);
    } else {
      print('Error: Necessary data not available in shared preferences.');
    }
  }

  void fetchFlightDetails(String flightNumber) async {
    try {
      var flightDetails =
          await PriceDetailsService.fetchFlightDetails(flightNumber);
      setState(() {
        distance = double.tryParse(flightDetails['distanceKm'].toString());
        duration = double.tryParse(flightDetails['durationHrs'].toString());
        totalPay = calculateTotalPay();
        savePriceDetails();
      });
    } catch (e) {
      print('Failed to retrieve flight details: $e');
    }
  }

  Future<void> savePriceDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalPay', totalPay ?? 0);
  }

  double calculateTotalPay() {
    if (weight != null && distance != null && duration != null) {
      return (weight! * baseRatePerKg) +
          (distance! * distanceRatePerKm) +
          (duration! * durationRatePerHour);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Price Details')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Text('Flight Number: $flightNumber',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Distance of flight: ${distance ?? 0} km',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Duration of flight: ${duration ?? 0} hrs',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Weight of baggage: ${weight ?? 0} kg',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Amount per KG: ₹$baseRatePerKg',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Total Pay: ₹${totalPay?.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                child: Text('PROCEED'),
                onPressed: totalPay != null
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WalletScreen()));
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
