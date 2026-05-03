import 'package:ecommerce_cart_app/Screens/payment_screen.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  final TextEditingController address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Address")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: address,
              decoration: InputDecoration(hintText: "Enter Address"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PaymentPage()),
                );
              },
              child: Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
