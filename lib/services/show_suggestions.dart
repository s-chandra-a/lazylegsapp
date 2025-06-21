import 'package:flutter/material.dart';

class TextFieldWithSuggestions extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final List<String> suggestions;
  final FormFieldValidator<String>? validator;
  final Function(String?)? onSaved;
  final IconData? icon;

  const TextFieldWithSuggestions({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.suggestions,
    this.validator,
    this.onSaved,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
            ),
            suffixIcon: icon != null ? Icon(icon) : null,
          ),
          validator: validator,
          onSaved: onSaved,
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: suggestions.map((item) {
            return ChoiceChip(
              label: Text(item),
              selected: false,
              backgroundColor: Colors.grey.shade100,
              onSelected: (_) => controller.text = item,
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
