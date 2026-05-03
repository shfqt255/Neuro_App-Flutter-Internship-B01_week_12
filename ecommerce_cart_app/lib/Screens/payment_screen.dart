import 'package:ecommerce_cart_app/Screens/confirmation_screen.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String method = "Cash on Delivery";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Column(
        children: [
          RadioListTile(
            value: "Cash on Delivery",
            groupValue: method,
            onChanged: (value) {
              setState(() {
                method = value!;
              });
            },
            title: Text("Cash on Delivery"),
          ),
          RadioListTile(
            value: "Card",
            groupValue: method,
            onChanged: (value) {
              setState(() {
                method = value!;
              });
            },
            title: Text("Card"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ConfirmationPage()),
              );
            },
            child: Text("Place Order"),
          ),
        ],
      ),
    );
  }
}
