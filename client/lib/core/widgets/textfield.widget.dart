// ══════════════════════════════════════════════════════════════════════════════
// ZINTRA TEXT FIELD
// ══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

class ZintraTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final int? maxLines;

  const ZintraTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.keyboardType,
    this.onChanged,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        label: Text(label ?? ""),
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withAlpha(100),
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? GestureDetector(onTap: onSuffixTap, child: Icon(suffixIcon))
            : null,
      ),
    );
  }
}
