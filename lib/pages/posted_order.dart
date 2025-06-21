import 'package:flutter/material.dart';

class PostedOrder extends StatelessWidget {
  final String orderId;
  final String title;
  final String description;
  final String pickUp;
  final String dropOff;
  final double price;
  final DateTime expiry;
  final bool isDelivered;
  final bool onDelivery;
  final VoidCallback onMarkAsDelivered;

  const PostedOrder({
    super.key,
    required this.orderId,
    required this.title,
    required this.description,
    required this.pickUp,
    required this.dropOff,
    required this.price,
    required this.expiry,
    required this.isDelivered,
    required this.onDelivery,
    required this.onMarkAsDelivered,
  });

  void showDeliveredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Order Delivered"),
        content: Text("Please proceed to pay ₹$price for Order ID: $orderId"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onMarkAsDelivered();
            },
            child: Text("Okay"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange.shade100,
                  child: Icon(Icons.shopping_bag, color: Colors.orange),
                ),
                Spacer(),
                Text("Order by You"),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '₹$price',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(description),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("Pickup", style: TextStyle(fontSize: 12, color: Colors.black)),
                    Text(pickUp, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text('............'),
                Column(
                  children: [
                    Text("Drop Off", style: TextStyle(fontSize: 12, color: Colors.black)),
                    Text(dropOff, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Status and action button
            if (isDelivered)
              Text("Delivered ✅", style: TextStyle(color: Colors.green.shade800))
            else ...[
              Text(
                onDelivery ? "Accepted by a deliverer" : "Not yet accepted",
                style: TextStyle(color: onDelivery ? Colors.green : Colors.orange),
              ),
              SizedBox(height: 12),
              if (onDelivery)
                ElevatedButton.icon(
                  onPressed: () => showDeliveredDialog(context),
                  icon: Icon(Icons.check_circle),
                  label: Text("Mark order as Delivered"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade100,
                    foregroundColor: Colors.green.shade900,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
