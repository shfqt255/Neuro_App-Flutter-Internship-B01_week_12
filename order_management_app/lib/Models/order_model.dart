enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class OrderModel {
  final String orderId;
  final String userId;
  final List<dynamic> products;
  final double totalAmount;
  final String address;
  final DateTime orderDate;
  final OrderStatus status;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.products,
    required this.totalAmount,
    required this.address,
    required this.orderDate,
    required this.status,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      orderId: id,
      userId: map['UserId'],
      products: map['Products'],
      totalAmount: map['TotalAmount'],
      address: map['Address'],
      orderDate: DateTime.parse(map['OrderDate']),
      status: OrderStatus.values.firstWhere((e) => e.name == map['Status']),
    );
  }

  Map<String, dynamic> toMap() {
    return ({
      'OrderId': orderId,
      'UserId': userId,
      'Products': products,
      'TotalAmount': totalAmount,
      'Address': address,
      'OrderDate': orderDate.toIso8601String(),
      'Status': status.name,
    });
  }
}
