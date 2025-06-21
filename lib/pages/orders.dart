import 'package:flutter/material.dart';
import 'package:lazy_legs/pages/post_order_page.dart';
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
    // TODO: implement initState
    super.initState();
    fetchAcceptsCount();
  }

  void fetchAcceptsCount() async {
    final snapshot = await FirebaseFirestore.instance.collection('accepts').get();
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
        'expiry': order['expiry'], // DateTime will be stored as Timestamp
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                // TODO: Navigate to profile or show menu
                print("Profile tapped");
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, color: Colors.black),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('accepts').snapshots(),
                builder: (context, snapshot) {
                  int count = snapshot.hasData ? snapshot.data!.docs.length : 0;

                  return GestureDetector(
                    onTap: () {
                      print("Chat tapped");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(Icons.chat, color: Colors.black),
                        ),
                        if (count > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                              child: Center(
                                child: Text(
                                  '$count',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {

            });
            await Future.delayed(Duration(milliseconds: 500));
          },
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final now = DateTime.now();
                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final expiry = (data['expiry'] as Timestamp).toDate();
                  final isAccepted = data['isAccepted'] ?? false;
                  return expiry.difference(now).inMinutes > 0 && !isAccepted;
                }).toList();

                if (docs.isEmpty) {
                  return ListView(
                    children: [
                      Center(child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text('No orders available'),
                    ))],
                  );
                }
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return OrderCard(
                      title: data['title'] ?? 'No Title',
                      expiry: (data['expiry'] as Timestamp).toDate(),
                      pickUp: data['pickUp'] ?? 'No Pick Up Location',
                      description: data['description'] ?? 'No Description',
                      dropOff: data['dropOff'] ?? 'No Drop Off Location',
                      price: (data['price'] ?? 0).toDouble(),
                      onDelivery: data['onDelivery'] ?? false,
                    );
                  },
                );
              }
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Handle order posting action
          Navigator.push(context, MaterialPageRoute(builder: (context) => PostOrderPage()));
          print("Post Order button pressed");
        },
        backgroundColor: Colors.blueAccent,
        icon: Icon(Icons.add),
        label: Text("Post Order"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
