import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_job_matcher/core/theme/app_theme.dart';

enum ButtonVariant {
  primary,
  secondary,
  success,
  warning,
  error,
  text,
  outline,
  outlineSecondary,
  gradient,
  disabled,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leading,
    this.trailing,
    this.borderRadius,
    // Deprecated props for backward compatibility
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? leading;
  final Widget? trailing;
  final double? borderRadius;

  // Deprecated props (kept for backward compatibility)
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final Widget? icon;

  double get _height {
    if (height != null) return height!;
    return switch (size) {
      ButtonSize.small => 40.h,
      ButtonSize.medium => 52.h,
      ButtonSize.large => 64.h,
    };
  }

  double get _borderRadius => borderRadius ?? AppTheme.radiusLarge;

  Color get _backgroundColor {
    // Use deprecated color prop if provided
    if (color != null && variant == ButtonVariant.primary) {
      return color!;
    }

    return switch (variant) {
      ButtonVariant.primary => AppTheme.primaryColor,
      ButtonVariant.secondary => AppTheme.secondaryColor,
      ButtonVariant.success => AppTheme.successColor,
      ButtonVariant.warning => AppTheme.warningColor,
      ButtonVariant.error => AppTheme.errorColor,
      ButtonVariant.text => Colors.transparent,
      ButtonVariant.outline => Colors.transparent,
      ButtonVariant.outlineSecondary => Colors.transparent,
      ButtonVariant.gradient => Colors.transparent,
      ButtonVariant.disabled => AppTheme.lightMuted.withValues(alpha: 0.3),
    };
  }

  Color get _foregroundColor {
    if (textColor != null && variant == ButtonVariant.primary) {
      return textColor!;
    }

    return switch (variant) {
      ButtonVariant.primary ||
      ButtonVariant.secondary ||
      ButtonVariant.success ||
      ButtonVariant.warning =>
        Colors.white,
      ButtonVariant.error => Colors.white,
      ButtonVariant.text => AppTheme.primaryColor,
      ButtonVariant.outline => AppTheme.primaryColor,
      ButtonVariant.outlineSecondary => AppTheme.secondaryColor,
      ButtonVariant.gradient => Colors.white,
      ButtonVariant.disabled => AppTheme.lightMuted,
    };
  }

  BorderSide get _borderSide {
    return switch (variant) {
      ButtonVariant.outline =>
        const BorderSide(color: AppTheme.primaryColor, width: 1.5),
      ButtonVariant.outlineSecondary =>
        const BorderSide(color: AppTheme.secondaryColor, width: 1.5),
      _ => BorderSide.none,
    };
  }

  List<BoxShadow> get _shadows {
    return switch (variant) {
      ButtonVariant.primary ||
      ButtonVariant.secondary ||
      ButtonVariant.success =>
        AppTheme.shadowMedium,
      ButtonVariant.warning || ButtonVariant.error => AppTheme.shadowMedium,
      _ => AppTheme.shadowNone,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    final isDisabled = variant == ButtonVariant.disabled || onPressed == null;
    final effectiveLeading = icon ?? leading;

    Widget buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18.sp,
            height: 18.sp,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_foregroundColor),
            ),
          ),
          12.horizontalSpace,
        ] else if (effectiveLeading != null) ...[
          effectiveLeading,
          8.horizontalSpace,
        ],
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelLarge?.copyWith(
              color: _foregroundColor,
            ),
          ),
        ),
        if (trailing != null && !isLoading) ...[
          8.horizontalSpace,
          trailing!,
        ],
      ],
    );

    // Gradient variant special handling
    if (variant == ButtonVariant.gradient) {
      return Container(
        width: isFullWidth ? double.infinity : width,
        height: _height,
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: _shadows,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: BorderRadius.circular(_borderRadius),
            child: Center(child: buttonContent),
          ),
        ),
      );
    }

    // Standard button variants
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: _height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          foregroundColor: _foregroundColor,
          disabledBackgroundColor: isDarkMode
              ? AppTheme.darkMuted.withValues(alpha: 0.2)
              : AppTheme.lightMuted.withValues(alpha: 0.3),
          disabledForegroundColor: isDarkMode
              ? AppTheme.darkMuted.withValues(alpha: 0.6)
              : AppTheme.lightMuted.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            side: _borderSide,
          ),
          elevation: variant == ButtonVariant.outline ||
                  variant == ButtonVariant.outlineSecondary ||
                  variant == ButtonVariant.text
              ? 0
              : null,
          shadowColor: Colors.black.withValues(alpha: 0.2),
        ),
        child: buttonContent,
      ),
    );
  }
}
