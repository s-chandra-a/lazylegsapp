import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lazy_legs/services/calculateTimeRemaining.dart';

class OrderCard extends StatefulWidget {
  final String title;
  final DateTime expiry;
  final String pickUp;
  final String description;
  final String dropOff;
  final double price;
  final bool isAccepted; //true after successful delivery
  final bool onDelivery; // true after someone accepts to deliver

   const OrderCard({
    super.key,
    required this.title,
    required this.expiry,
    required this.pickUp,
    required this.description,
    required this.dropOff,
    required this.price,
    this.isAccepted = false,
     this.onDelivery = false,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    Color cardColor = widget.onDelivery ? Colors.grey.shade300 : Colors.white;
    int timeRemaining = calculateMinutesLeft(widget.expiry);
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
                      '₹${widget.price}',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.alarm),
                SizedBox(width: 8.0,),
                Text(
                  'Expires in $timeRemaining mins',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10.0,),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            Text(widget.description),
            if (widget.onDelivery)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.directions_bike_rounded),
                    SizedBox(width: 4.0,),
                    Text(
                      "Package accepted by a deliverer",
                      style: TextStyle(fontSize: 14, color: Colors.green.shade900),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Pickup',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    Text(
                      widget.pickUp,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '..............',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Drop Off',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    Text(
                      widget.dropOff,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                widget.onDelivery ? SizedBox(width: 40)
                :GestureDetector(
                  onTap: (){
                    //make the background color red
                    Fluttertoast.showToast(
                      msg: "Double tap to confirm order",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  },
                  onDoubleTap: () async {
                    Fluttertoast.showToast(
                      msg: "You've accepted the order",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    final orders = await FirebaseFirestore.instance
                        .collection('orders')
                        .where('title', isEqualTo: widget.title)
                        .where('expiry', isEqualTo: widget.expiry)
                        .limit(1)
                        .get();

                    if (orders.docs.isNotEmpty) {
                      final orderDoc = orders.docs.first;
                      final orderId = orderDoc.id;
                      final orderData = orderDoc.data();

                      // Update the order's onDelivery status
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .update({'onDelivery': true});

                      // Log acceptance in 'accepts' collection
                      await FirebaseFirestore.instance.collection('accepts').add({
                        'orderId': orderId,
                        'title': orderData['title'],
                        'description': orderData['description'],
                        'pickUp': orderData['pickUp'],
                        'dropOff': orderData['dropOff'],
                        'price': orderData['price'],
                        'expiry': orderData['expiry'],
                        'acceptedAt': DateTime.now(),
                        'onDelivery': true,
                      });
                    }

                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.check, color: Colors.black),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
