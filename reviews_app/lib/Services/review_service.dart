import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reviews_app/Models/review_model.dart';

class ReviewService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String userId = "user_002";

  double selectedRating = 0;
  String sortBy = 'recent';
  int filterRating = 0;

  void setRating(double value) {
    selectedRating = value;
    notifyListeners();
  }

  void setSort(String value) {
    sortBy = value;
    notifyListeners();
  }

  void setFilter(int value) {
    filterRating = value;
    notifyListeners();
  }

  Future<void> addReview({
    required String orderId,
    required String productId,
    required String comment,
  }) async {
    final review = ReviewModel(
      id: '',
      userid: userId,
      ratings: selectedRating,
      comment: comment,
      helpfulvotes: 0,
      createdAt: DateTime.now(),
    );

    await _db
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .add(review.toMap().cast<String, dynamic>());

    selectedRating = 0;
    notifyListeners();
  }

  Stream<List<ReviewModel>> fetchReviews({
    required String orderId,
    required String productId,
  }) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          List<ReviewModel> reviews = snapshot.docs
              .map((doc) => ReviewModel.fromMap(doc.id, doc.data()))
              .toList();

          return reviews;
        });
  }

  Future<void> markHelpful({
    required String orderId,
    required String productId,
    required String reviewId,
  }) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .doc(reviewId)
        .update({'helpfulvotes': FieldValue.increment(1)});
  }

  double calculateAverage(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0;

    double total = reviews.map((r) => r.ratings).reduce((a, b) => a + b);

    return total / reviews.length;
  }

  // Future<void> addDummyProducts() async {
  //   final orderId = "order_001";

  //   List products = [
  //     {"id": "product_001", "name": "Shirt", "price": 1500},
  //     {"id": "product_002", "name": "Pant", "price": 2000},
  //     {"id": "product_003", "name": "Coat", "price": 5000},
  //   ];

  //   for (var product in products) {
  //     await _db
  //         .collection('users')
  //         .doc(userId)
  //         .collection('orders')
  //         .doc(orderId)
  //         .collection('products')
  //         .doc(product['id'])
  //         .set(product);
  //   }
  // }
}
