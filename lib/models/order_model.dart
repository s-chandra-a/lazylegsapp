import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String title;
  final String description;
  final String pickUp;
  final String dropOff;
  final double price;
  final DateTime expiry;
  final bool isAccepted;
  final bool onDelivery;

  OrderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.pickUp,
    required this.dropOff,
    required this.price,
    required this.expiry,
    this.isAccepted = false,
    this.onDelivery = false,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      pickUp: map['pickUp'] ?? '',
      dropOff: map['dropOff'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      expiry: (map['expiry'] as Timestamp).toDate(),
      isAccepted: map['isAccepted'] ?? false,
      onDelivery: map['onDelivery'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'pickUp': pickUp,
      'dropOff': dropOff,
      'price': price,
      'expiry': expiry,
      'isAccepted': isAccepted,
      'onDelivery': onDelivery,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
