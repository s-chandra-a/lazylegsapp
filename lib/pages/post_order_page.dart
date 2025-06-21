import 'package:flutter/material.dart';
import 'package:lazy_legs/pages/orders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/datePicker.dart';
import '../services/show_suggestions.dart';

extension CapTitleExtension on String {
  String get titleCapitalizeString => this
      .split(" ")
      .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : "")
      .join(" ");
}

class PostOrderPage extends StatefulWidget {
  const PostOrderPage({super.key});

  @override
  State<PostOrderPage> createState() => _PostOrderPageState();
}

class _PostOrderPageState extends State<PostOrderPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String pickUp = '';
  String dropOff = '';
  double price = 0.0;
  DateTime? expiry;

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final pickupController = TextEditingController();
  final dropoffController = TextEditingController();
  final priceController = TextEditingController();

  final List<String> pickupSuggestions = ['Gate 1', 'Gate 2', 'SP'];
  final List<String> dropoffSuggestions = ['B1', 'B5', 'B10'];
  final List<String> priceSuggestions = ['10', '20', '50'];

  void _submitOrder() async {
    if (_formKey.currentState!.validate() && expiry != null) {
      _formKey.currentState!.save();

      await FirebaseFirestore.instance.collection('orders').add({
        'title': title.titleCapitalizeString,
        'description': description,
        'pickUp': pickUp,
        'dropOff': dropOff,
        'price': price,
        'expiry': expiry,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order posted successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Post Order', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title
              TextFieldWithSuggestions(
                label: "Title:",
                hint: "e.g. Blinkit Package",
                controller: titleController,
                suggestions: [],
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => title = value ?? '',
              ),

              // Description
              TextFieldWithSuggestions(
                label: "Description:",
                hint: "e.g. Groceries, food...",
                controller: descController,
                suggestions: [],
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => description = value ?? '',
              ),

              // Pickup
              TextFieldWithSuggestions(
                label: "Pickup:",
                hint: "e.g. Gate 1",
                controller: pickupController,
                suggestions: pickupSuggestions,
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => pickUp = value ?? '',
              ),

              // Dropoff
              TextFieldWithSuggestions(
                label: "Dropoff:",
                hint: "e.g. B5",
                controller: dropoffController,
                suggestions: dropoffSuggestions,
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => dropOff = value ?? '',
              ),

              // Price
              TextFieldWithSuggestions(
                label: "Price:",
                hint: "e.g. 20",
                controller: priceController,
                suggestions: priceSuggestions,
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => price = double.tryParse(value ?? '') ?? 0.0,
              ),

              // Expiry picker
              Text("Expiry:", style: TextStyle(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () async {
                final selected = await pickExpiryDateTime(context);
                if (selected != null) {
                  setState(() {
                  expiry = selected;
                });
              }
            },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    expiry != null
                        ? expiry.toString()
                        : "Select date & time",
                    style: TextStyle(
                      color: expiry != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
              if (expiry == null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Required",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: _submitOrder,
                icon: Icon(Icons.add_card_rounded, color: Colors.black),
                label: Text("Pay 5© & Post order"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20.0,),
              ElevatedButton.icon(
                onPressed: _submitOrder,
                icon: Icon(Icons.credit_card, color: Colors.black),
                label: Text("Pay ₹5 & Post Order"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 16),
                  side: BorderSide(color: Colors.blueAccent, width: 1), // Add border here
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
