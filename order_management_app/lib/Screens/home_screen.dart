import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/order_service.dart';
import '../Models/order_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // HARDCODED USER
  final String userId = "user_001";
  int orderCounter = 0;
  final TextEditingController productController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<OrderService>(context, listen: false).fetchOrders(userId);
    });
  }

  void showOrderDialog() {
    double total = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Place Order"),

          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: productController,
                    decoration: const InputDecoration(labelText: "Product"),
                  ),

                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Price"),
                    onChanged: (value) {
                      setState(() {
                        total = double.tryParse(value) ?? 0;
                      });
                    },
                  ),

                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: "Address"),
                  ),

                  const SizedBox(height: 10),
                  Text("Total: $total"),
                ],
              );
            },
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final nav = Navigator.of(context);
                final service = Provider.of<OrderService>(
                  context,
                  listen: false,
                );

                orderCounter++;

                final order = OrderModel(
                  orderId: "",
                  userId: userId,
                  products: [productController.text],
                  totalAmount: double.tryParse(priceController.text) ?? 0,
                  address: addressController.text,
                  orderDate: DateTime.now(),
                  status: OrderStatus.pending,
                );

                await service.placeOrder(order, userId);

                nav.pop();

                productController.clear();
                priceController.clear();
                addressController.clear();
              },
              child: const Text("Place Order"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderService>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Orders ($userId)")),

      body: RefreshIndicator(
        onRefresh: () => provider.fetchOrders(userId),

        child: provider.orders.isEmpty
            ? const Center(child: Text("No Orders Found"))
            : ListView.builder(
                itemCount: provider.orders.length,
                itemBuilder: (context, index) {
                  final order = provider.orders[index];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text("Rs: ${order.totalAmount}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Product: ${order.products.join(", ")}"),
                          Text("Address: ${order.address}"),
                          Text("Status: ${order.status.name}"),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              const Text("Change Status: "),
                              if (order.status == OrderStatus.cancelled)
                                const Text(
                                  "CANCELLED",
                                  style: TextStyle(color: Colors.red),
                                )
                              else
                                DropdownButton<OrderStatus>(
                                  value: order.status,
                                  onChanged: (newStatus) async {
                                    if (newStatus == null) return;

                                    await provider.updateStatus(
                                      userId,
                                      order.orderId,
                                      newStatus,
                                    );

                                    await provider.fetchOrders(userId);
                                  },
                                  items: OrderStatus.values
                                      .where((s) => s != OrderStatus.cancelled)
                                      .map((status) {
                                        return DropdownMenuItem<OrderStatus>(
                                          value: status,
                                          child: Text(status.name.toUpperCase()),
                                        );
                                      })
                                      .toList(),
                                ),
                            ],
                          ),
                        ],
                      ),

                      trailing: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () async {
                          await provider.cancelOrder(userId, order.orderId);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showOrderDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
