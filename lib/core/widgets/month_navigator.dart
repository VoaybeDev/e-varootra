import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/constants.dart';
import '../../app/utils/helpers.dart';
import 'gradient_text.dart';

class MonthNavigator extends StatelessWidget {
  final int month;
  final int year;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;

  const MonthNavigator({
    super.key,
    required this.month,
    required this.year,
    required this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final canNext = AppHelpers.canGoNextMonth(month, year);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: GradientText(
              '${AppConstants.months[month]} $year',
              gradient: AppGradients.brand,
              style: AppTextStyles.headlineSmall,
            ),
          ),
          Row(
            children: [
              _NavBtn(
                icon: Icons.chevron_left,
                onTap: onPrevious,
              ),
              const SizedBox(width: 6),
              _NavBtn(
                icon: Icons.chevron_right,
                onTap: canNext ? onNext : null,
                disabled: !canNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool disabled;

  const _NavBtn({
    required this.icon,
    this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.3 : 1.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.bgCardHover,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 12, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}