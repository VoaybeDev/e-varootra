import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/constants.dart';
import '../../app/utils/helpers.dart';

class BadgeStatus extends StatelessWidget {
  final String status;

  const BadgeStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = AppHelpers.statusColor(status);
    final bg = AppHelpers.statusBadgeBg(status);
    final border = AppHelpers.statusBadgeBorder(status);

    final IconData icon;
    final String label;

    switch (status) {
      case AppConstants.statusPaid:
        icon = Icons.check_circle_outline;
        label = 'Payee';
        break;
      case AppConstants.statusPartial:
        icon = Icons.adjust_outlined;
        label = 'Partielle';
        break;
      default:
        icon = Icons.schedule_outlined;
        label = 'Active';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.badge.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}