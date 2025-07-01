import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardBackend {
  final _statsDoc = FirebaseFirestore.instance.collection('dashboard').doc('stats');

  Future<void> _increment(String field) async {
    await _statsDoc.set(
      {field: FieldValue.increment(1)},
      SetOptions(merge: true),
    );
  }

  Future<void> logOrderPosted() async {
    await _increment('ordersPosted');
  }

  Future<void> logOrderAccepted() async {
    await _increment('ordersAccepted');
  }

  Future<void> logOrderDelivered() async {
    await _increment('ordersDelivered');
  }

  Future<void> logOrderCompleted() async {
    await _increment('ordersCompleted');
  }
}
