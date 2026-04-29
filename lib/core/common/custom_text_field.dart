import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.controller,
    this.validator,
    this.isPassword = false,
    this.obscureText,
    this.onSuffixPressed,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
    this.textDirection,
    this.textAlign,
    this.suffixIcon,
    this.suffixTooltip,
  });

  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool? obscureText;
  final VoidCallback? onSuffixPressed;
  final TextInputType? keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final IconData? suffixIcon;
  final String? suffixTooltip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.titleMedium?.copyWith(fontSize: 13.sp),
        ),
        8.verticalSpace,
        TextFormField(
          maxLines: maxLines,
          controller: controller,
          validator: validator,
          obscureText: obscureText ?? false,
          keyboardType: keyboardType,
          onChanged: onChanged,
          textDirection: textDirection,
          textAlign: textAlign ?? TextAlign.start,
          style: context.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(prefixIcon, size: 20.sp),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      (obscureText ?? false) ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20.sp,
                    ),
                    onPressed: onSuffixPressed,
                  )
                : suffixIcon != null
                    ? IconButton(
                        tooltip: suffixTooltip,
                        icon: Icon(suffixIcon, size: 20.sp),
                        onPressed: onSuffixPressed,
                      )
                : null,
          ),
        ),
      ],
    );
  }
}
