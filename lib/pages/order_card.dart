import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lazy_legs/services/calculateTimeRemaining.dart';
import '../models/order_model.dart';
import '../services/order_backend.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF2A2A2A);
    const textWhite = Colors.white;
    const textLight = Color(0xFFC0C0C0);
    const badgeColor = Color(0xFFFF5C5C);
    const iconBg = Color(0xFF383838);

    int timeRemaining = calculateMinutesLeft(order.expiry);

    return Card(
      elevation: 4,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // const CircleAvatar(
                //   backgroundColor: iconBg,
                //   child: Icon(Icons.account_box, color: Colors.white),
                // ),
                // const SizedBox(width: 12),
                const Text("James Cam", style: TextStyle(color: textLight)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '₹${order.price}',
                    style: const TextStyle(color: textWhite, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Expiry
            Row(
              children: const [
                Icon(Icons.alarm, color: textLight, size: 18),
                SizedBox(width: 8.0),
                Text('Expires in ', style: TextStyle(fontSize: 14, color: textLight)),
              ],
            ),
            Text(
              '$timeRemaining mins',
              style: const TextStyle(fontSize: 14, color: textLight),
            ),

            const SizedBox(height: 10.0),

            // Title and Description
            Text(
              order.title,
              style: const TextStyle(fontSize: 22, color: textWhite, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(order.description, style: const TextStyle(color: textLight)),

            // Delivery Status
            if (order.onDelivery)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.directions_bike_rounded, color: Colors.greenAccent),
                    const SizedBox(width: 4.0),
                    Text(
                      "Package accepted by a deliverer",
                      style: TextStyle(fontSize: 14, color: Colors.green.shade400),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Pickup and Drop Off Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text('Pickup', style: TextStyle(fontSize: 12, color: textLight)),
                    Text(order.pickUp, style: const TextStyle(fontSize: 16, color: textWhite, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Text('→', style: TextStyle(fontSize: 20, color: textLight)),
                Column(
                  children: [
                    const Text('Drop Off', style: TextStyle(fontSize: 12, color: textLight)),
                    Text(order.dropOff, style: const TextStyle(fontSize: 16, color: textWhite, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Accept Order Button
            if (!order.onDelivery)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Fluttertoast.showToast(
                      msg: "You've accepted the order",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );

                    final backend = OrderBackend();
                    await backend.acceptOrder(order);
                  },
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text("Accept Order", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: badgeColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
