import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../features/auth/auth_provider.dart';
import '../../features/settings/users_management_page.dart';

enum NavTab { home, debts, archive, more }

final currentNavTabProvider = StateProvider<NavTab>((ref) => NavTab.home);

class AppBottomNav extends ConsumerWidget {
  final VoidCallback onFabPressed;

  const AppBottomNav({super.key, required this.onFabPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentNavTabProvider);

    return Container(
      decoration: const BoxDecoration(
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
                  ref.read(currentNavTabProvider.notifier).state =
                      NavTab.home;
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
                  ref.read(currentNavTabProvider.notifier).state =
                      NavTab.debts;
                  context.go(AppRoutes.debts);
                },
              ),

              // FAB central
              Expanded(
                child: SizedBox(
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
                                  color: AppColors.accent
                                      .withValues(alpha: 0.5),
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
                  ref.read(currentNavTabProvider.notifier).state =
                      NavTab.more;
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
                  color:
                  isActive ? AppColors.accent : AppColors.textFaint,
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

              // Info utilisateur connecte
              if (user != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppColors.bgCardHover,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          gradient: AppGradients.brand,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            user.initiale,
                            style: AppTextStyles.titleMedium
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.nomComplet,
                                style: AppTextStyles.labelLarge),
                            Text('@${user.pseudo}',
                                style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      // Badge role
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _roleColor(user.roleLabel)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: _roleColor(user.roleLabel)
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          user.roleLabel,
                          style: AppTextStyles.badge.copyWith(
                            color: _roleColor(user.roleLabel),
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Clients
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

              // Produits
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

              // Dashboard
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

              // Gestion utilisateurs (admin et superuser seulement)
              if (user != null && user.estAdmin)
                _SheetItem(
                  icon: Icons.manage_accounts_outlined,
                  gradient: AppGradients.green,
                  title: 'Gestion utilisateurs',
                  subtitle: user.estSuperuser
                      ? 'Approuver, gerer et creer des admins'
                      : 'Approuver et gerer les comptes',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UsersManagementPage(),
                      ),
                    );
                  },
                ),

              const Divider(color: AppColors.border, height: 20),

              // Deconnexion
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
                  if (context.mounted) {
                    context.go(AppRoutes.auth);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'Superutilisateur':
        return AppColors.accent;
      case 'Administrateur':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
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
        padding: const EdgeInsets.symmetric(vertical: 10),
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