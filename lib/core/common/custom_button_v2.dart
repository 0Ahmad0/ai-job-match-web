import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../theme/app_theme.dart';

enum ButtonVariant {
  primary,
  secondary,
  success,
  warning,
  error,
  text,
  outline,
  outlineSecondary,
  ghost,
  gradient,
}

enum ButtonSize { small, medium, large }

class CustomButtonV2 extends StatelessWidget {
  const CustomButtonV2({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.leading,
    this.trailing,
    this.borderRadius,
    this.width,
    this.fullWidth = true,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isEnabled;
  final Widget? leading;
  final Widget? trailing;
  final double? borderRadius;
  final double? width;
  final bool fullWidth;

  double get _height {
    switch (size) {
      case ButtonSize.small:
        return 40.h;
      case ButtonSize.medium:
        return 52.h;
      case ButtonSize.large:
        return 64.h;
    }
  }

  double get _radius => borderRadius ?? AppTheme.radiusLarge;

  Color _getBackgroundColor(BuildContext context) {
    if (!isEnabled) {
      return context.theme.dividerColor;
    }

    switch (variant) {
      case ButtonVariant.primary:
        return AppTheme.primaryColor;
      case ButtonVariant.secondary:
        return AppTheme.secondaryColor;
      case ButtonVariant.success:
        return AppTheme.successColor;
      case ButtonVariant.warning:
        return AppTheme.warningColor;
      case ButtonVariant.error:
        return AppTheme.errorColor;
      case ButtonVariant.text:
      case ButtonVariant.outline:
      case ButtonVariant.outlineSecondary:
      case ButtonVariant.ghost:
        return Colors.transparent;
      case ButtonVariant.gradient:
        return Colors.transparent;
    }
  }

  Color _getTextColor(BuildContext context) {
    if (!isEnabled) {
      return context.theme.dividerColor;
    }

    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.success:
      case ButtonVariant.warning:
      case ButtonVariant.error:
      case ButtonVariant.gradient:
        return Colors.white;
      case ButtonVariant.text:
        return AppTheme.primaryColor;
      case ButtonVariant.outline:
        return AppTheme.primaryColor;
      case ButtonVariant.outlineSecondary:
        return AppTheme.secondaryColor;
      case ButtonVariant.ghost:
        return context.theme.textTheme.bodyLarge?.color ?? Colors.black;
    }
  }

  BoxBorder? _getBorder(BuildContext context) {
    if (!isEnabled) {
      return Border.all(color: context.theme.dividerColor);
    }

    switch (variant) {
      case ButtonVariant.outline:
        return Border.all(color: AppTheme.primaryColor, width: 1.5);
      case ButtonVariant.outlineSecondary:
        return Border.all(color: AppTheme.secondaryColor, width: 1.5);
      case ButtonVariant.ghost:
        return Border.all(color: context.theme.dividerColor);
      default:
        return null;
    }
  }

  List<BoxShadow>? _getShadow() {
    if (!isEnabled || variant == ButtonVariant.text || variant == ButtonVariant.ghost) {
      return null;
    }
    return AppTheme.shadowSmall;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : (width ?? 100.w),
      height: _height,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: variant == ButtonVariant.gradient ? AppTheme.primaryGradient : null,
            color: variant == ButtonVariant.gradient ? null : _getBackgroundColor(context),
            borderRadius: BorderRadius.circular(_radius.r),
            border: _getBorder(context),
            boxShadow: _getShadow(),
          ),
          child: InkWell(
            onTap: isEnabled && !isLoading ? onPressed : null,
            borderRadius: BorderRadius.circular(_radius.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null && !isLoading) ...[
                    leading!,
                    8.horizontalSpace,
                  ],
                  if (isLoading) ...[
                    SizedBox(
                      width: 16.sp,
                      height: 16.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(_getTextColor(context)),
                      ),
                    ),
                    8.horizontalSpace,
                  ],
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: _getTextColor(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (trailing != null && !isLoading) ...[
                    8.horizontalSpace,
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Backward compatible alias for existing code
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.icon,
  });

  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? context.theme.primaryColor,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              10.horizontalSpace,
            ],
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelLarge?.copyWith(
                  color: textColor ?? Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
