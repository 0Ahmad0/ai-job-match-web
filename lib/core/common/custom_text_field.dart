import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool? obscureText;
  final VoidCallback? onSuffixPressed;
  final TextInputType? keyboardType;
  final int? maxLines;

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
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Text
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.theme.textTheme.bodyLarge?.color,
          ),
        ),
        8.verticalSpace,

        // The Input Field
        TextFormField(
          maxLines: maxLines,
          controller: controller,
          validator: validator,
          obscureText: obscureText ?? false,
          keyboardType: keyboardType,
          style: GoogleFonts.cairo(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(
              prefixIcon,
              size: 20.sp,
              color: context.theme.primaryColor.withValues(alpha: 0.7),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      (obscureText ?? false)
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20.sp,
                      color: Colors.grey,
                    ),
                    onPressed: onSuffixPressed,
                  )
                : null,
            filled: true,
            fillColor: context.isDarkMode
                ? const Color(0xFF2D2D44)
                : Colors.grey.shade100,
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
            border: _buildBorder(Colors.transparent),
            enabledBorder: _buildBorder(Colors.transparent),
            focusedBorder: _buildBorder(context.theme.primaryColor),
            errorBorder: _buildBorder(Colors.red),
            focusedErrorBorder: _buildBorder(Colors.red),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }
}
