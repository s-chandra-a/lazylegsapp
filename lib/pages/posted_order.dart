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
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text("Order Delivered", style: TextStyle(color: Colors.white)),
        content: Text(
          "Please proceed to pay ₹$price for Order ID: $orderId",
          style: const TextStyle(color: Color(0xFFC0C0C0)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onMarkAsDelivered();
            },
            child: const Text("Okay", style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF2A2A2A);
    const textWhite = Colors.white;
    const textLight = Color(0xFFC0C0C0);
    const badgeColor = Color(0xFFFF5C5C);

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF3A3A3A),
                  child: Icon(Icons.shopping_bag, color: Colors.white),
                ),
                const Spacer(),
                const Text("Order by You", style: TextStyle(color: textLight)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '₹$price',
                    style: const TextStyle(color: textWhite, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Title and Description
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textWhite)),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(color: textLight)),

            const SizedBox(height: 16),

            // Pickup and Drop Off
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text("Pickup", style: TextStyle(fontSize: 12, color: textLight)),
                    Text(pickUp, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textWhite)),
                  ],
                ),
                const Text('→', style: TextStyle(color: textLight)),
                Column(
                  children: [
                    const Text("Drop Off", style: TextStyle(fontSize: 12, color: textLight)),
                    Text(dropOff, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textWhite)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Status and Button
            if (isDelivered)
              const Text("Delivered ✅", style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.w600))
            else ...[
              Text(
                onDelivery ? "Accepted by a deliverer" : "Not yet accepted",
                style: TextStyle(
                  color: onDelivery ? Colors.greenAccent : Colors.orangeAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              if (onDelivery)
                ElevatedButton.icon(
                  onPressed: () => showDeliveredDialog(context),
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text("Mark order as Delivered", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
