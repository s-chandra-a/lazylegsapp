import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardBackend {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Returns reference to: dashboard/{year}/{month}/{day}
  DocumentReference<Map<String, dynamic>> _getDailyDoc() {
    final now = DateTime.now().toUtc();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');

    return _firestore
        .collection('dashboard')
        .doc(year)
        .collection(month)
        .doc(day);
  }

  // Increment the counter field
  Future<void> _increment(String field) async {
    final docRef = _getDailyDoc();

    await docRef.set(
      {field: FieldValue.increment(1)},
      SetOptions(merge: true),
    );
  }

  // Public methods
  Future<void> logOrderPosted() async => await _increment('ordersPosted');
  Future<void> logOrderAccepted() async => await _increment('ordersAccepted');
  Future<void> logOrderDelivered() async => await _increment('ordersDelivered');
  Future<void> logOrderCompleted() async => await _increment('ordersCompleted');
  Future<void> logOrderCancelled() async => await _increment('ordersCancelled');
}
