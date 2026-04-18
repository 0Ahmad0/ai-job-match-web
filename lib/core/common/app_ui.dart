import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../theme/app_theme.dart';
import '../utils/image_url_util.dart';
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.textTheme.headlineSmall),
        if (subtitle != null) ...[
          AppTheme.spacing6.verticalSpace,
          Text(subtitle!, style: context.textTheme.bodyMedium),
        ],
      ],
    );

    if (trailing == null) {
      return content;
    }

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: AppTheme.spacing10.h,
      spacing: AppTheme.spacing12.w,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 560.w),
          child: content,
        ),
        trailing!,
      ],
    );
  }
}

class AppStateCard extends StatelessWidget {
  const AppStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.maxWidth,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  final double? maxWidth;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 620.w),
        child: Container(
          padding: EdgeInsets.all(AppTheme.spacing28.r),
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusXXL.r),
            border: Border.all(color: context.theme.dividerColor),
            boxShadow: AppTheme.shadowSmall,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76.w,
                height: 76.w,
                decoration: BoxDecoration(
                  color: (iconColor ?? context.theme.primaryColor).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 34.sp,
                  color: iconColor ?? context.theme.primaryColor,
                ),
              ),
              18.verticalSpace,
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall,
              ),
              10.verticalSpace,
              Text(
                message,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium,
              ),
              if (action != null) ...[
                22.verticalSpace,
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AppPageContainer extends StatelessWidget {
  const AppPageContainer({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth.w),
        child: Padding(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: AppTheme.spacing20.w,
                vertical: AppTheme.spacing18.h,
              ),
          child: child,
        ),
      ),
    );
  }
}

class AppUserAvatar extends StatelessWidget {
  const AppUserAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 24,
    this.onTap,
  });

  final String name;
  final String? imageUrl;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1).toUpperCase())
        .join();
    final normalizedImageUrl = ImageUrlUtil.normalize(imageUrl);
    final hasImage = normalizedImageUrl.isNotEmpty;
    final diameter = radius.r * 2;

    Widget initialsFallback() {
      return Center(
        child: Text(
          initials.isEmpty ? '?' : initials,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.theme.primaryColor,
          ),
        ),
      );
    }

    final avatar = CircleAvatar(
      radius: radius.r,
      backgroundColor: context.theme.primaryColor.withValues(alpha: 0.12),
      child: ClipOval(
        child: SizedBox(
          width: diameter,
          height: diameter,
          child: hasImage
              ? CachedNetworkImage(
                  imageUrl: normalizedImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: context.theme.primaryColor.withValues(alpha: 0.08),
                    child: const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: context.theme.primaryColor.withValues(alpha: 0.08),
                    child: initialsFallback(),
                  ),
                )
              : initialsFallback(),
        ),
      ),
    );

    if (onTap == null) {
      return avatar;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: avatar,
    );
  }
}

// ===== NEW THEMED CONTAINER COMPONENTS =====

class AppThemedCard extends StatelessWidget {
  const AppThemedCard({
    super.key,
    required this.child,
    this.onTap,
    this.elevation = AppElevation.medium,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.border,
  });

  final Widget child;
  final VoidCallback? onTap;
  final AppElevation elevation;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final shadowList = _getShadowList(elevation);

    Widget card = Container(
      padding: padding ?? EdgeInsets.all(AppTheme.spacing16.r),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.theme.cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusXXL.r),
        border: border ?? Border.all(color: context.theme.dividerColor, width: 0.5),
        boxShadow: shadowList,
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusXXL.r),
        child: card,
      ),
    );
  }

  List<BoxShadow> _getShadowList(AppElevation elevation) {
    switch (elevation) {
      case AppElevation.none:
        return AppTheme.shadowNone;
      case AppElevation.small:
        return AppTheme.shadowSmall;
      case AppElevation.medium:
        return AppTheme.shadowMedium;
      case AppElevation.large:
        return AppTheme.shadowLarge;
      case AppElevation.extraLarge:
        return AppTheme.shadowXL;
    }
  }
}

class AppThemedSurface extends StatelessWidget {
  const AppThemedSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.borderRadius = AppTheme.radiusXXL,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget surface = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: child,
    );

    if (onTap == null) return surface;

    return GestureDetector(
      onTap: onTap,
      child: surface,
    );
  }
}

class AppThemedListTile extends StatelessWidget {
  const AppThemedListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.showDivider = false,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    Widget tile = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16.w,
        vertical: AppTheme.spacing12.h,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            AppTheme.spacing12.horizontalSpace,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                title,
                if (subtitle != null) ...[
                  AppTheme.spacing4.verticalSpace,
                  DefaultTextStyle(
                    style: context.textTheme.bodySmall ??
                        const TextStyle(fontSize: 12, color: Colors.grey),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            AppTheme.spacing12.horizontalSpace,
            trailing!,
          ],
        ],
      ),
    );

    if (showDivider) {
      tile = Column(
        children: [
          tile,
          Divider(
            height: 1,
            color: context.theme.dividerColor,
          ),
        ],
      );
    }

    if (onTap == null) return tile;

    return Material(
      color: backgroundColor ?? Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: tile,
      ),
    );
  }
}

class AppThemedStatCard extends StatelessWidget {
  const AppThemedStatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppTheme.primaryColor;

    Widget card = AppThemedCard(
      elevation: AppElevation.small,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              padding: EdgeInsets.all(AppTheme.spacing12.r),
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium.r),
              ),
              child: Icon(
                icon,
                color: cardColor,
                size: 28.sp,
              ),
            ),
            AppTheme.spacing12.verticalSpace,
          ],
          Text(
            value,
            style: context.textTheme.headlineSmall?.copyWith(
              color: cardColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          AppTheme.spacing4.verticalSpace,
          Text(
            label,
            style: context.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    return card;
  }
}

enum AppElevation { none, small, medium, large, extraLarge }
