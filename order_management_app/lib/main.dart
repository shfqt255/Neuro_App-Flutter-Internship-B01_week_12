import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:order_management_app/Screens/home_screen.dart';
import 'package:order_management_app/Services/order_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(create: (context) => OrderService(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}
