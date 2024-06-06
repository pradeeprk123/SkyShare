import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyshare/features/Share%20Luggage%20Service/screens/waitlist_screen.dart';
import 'package:skyshare/features/Share%20Luggage%20Service/services/wallet_service.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double? totalBalance;
  double? addAmount;

  @override
  void initState() {
    super.initState();
    fetchAddAmount();
    fetchTotalBalance();
  }

  Future<void> fetchAddAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      addAmount = prefs
          .getDouble('totalPay'); // Retrieve the price from PriceDetailsPage
    });
  }

  Future<void> fetchTotalBalance() async {
    // Assuming WalletService.getTotalBalance() fetches the balance from the backend
    totalBalance = await WalletService.getTotalBalance();
    print('Total balance: $totalBalance');
    setState(() {});
  }

  Future<void> addToWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baggageId = prefs.getString('baggageId');
    if (baggageId != null && addAmount != null) {
      bool success = await WalletService.addToWallet(addAmount!, baggageId);
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuccessScreen()),
        );
      } else {
        print('Error adding amount to wallet');
      }
    } else {
      print('Baggage ID or amount not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SkyShare Wallet')),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text('Total Balance: ₹${totalBalance ?? 0.0}'),
          SizedBox(height: 20),
          TextField(
            controller: TextEditingController(text: addAmount.toString()),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Add amount to wallet'),
            onChanged: (value) => addAmount = double.tryParse(value),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: addToWallet,
            child: Text('Add to Wallet'),
          ),
        ],
      ),
    );
  }
}
