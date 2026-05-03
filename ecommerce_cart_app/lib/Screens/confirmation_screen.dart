import 'package:ecommerce_cart_app/Providers/product_provider.dart';
import 'package:ecommerce_cart_app/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Success")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Order Placed Successfully"),
            Text("Total Paid: Rs ${cart.total}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                cart.clearCart();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                  (route) => false,
                );
              },
              child: Text("Back Home"),
            ),
          ],
        ),
      ),
    );
  }
}
