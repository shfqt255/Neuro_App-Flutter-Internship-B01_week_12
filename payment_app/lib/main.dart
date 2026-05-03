import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:payment_app/Screens/payment_screen.dart';
import 'package:payment_app/Services/payment_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Step 3: Initialize Stripe with your publishable key
  Stripe.publishableKey =
      'pk_test_51TSYG22L7pRQ6jtTVQUJSZcT9wMBObeftfhXiYiFp5Ls5S5jdwAA2zaNeOJqDspQ8dLLcqf5D1yzTwYiXxQHD9AS00ePGRIhAj';

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PaymentProvider())],
      child: MaterialApp(
        title: 'Payment App',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: const PaymentScreen(),
      ),
    );
  }
}
