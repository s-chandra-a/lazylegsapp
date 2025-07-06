import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazy_legs/pages/posted_order.dart';
import 'package:lazy_legs/pages/wallet_page.dart';

import '../services/dashboard_backend.dart';

class PostedOrdersPage extends StatelessWidget {
  const PostedOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1D1D1D);
    const textWhite = Colors.white;
    const textLight = Color(0xFFC0C0C0);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text('Orders', style: TextStyle(color: textWhite, fontSize: 20, fontWeight: FontWeight.bold)),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletPage()));
              },
              child: const CircleAvatar(
                backgroundColor: Color(0xFF2A2A2A),
                radius: 18,
                child: Icon(Icons.person, color: textWhite),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading orders", style: TextStyle(color: Colors.redAccent)),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text("You haven't posted any orders.", style: TextStyle(color: textLight)),
            );
          }

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
                    final orderId = docs[index].id;

                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(orderId)
                        .update({'isAccepted': true});

                    final acceptsSnapshot = await FirebaseFirestore.instance
                        .collection('accepts')
                        .where('orderId', isEqualTo: orderId)
                        .limit(1)
                        .get();

                    if (acceptsSnapshot.docs.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('accepts')
                          .doc(acceptsSnapshot.docs.first.id)
                          .delete();
                    }

                    await DashboardBackend().logOrderDelivered();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order marked as delivered'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                        backgroundColor: Colors.red.shade400,
                        behavior: SnackBarBehavior.floating,
                      ),
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
