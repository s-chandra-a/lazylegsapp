import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazy_legs/pages/posted_orders.dart';
import 'package:lazy_legs/pages/wallet_page.dart';
import 'accepted_card.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1D1D1D);
    const cardColor = Color(0xFF2A2A2A);
    const textWhite = Colors.white;
    const textLight = Color(0xFFC0C0C0);
    const accentRed = Color(0xFFFF5C5C);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar:AppBar(
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Orders accepted by you",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textWhite),
            ),
            SizedBox(height: 16),
            _AcceptedOrdersList(),
          ],
        ),
      ),
    );
  }
}

class _AcceptedOrdersList extends StatelessWidget {
  const _AcceptedOrdersList();

  @override
  Widget build(BuildContext context) {
    const textWhite = Colors.white;
    const textLight = Color(0xFFC0C0C0);

    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('accepts')
            .where('onDelivery', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading orders', style: TextStyle(color: Colors.red)));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return (data['isAccepted'] != true) && (data['onDelivery'] == true);
          }).toList();

          if (docs.isEmpty) {
            return const Center(
              child: Text("No orders accepted yet.", style: TextStyle(color: textLight)),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return AcceptedCard(
                acceptId: docs[index].id,
                orderId: data['orderId'],
                title: data['title'] ?? 'No Title',
                description: data['description'] ?? '',
                pickUp: data['pickUp'] ?? '',
                dropOff: data['dropOff'] ?? '',
                price: (data['price'] ?? 0).toDouble(),
                expiry: (data['expiry'] as Timestamp).toDate(),
              );
            },
          );
        },
      ),
    );
  }
}
