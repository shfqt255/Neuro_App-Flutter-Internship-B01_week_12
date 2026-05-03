import 'package:ecommerce_cart_app/Providers/product_provider.dart';
import 'package:ecommerce_cart_app/Screens/address_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (context, index) {
                var item = cart.cartItems[index];

                return ListTile(
                  title: Text(item.name),
                  subtitle: Text("Rs ${item.price} x ${item.quantity}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          cart.decrementQuantity(index);
                        },
                        icon: Icon(Icons.remove),
                      ),
                      IconButton(
                        onPressed: () {
                          cart.incrementQuantity(index);
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: codeController,
              decoration: InputDecoration(
                hintText: "Discount Code",
                suffixIcon: IconButton(
                  onPressed: () {
                    cart.applyDiscount(codeController.text.trim());
                  },
                  icon: Icon(Icons.check),
                ),
              ),
            ),
          ),

          Text("Subtotal: Rs ${cart.subtotal}"),
          Text("Tax: Rs ${cart.tax}"),
          Text("Shipping: Rs ${cart.shipping}"),
          Text("Discount: Rs ${cart.discount}"),
          Text("Total: Rs ${cart.total}"),

          SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddressPage()),
              );
            },
            child: Text("Checkout"),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}
