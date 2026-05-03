import 'package:ecommerce_cart_app/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _cartItems = [];
  List<Product> get cartItems => _cartItems;
  double discount = 0;

  void addtoCart(Product product) {
    int index = cartItems.indexWhere((items) => items.id == product.id);
    if (index == -1) {
      _cartItems.add(product);
    } else {
      _cartItems[index].quantity++;
    }
    notifyListeners();
  }

  void incrementQuantity(int index) {
    _cartItems[index].quantity++;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (index > 1) {
      _cartItems[index].quantity--;
    } else {
      _cartItems.removeAt(index);
    }
    notifyListeners();
  }

  double get subtotal {
    double total = 0;
    for (var item in _cartItems) {
      total = total + (item.price * item.quantity);
    }
    return total;
  }

  void applyDiscount(String code) {
    if (code == 'Save10') {
      discount = subtotal * 0.10;
    } else if (code == 'Save20') {
      discount = subtotal * 0.20;
    } else if (code == 'Save50') {
      discount = subtotal * 0.50;
    } else {
      discount = 0;
    }
    notifyListeners();
  }

  double get tax => subtotal * 0.10;

  double get shipping => subtotal > 10000 ? 0 : 500;

  double get total => subtotal + tax + shipping - discount;

  void clearCart() {
    _cartItems.clear();
    discount = 0;
    notifyListeners();
  }
}
