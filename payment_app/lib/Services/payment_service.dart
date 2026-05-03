import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentProvider extends ChangeNotifier {
  // Change this URL based on your setup
  // Android Emulator: http://10.0.2.2:5000
  // iOS Simulator: http://localhost:5000
  final String _backendURL = 'http://192.168.100.143:5000';

  bool _isLoading = false;
  bool _paymentStatus = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  bool get paymentStatus => _paymentStatus;
  String get errorMessage => _errorMessage;

  // Step 5: Create Payment Intent via Backend
  Future<Map<String, dynamic>> _createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendURL/payment/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount, 'currency': currency}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  // Steps 6, 7, 8: Show Payment Sheet and Collect Card Details
  Future<bool> makePayment(String amount, String currency) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Step 5: Create payment intent on backend
      final paymentData = await _createPaymentIntent(amount, currency);

      // Step 6 & 7: Initialize and show Stripe Payment Sheet
      // This is where Stripe collects card details securely
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentData['clientSecret'],
          merchantDisplayName: 'Payment App Store',
          // Enable card collection
          allowsDelayedPaymentMethods: false,
          // Customize appearance
          appearance: const PaymentSheetAppearance(
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Color(0xFF00897B), // Teal color
                ),
              ),
            ),
          ),
        ),
      );

      // Step 8: Present payment sheet - user confirms payment here
      await Stripe.instance.presentPaymentSheet();

      // If we reach here, payment was confirmed successfully
      _paymentStatus = true;

      // Step 11: Save transaction to Firestore
      await _saveTransaction(paymentData['id'], amount, 'completed');

      _isLoading = false;
      notifyListeners();
      return true;
    } on StripeException catch (e) {
      // Step 9: Handle payment failure
      _paymentStatus = false;
      _errorMessage = e.error.localizedMessage ?? 'Payment was cancelled';

      // Save failed transaction
      await _saveTransaction('unknown', amount, 'failed');

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _paymentStatus = false;
      _errorMessage = 'Something went wrong: ${e.toString()}';

      await _saveTransaction('unknown', amount, 'failed');

      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Step 11: Save Transaction to Firestore
  Future<void> _saveTransaction(
    String paymentId,
    String amount,
    String status,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('transactions').add({
        'paymentId': paymentId,
        'amount': amount,
        'currency': 'PKR',
        'status': status,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('✅ Transaction saved: $paymentId');
    } catch (e) {
      print('❌ Error saving transaction: $e');
    }
  }

  void resetPayment() {
    _paymentStatus = false;
    _errorMessage = '';
    notifyListeners();
  }
}
