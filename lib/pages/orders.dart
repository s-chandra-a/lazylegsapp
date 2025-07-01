import 'package:flutter/material.dart';
import 'package:lazy_legs/pages/post_order_page.dart';
import 'package:lazy_legs/pages/wallet_page.dart';
import '../models/order_model.dart';
import 'chat_page.dart';
import 'order_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazy_legs/services/order_service.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  int acceptsCount = 0;

  @override
  void initState() {
    super.initState();
    fetchAcceptsCount();
  }

  void fetchAcceptsCount() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('accepts').get();
    setState(() {
      acceptsCount = snapshot.docs.length;
    });
  }

  final OrderService _orderService = OrderService();

  void uploadOrders(List<Map<String, dynamic>> orders) {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('orders');

    for (var order in orders) {
      collection.add({
        'title': order['title'],
        'expiry': order['expiry'],
        'pickUp': order['pickUp'],
        'description': order['description'],
        'dropOff': order['dropOff'],
        'price': order['price'],
        'createdAt': FieldValue.serverTimestamp(),
      }).then((doc) {
        print("Order uploaded: ${doc.id}");
      }).catchError((error) {
        print("Upload failed: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const scaffoldBg = Color(0xFF1D1D1D);
    const cardColor = Color(0xFF2A2A2A);
    const accentRed = Color(0xFFFF5C5C);
    const whiteText = Colors.white;
    const lightText = Color(0xFFC0C0C0);
    const backgroundColor = Color(0xFF1D1D1D);
    const textWhite = Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBg,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Error loading orders',
                    style: TextStyle(color: accentRed),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final now = DateTime.now();
              final docs = snapshot.data!.docs;

              final orders = docs
                  .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                  .where((order) =>
              order.expiry.difference(now).inMinutes > 0 && !order.isAccepted)
                  .toList();

              if (orders.isEmpty) {
                return ListView(
                  children: const [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Text(
                          'No orders available',
                          style: TextStyle(color: lightText, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                );
              }


              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return OrderCard(order: orders[index]);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PostOrderPage()));
        },
        icon: const Icon(Icons.add),
        label: const Text("Post Order", style: TextStyle(color: whiteText)),
        backgroundColor: accentRed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
