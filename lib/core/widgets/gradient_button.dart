import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';

enum GradientButtonSize { small, medium, large }

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient gradient;
  final GradientButtonSize size;
  final bool fullWidth;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.gradient = AppGradients.brand,
    this.size = GradientButtonSize.medium,
    this.fullWidth = false,
    this.isLoading = false,
  });

  const GradientButton.orange({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.size = GradientButtonSize.medium,
    this.fullWidth = false,
    this.isLoading = false,
  }) : gradient = AppGradients.orange;

  const GradientButton.green({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.size = GradientButtonSize.medium,
    this.fullWidth = false,
    this.isLoading = false,
  }) : gradient = AppGradients.green;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding;
    final double fontSize;
    final double iconSize;

    switch (size) {
      case GradientButtonSize.small:
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 7);
        fontSize = 12;
        iconSize = 12;
        break;
      case GradientButtonSize.large:
        padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
        fontSize = 16;
        iconSize = 16;
        break;
      case GradientButtonSize.medium:
      default:
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
        fontSize = 13;
        iconSize = 13;
    }

    final child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        else if (icon != null)
          Icon(icon, size: iconSize, color: Colors.white),
        if ((icon != null || isLoading) && label.isNotEmpty)
          SizedBox(width: iconSize * 0.5),
        if (label.isNotEmpty)
          Text(
            label,
            style: AppTextStyles.buttonSmall.copyWith(
              fontSize: fontSize,
              color: Colors.white,
            ),
          ),
      ],
    );

    final btn = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(11),
        child: Ink(
          decoration: BoxDecoration(
            gradient: onPressed == null
                ? const LinearGradient(
              colors: [AppColors.bgCardHover, AppColors.bgCardHover],
            )
                : gradient,
            borderRadius: BorderRadius.circular(11),
            boxShadow: onPressed != null
                ? [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.2),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ]
                : null,
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

// Bouton ghost (contour)
class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final GradientButtonSize size;
  final bool fullWidth;

  const OutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.size = GradientButtonSize.medium,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding;
    final double fontSize;

    switch (size) {
      case GradientButtonSize.small:
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 7);
        fontSize = 12;
        break;
      case GradientButtonSize.large:
        padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
        fontSize = 16;
        break;
      default:
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
        fontSize = 13;
    }

    final btn = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.bgCardHover,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(icon, size: fontSize, color: AppColors.textMuted),
              if (icon != null) const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.buttonSmall.copyWith(
                  fontSize: fontSize,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}