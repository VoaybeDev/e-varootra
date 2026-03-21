import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';

enum NavTab { home, debts, archive, more }

final currentNavTabProvider = StateProvider<NavTab>((ref) => NavTab.home);

class AppBottomNav extends ConsumerWidget {
  final VoidCallback onFabPressed;

  const AppBottomNav({super.key, required this.onFabPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentNavTabProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.navBg,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              // Accueil
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Accueil',
                isActive: currentTab == NavTab.home,
                onTap: () {
                  ref.read(currentNavTabProvider.notifier).state = NavTab.home;
                  context.go(AppRoutes.home);
                },
              ),

              // Dettes
              _NavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                label: 'Dettes',
                isActive: currentTab == NavTab.debts,
                onTap: () {
                  ref.read(currentNavTabProvider.notifier).state = NavTab.debts;
                  context.go(AppRoutes.debts);
                },
              ),

              // FAB central
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 62,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            top: -10,
                            child: GestureDetector(
                              onTap: onFabPressed,
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: AppGradients.brand,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accent.withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: AppColors.bgDeep,
                                    width: 4,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            child: Text(
                              'Facture',
                              style: AppTextStyles.navLabel.copyWith(
                                color: AppColors.textFaint,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Archive
              _NavItem(
                icon: Icons.archive_outlined,
                activeIcon: Icons.archive,
                label: 'Archive',
                isActive: currentTab == NavTab.archive,
                onTap: () {
                  ref.read(currentNavTabProvider.notifier).state =
                      NavTab.archive;
                  context.go(AppRoutes.archive);
                },
              ),

              // Plus
              _NavItem(
                icon: Icons.more_horiz,
                activeIcon: Icons.more_horiz,
                label: 'Plus',
                isActive: currentTab == NavTab.more,
                onTap: () {
                  ref.read(currentNavTabProvider.notifier).state = NavTab.more;
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const _MoreBottomSheet(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int? badge;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  size: 22,
                  color: isActive ? AppColors.accent : AppColors.textFaint,
                ),
                if (badge != null && badge! > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        gradient: AppGradients.rose,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$badge',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label.toUpperCase(),
              style: AppTextStyles.navLabel.copyWith(
                color: isActive ? AppColors.accent : AppColors.textFaint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreBottomSheet extends ConsumerWidget {
  const _MoreBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              _SheetItem(
                icon: Icons.people_outline,
                gradient: AppGradients.brand,
                title: 'Clients',
                subtitle: 'Gerer la liste des clients',
                onTap: () {
                  Navigator.pop(context);
                  context.go(AppRoutes.clients);
                },
              ),
              _SheetItem(
                icon: Icons.inventory_2_outlined,
                gradient: AppGradients.orange,
                title: 'Produits',
                subtitle: 'Catalogue & historique des prix',
                onTap: () {
                  Navigator.pop(context);
                  context.go(AppRoutes.products);
                },
              ),
              _SheetItem(
                icon: Icons.bar_chart_outlined,
                gradient: AppGradients.violet,
                title: 'Tableau de bord',
                subtitle: 'Analyses et graphiques',
                onTap: () {
                  Navigator.pop(context);
                  context.go(AppRoutes.dashboard);
                },
              ),
              Divider(color: AppColors.border, height: 24),
              _SheetItem(
                icon: Icons.logout,
                gradient: const LinearGradient(
                    colors: [AppColors.danger, AppColors.danger]),
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

class _SheetItem extends StatelessWidget {
  final IconData icon;
  final LinearGradient gradient;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? titleColor;

  const _SheetItem({
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
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: titleColor ?? AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textFaint, size: 16),
          ],
        ),
      ),
    );
  }
}