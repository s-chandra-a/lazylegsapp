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
      // Delete the document from 'accepts' using its doc ID
      await FirebaseFirestore.instance.collection('accepts').doc(acceptId).delete();

      // Reset order's onDelivery field
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'onDelivery': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delivery cancelled')),
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
        title: Text('Cancel Delivery'),
        content: Text('Are you sure you want to cancel this delivery?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('No')),
          TextButton(onPressed: () {
            Navigator.pop(context);
            cancelDelivery(context);
          }, child: Text('Yes')),
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
            // Header row
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.account_box, color: Colors.blue),
                ),
                Spacer(),
                Text("James Cam"),
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
            Row(
              children: [
                Icon(Icons.alarm),
                SizedBox(width: 8.0),
                Text(
                  'Expires at ${expiry.hour}:${expiry.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            Text(description),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Pickup', style: TextStyle(fontSize: 12, color: Colors.black)),
                    Text(pickUp, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(children: [
                  Text('..............', style: TextStyle(fontSize: 12, color: Colors.black)),
                ]),
                Column(
                  children: [
                    Text('Drop Off', style: TextStyle(fontSize: 12, color: Colors.black)),
                    Text(dropOff, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement chat navigation
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Chat not implemented yet")));
                    },
                    icon: Icon(Icons.chat),
                    label: Text("Chat"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => confirmCancel(context),
                    icon: Icon(Icons.cancel),
                    label: Text("Cancel Delivery", style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis, softWrap: false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      foregroundColor: Colors.red.shade900,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.0,),
          ],
        ),
      ),
    );
  }
}
