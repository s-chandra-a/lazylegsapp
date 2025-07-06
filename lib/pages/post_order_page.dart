import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazy_legs/services/dashboard_backend.dart';
import '../models/datePicker.dart';
import '../services/show_suggestions.dart';
import '../models/order_model.dart';
import '../services/order_backend.dart';
import 'package:lazy_legs/services/location_service.dart';


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

  final List<String> pickupSuggestions = [];
  final List<String> dropoffSuggestions = [];
  final List<String> priceSuggestions = ['10', '20', '50'];

  void _submitOrder() async {
    if (_formKey.currentState!.validate() && expiry != null) {
      _formKey.currentState!.save();

      final order = OrderModel(
        id: '', // will be assigned by Firestore
        title: title.titleCapitalizeString,
        description: description,
        pickUp: pickUp,
        dropOff: dropOff,
        price: price,
        expiry: expiry!,
      );

      await OrderBackend().postOrder(order);
      await DashboardBackend().logOrderPosted();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order posted successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    loadSuggestions();
  }

  Future<void> loadSuggestions() async {
    final pickups = await LocationService.fetchPickupLocations();
    final dropoffs = await LocationService.fetchDropOffLocations();
    setState(() {
      pickupSuggestions.clear();
      pickupSuggestions.addAll(pickups);
      dropoffSuggestions.clear();
      dropoffSuggestions.addAll(dropoffs);
    });
  }

  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1D1D1D);
    const cardColor = Color(0xFF2A2A2A);
    const textWhite = Colors.white;
    const textLight = Color(0xFFC0C0C0);
    const accentRed = Color(0xFFFF5C5C);
    const borderColor = Color(0xFF444444);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text('Post Order', style: TextStyle(color: textWhite)),
        iconTheme: const IconThemeData(color: textWhite),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFieldWithSuggestions(
                label: "Title:",
                hint: "e.g. Blinkit Package",
                controller: titleController,
                suggestions: [],
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => title = value ?? '',
              ),
              TextFieldWithSuggestions(
                label: "Package Arrival:",
                hint: "e.g. Groceries, food...",
                controller: descController,
                suggestions: [],
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => description = value ?? '',
              ),
              TextFieldWithSuggestions(
                label: "Pickup:",
                hint: "e.g. Gate 1",
                controller: pickupController,
                suggestions: pickupSuggestions,
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => pickUp = value ?? '',
              ),
              TextFieldWithSuggestions(
                label: "Dropoff:",
                hint: "e.g. B5",
                controller: dropoffController,
                suggestions: dropoffSuggestions,
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => dropOff = value ?? '',
              ),
              TextFieldWithSuggestions(
                label: "Price:",
                hint: "e.g. 20",
                controller: priceController,
                suggestions: priceSuggestions,
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => price = double.tryParse(value ?? '') ?? 0.0,
              ),

              const SizedBox(height: 20),

              const Text("Expiry:", style: TextStyle(color: textWhite, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
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
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(4),
                    color: cardColor,
                  ),
                  child: Text(
                    expiry != null ? expiry.toString() : "Select date & time",
                    style: TextStyle(
                      color: expiry != null ? textWhite : textLight,
                    ),
                  ),
                ),
              ),
              if (expiry == null)
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text("Required", style: TextStyle(color: Colors.red, fontSize: 12)),
                ),

              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: _submitOrder,
                icon: const Icon(Icons.add_card_rounded, color: textWhite),
                label: const Text("Pay ₹5 & Post Order"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: textWhite,
                  backgroundColor: accentRed,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 20.0),

              ElevatedButton.icon(
                onPressed: _submitOrder,
                icon: const Icon(Icons.credit_card, color: textWhite),
                label: const Text("Pay ₹5 & Post Order"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: textWhite,
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  side: const BorderSide(color: accentRed, width: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
