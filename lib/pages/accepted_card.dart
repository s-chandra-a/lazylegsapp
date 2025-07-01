import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcceptedCard extends StatelessWidget {
  final String orderId;
  final String title;
  final String description;
  final String pickUp;
  final String dropOff;
  final double price;
  final DateTime expiry;
  final String acceptId;

  const AcceptedCard({
    super.key,
    required this.orderId,
    required this.title,
    required this.description,
    required this.pickUp,
    required this.dropOff,
    required this.price,
    required this.expiry,
    required this.acceptId,
  });

  void cancelDelivery(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('accepts').doc(acceptId).delete();

      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'onDelivery': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delivery cancelled')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling delivery: $e')),
      );
    }
  }

  void confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Cancel Delivery', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to cancel this delivery?', style: TextStyle(color: Color(0xFFC0C0C0))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: Colors.blueAccent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cancelDelivery(context);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.redAccent)),
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
    const priceColor = Color(0xFFFF5C5C);

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
            // Header
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF3A3A3A),
                  child: Icon(Icons.account_box, color: textWhite),
                ),
                const Spacer(),
                const Text("James Cam", style: TextStyle(color: textLight)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: priceColor,
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

            Row(
              children: [
                const Icon(Icons.alarm, color: textLight),
                const SizedBox(width: 8.0),
                Text(
                  'Expires at ${expiry.hour}:${expiry.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 14, color: textLight),
                ),
              ],
            ),

            const SizedBox(height: 10.0),

            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textWhite)),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(color: textLight)),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text('Pickup', style: TextStyle(fontSize: 12, color: textLight)),
                    Text(pickUp, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textWhite)),
                  ],
                ),
                const Text('→', style: TextStyle(fontSize: 16, color: textLight)),
                Column(
                  children: [
                    const Text('Drop Off', style: TextStyle(fontSize: 12, color: textLight)),
                    Text(dropOff, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textWhite)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Chat not implemented yet")),
                      );
                    },
                    icon: const Icon(Icons.chat, color: textWhite),
                    label: const Text("Chat", style: TextStyle(color: textWhite)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: textWhite,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => confirmCancel(context),
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    label: const Text(
                      "Cancel Delivery",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade200,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
