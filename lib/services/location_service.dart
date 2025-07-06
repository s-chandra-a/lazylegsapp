import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  static Future<List<String>> fetchPickupLocations() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('admin')
        .doc('PickupLocations')
        .get();

    final data = snapshot.data();
    if (data != null && data['locations'] is Map) {
      final locationsMap = Map<String, dynamic>.from(data['locations']);
      return locationsMap.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key)
          .toList();
    }
    return [];
  }

  static Future<List<String>> fetchDropOffLocations() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('admin')
        .doc('DropOffLocations')
        .get();

    final data = snapshot.data();
    if (data != null && data['locations'] is Map) {
      final locationsMap = Map<String, dynamic>.from(data['locations']);
      return locationsMap.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key)
          .toList();
    }
    return [];
  }

}
