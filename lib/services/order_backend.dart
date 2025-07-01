import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import 'dashboard_backend.dart';

class OrderBackend {
  final _ordersRef = FirebaseFirestore.instance.collection('orders');
  final _acceptsRef = FirebaseFirestore.instance.collection('accepts');

  Future<void> postOrder(OrderModel order) async {
    await _ordersRef.add(order.toMap());
    await DashboardBackend().logOrderPosted();
  }

  Future<void> markOrderAsDelivered(String orderId) async {
    await _ordersRef.doc(orderId).update({'isAccepted': true});
    await DashboardBackend().logOrderDelivered();

  }

  Future<void> acceptOrder(OrderModel order) async {
    await _ordersRef.doc(order.id).update({'onDelivery': true});
    await DashboardBackend().logOrderAccepted();

    await _acceptsRef.add({
      'orderId': order.id,
      'title': order.title,
      'description': order.description,
      'pickUp': order.pickUp,
      'dropOff': order.dropOff,
      'price': order.price,
      'expiry': order.expiry,
      'acceptedAt': DateTime.now(),
      'onDelivery': true,
    });
  }

  Future<OrderModel?> getOrderByTitleAndExpiry(String title, DateTime expiry) async {
    final query = await _ordersRef
        .where('title', isEqualTo: title)
        .where('expiry', isEqualTo: Timestamp.fromDate(expiry))
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      return OrderModel.fromMap(doc.data(), doc.id);
    }

    return null;
  }

  Stream<List<OrderModel>> getOrdersStream() {
    return _ordersRef.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          return OrderModel.fromMap(doc.data(), doc.id);
        }).toList();
      },
    );
  }
}
