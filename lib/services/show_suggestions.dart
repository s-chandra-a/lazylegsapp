import 'package:flutter/material.dart';

class TextFieldWithSuggestions extends StatefulWidget {
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
  State<TextFieldWithSuggestions> createState() => _TextFieldWithSuggestionsState();
}

class _TextFieldWithSuggestionsState extends State<TextFieldWithSuggestions> {
  String? selectedSuggestion;

  @override
  Widget build(BuildContext context) {
    const Color fieldBg = Color(0xFF2A2A2A);
    const Color textColor = Colors.white;
    const Color hintColor = Color(0xFFC0C0C0);
    const Color borderColor = Color(0xFF444444);

    final hasSuggestions = widget.suggestions.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 6),
        hasSuggestions
            ? DropdownButtonFormField<String>(
          value: selectedSuggestion,
          hint: Text(widget.hint, style: const TextStyle(color: hintColor)),
          items: widget.suggestions
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item, style: const TextStyle(color: textColor)),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedSuggestion = value;
              widget.controller.text = value ?? '';
            });
          },
          onSaved: widget.onSaved,
          validator: widget.validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          dropdownColor: fieldBg,
        )
            : TextFormField(
          controller: widget.controller,
          style: const TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: hintColor),
            filled: true,
            fillColor: fieldBg,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(6),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
              borderRadius: BorderRadius.circular(6),
            ),
            suffixIcon: widget.icon != null ? Icon(widget.icon, color: hintColor) : null,
          ),
          validator: widget.validator,
          onSaved: widget.onSaved,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
