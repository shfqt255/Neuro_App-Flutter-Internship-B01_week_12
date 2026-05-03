import 'package:flutter/material.dart';
import 'package:payment_app/Services/payment_service.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Amount Input
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount (in PKR)',
                      hintText: 'Enter amount (minimum 200 PKR)',
                      helperText: 'Minimum: 200 PKR',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.money),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Error Message Display
                  if (provider.errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        provider.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Pay Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () => _handlePayment(provider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Pay Now',
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handlePayment(PaymentProvider provider) async {
    // Validate amount
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter amount'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final amountInPKR = double.parse(_amountController.text);

    // Check minimum amount (200 PKR minimum)
    if (amountInPKR < 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimum amount is 200 PKR'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Convert PKR to paisas (multiply by 100)
    final amountInPaisas = (amountInPKR * 100).toStringAsFixed(0);

    print('💰 Amount in PKR: $amountInPKR');
    print('💰 Amount in paisas: $amountInPaisas');

    // Process payment
    final success = await provider.makePayment(amountInPaisas, 'pkr');

    if (!mounted) return;

    if (success) {
      _showSuccessDialog(provider);
    }
  }

  void _showSuccessDialog(PaymentProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 10),
            Text('Payment Successful!', style: TextStyle(color: Colors.green)),
          ],
        ),
        content: Text(
          'Your payment of Rs. ${_amountController.text} has been processed successfully.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _amountController.clear();
              provider.resetPayment();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
