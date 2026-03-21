import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/constants.dart';
import '../../app/utils/helpers.dart';
import '../../features/auth/auth_provider.dart';
import '../../features/home/home_provider.dart';
import 'gradient_text.dart';
import 'month_navigator.dart';

class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthHeaderProvider);
    final user = ref.watch(currentUserProvider);
    final now = DateTime.now();
    final canNext = AppHelpers.canGoNextMonth(
      selectedMonth.$1,
      selectedMonth.$2,
    );

    return Container(
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.headerBg,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          // Brand
          GradientText(
            'E-',
            gradient: AppGradients.brand,
            style: AppTextStyles.brand,
          ),
          GradientText(
            'VAROOTRA',
            gradient: AppGradients.orange,
            style: AppTextStyles.brand,
          ),

          const SizedBox(width: 8),

          // Navigateur mois compact
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.bgCardHover,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bouton precedent
                  GestureDetector(
                    onTap: () => ref
                        .read(selectedMonthHeaderProvider.notifier)
                        .previous(),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.bgCardHover,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),

                  // Label mois
                  Text(
                    '${AppConstants.monthsShort[selectedMonth.$1]} ${selectedMonth.$2}',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),

                  // Bouton suivant
                  GestureDetector(
                    onTap: canNext
                        ? () => ref
                        .read(selectedMonthHeaderProvider.notifier)
                        .next()
                        : null,
                    child: Opacity(
                      opacity: canNext ? 1.0 : 0.3,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.bgCardHover,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          size: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Avatar utilisateur
          GestureDetector(
            onTap: () => _showMoreSheet(context, ref),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: AppGradients.brand,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  user?.initiale ?? 'A',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _MoreSheet(),
    );
  }
}

class _MoreSheet extends ConsumerWidget {
  const _MoreSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: AppGradients.sheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: AppColors.border),
          left: BorderSide(color: AppColors.border),
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pull indicator
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.textFaint,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header user
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      gradient: AppGradients.brand,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user?.initiale ?? 'A',
                        style: AppTextStyles.headlineMedium
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.nomComplet ?? 'Utilisateur',
                        style: AppTextStyles.labelLarge,
                      ),
                      Text(
                        '@${user?.pseudo ?? ''}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),
              Divider(color: AppColors.border),
              const SizedBox(height: 6),

              // Menu items
              _MoreItem(
                icon: Icons.people_outline,
                gradient: AppGradients.brand,
                title: 'Clients',
                subtitle: 'Gerer la liste des clients',
                onTap: () {
                  Navigator.pop(context);
                  // Navigation via router
                },
              ),
              _MoreItem(
                icon: Icons.inventory_2_outlined,
                gradient: AppGradients.orange,
                title: 'Produits',
                subtitle: 'Catalogue & historique des prix',
                onTap: () => Navigator.pop(context),
              ),
              _MoreItem(
                icon: Icons.bar_chart_outlined,
                gradient: AppGradients.violet,
                title: 'Tableau de bord',
                subtitle: 'Analyses et graphiques',
                onTap: () => Navigator.pop(context),
              ),

              const SizedBox(height: 6),
              Divider(color: AppColors.border),

              // Deconnexion
              _MoreItem(
                icon: Icons.logout,
                gradient: const LinearGradient(
                  colors: [AppColors.danger, AppColors.danger],
                ),
                title: 'Deconnexion',
                subtitle: 'Quitter l\'application',
                titleColor: AppColors.danger,
                onTap: () async {
                  Navigator.pop(context);
                  await ref.read(authProvider.notifier).logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreItem extends StatelessWidget {
  final IconData icon;
  final LinearGradient gradient;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? titleColor;

  const _MoreItem({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: titleColor ?? AppColors.textPrimary,
                    ),
                  ),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textFaint,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// Provider mois pour le header (partage avec home)
class HeaderMonthNotifier extends StateNotifier<(int, int)> {
  HeaderMonthNotifier()
      : super((DateTime.now().month, DateTime.now().year));

  void previous() {
    int m = state.$1 - 1;
    int y = state.$2;
    if (m < 1) { m = 12; y--; }
    state = (m, y);
  }

  void next() {
    final now = DateTime.now();
    int m = state.$1 + 1;
    int y = state.$2;
    if (m > 12) { m = 1; y++; }
    if (y > now.year || (y == now.year && m > now.month)) return;
    state = (m, y);
  }

  bool get canGoNext {
    final now = DateTime.now();
    return !(state.$2 == now.year && state.$1 >= now.month);
  }
}

final selectedMonthHeaderProvider =
StateNotifierProvider<HeaderMonthNotifier, (int, int)>((ref) {
  return HeaderMonthNotifier();
});