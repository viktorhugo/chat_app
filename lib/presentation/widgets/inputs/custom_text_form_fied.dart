import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {

  final String? label;
  final String? hint;
  final String? errorMessage;
  final Icon? icon;
  final Icon? suffixIcon;
  final bool? obscureText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key, 
    this.label, 
    this.hint, 
    this.errorMessage, 
    this.onChanged, 
    this.validator,
    this.icon,
    this.obscureText,
    this.suffixIcon
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      // borderSide: BorderSide(color: colors.primary),
    );

    return  TextFormField(
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText ?? false,
      
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border.copyWith(borderSide: BorderSide(color: colors.primary)),
        focusColor: colors.primary,
        isDense: true,
        label: label != null ? Text(label!) : null,
        hintText: hint,
        prefixIcon: icon,
        suffixIcon: suffixIcon,
        // errorText: 'Error text',
        errorText: errorMessage,
        errorBorder: border.copyWith( borderSide: BorderSide(color: Colors.red.shade800)),
        focusedErrorBorder:  border.copyWith( borderSide: BorderSide(color: Colors.red.shade800)),
      ),
    );
  }
}