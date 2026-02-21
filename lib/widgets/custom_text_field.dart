import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int maxLines;
  final IconData? icon; // Optional icon if needed

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.maxLines = 1,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                // OnSurface color handles light/dark appropriately
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          maxLines: maxLines,
          style: Theme.of(context).textTheme.bodyLarge, // Ensure text color matches theme
          decoration: InputDecoration(
            hintText: 'Enter $label',
            prefixIcon: icon != null ? Icon(icon) : null,
            // Borders and FillColor are now handled by Theme.of(context).inputDecorationTheme
            // We can override if necessary, but relying on theme is better for consistency.
            // If we want slightly different defaults for this widget, we can keep some,
            // but for the "invisible text" bug, we mainly need the proper style inheritance.
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
        ),
      ],
    );
  }
}
