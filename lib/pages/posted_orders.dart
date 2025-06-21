import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazy_legs/pages/posted_order.dart';

class PostedOrdersPage extends StatelessWidget {
  const PostedOrdersPage({super.key});

  void markAsDelivered(String orderId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'isAccepted': true,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order marked as delivered')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posted Orders", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return Center(child: Text("You haven't posted any orders."));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final bool isDelivered = data['isAccepted'] ?? false;
              final bool onDelivery = data['onDelivery'] ?? false;

              return PostedOrder(
                orderId: docs[index].id,
                title: data['title'] ?? "No Title",
                description: data['description'] ?? "",
                pickUp: data['pickUp'] ?? "",
                dropOff: data['dropOff'] ?? "",
                price: (data['price'] ?? 0).toDouble(),
                expiry: (data['expiry'] as Timestamp).toDate(),
                isDelivered: isDelivered,
                onDelivery: onDelivery,
                onMarkAsDelivered: () async {
                  try {
                    // Mark as delivered
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(docs[index].id)
                        .update({'isAccepted': true});

                    // Remove from 'accepts'
                    final acceptsSnapshot = await FirebaseFirestore.instance
                        .collection('accepts')
                        .where('orderId', isEqualTo: docs[index].id)
                        .limit(1)
                        .get();

                    if (acceptsSnapshot.docs.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('accepts')
                          .doc(acceptsSnapshot.docs.first.id)
                          .delete();
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
