import 'package:ecommerce_cart_app/Providers/product_provider.dart';
import 'package:ecommerce_cart_app/Screens/cart_screen.dart';
import 'package:ecommerce_cart_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
      id: '1',
      name: "Nike Shoes",
      image: "assets/shoes.png",
      price: 2500,
      quantity: 1,
    ),
    Product(
      id: '2',
      name: "T-Shirt",
      image: "assets/tshirt.png",
      price: 500,
      quantity: 1,
    ),
    Product(
      id: '3',
      name: "Watch",
      image: "assets/watch.png",
      price: 3200,
      quantity: 1,
    ),
    Product(
      id: '4',
      name: "Bag",
      image: "assets/bag.png",
      price: 1800,
      quantity: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartScreen()),
                  );
                },
              ),
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.red,
                  child: Text(
                    cart.cartItems.length.toString(),
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            var item = products[index];

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: Image.asset(
                        item.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    item.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Rs ${item.price}"),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 40),
                      ),
                      onPressed: () {
                        cart.addtoCart(
                          Product(
                            id: item.id,
                            name: item.name,
                            image: item.image,
                            price: item.price,

                            quantity: 1,
                          ),
                        );
                      },
                      child: Text("Add to Cart"),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
