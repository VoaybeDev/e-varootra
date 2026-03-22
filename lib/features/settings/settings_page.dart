import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/constants.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_text.dart';
import '../auth/auth_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.bgCardHover,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.arrow_back,
                          size: 16, color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GradientText(
                    'Parametres',
                    gradient: AppGradients.brand,
                    style: AppTextStyles.headlineLarge,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Profil
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.nomComplet ?? 'Utilisateur',
                            style: AppTextStyles.titleLarge,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '@${user?.pseudo ?? ''}',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section application
              _SectionTitle('Application'),
              const SizedBox(height: 10),

              _SettingsItem(
                icon: Icons.people_outline,
                gradient: AppGradients.brand,
                title: 'Clients',
                subtitle: 'Gerer la liste des clients',
                onTap: () => context.go(AppRoutes.clients),
              ),

              _SettingsItem(
                icon: Icons.inventory_2_outlined,
                gradient: AppGradients.orange,
                title: 'Produits',
                subtitle: 'Catalogue et gestion des prix',
                onTap: () => context.go(AppRoutes.products),
              ),

              _SettingsItem(
                icon: Icons.receipt_long_outlined,
                gradient: AppGradients.rose,
                title: 'Dettes',
                subtitle: 'Suivi des factures actives',
                onTap: () => context.go(AppRoutes.debts),
              ),

              _SettingsItem(
                icon: Icons.archive_outlined,
                gradient: AppGradients.green,
                title: 'Archive',
                subtitle: 'Factures entierement payees',
                onTap: () => context.go(AppRoutes.archive),
              ),

              _SettingsItem(
                icon: Icons.bar_chart_outlined,
                gradient: AppGradients.violet,
                title: 'Tableau de bord',
                subtitle: 'Analyses et graphiques',
                onTap: () => context.go(AppRoutes.dashboard),
              ),

              const SizedBox(height: 20),

              // Section infos
              _SectionTitle('Informations'),
              const SizedBox(height: 10),

              _InfoItem(label: 'Application', value: AppConstants.appName),
              _InfoItem(label: 'Version', value: AppConstants.appVersion),
              _InfoItem(label: 'Monnaie', value: AppConstants.currency),
              _InfoItem(label: 'Langue', value: 'Francais'),

              const SizedBox(height: 24),

              // Deconnexion
              GradientButton(
                label: 'Se deconnecter',
                icon: Icons.logout,
                gradient: AppGradients.rose,
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go(AppRoutes.auth);
                },
                fullWidth: true,
                size: GradientButtonSize.large,
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  '${AppConstants.appName} v${AppConstants.appVersion}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textFaint,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: AppTextStyles.inputLabel.copyWith(
        letterSpacing: 1,
        color: AppColors.textMuted,
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final LinearGradient gradient;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelLarge),
                  Text(subtitle, style: AppTextStyles.bodySmall),
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

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          Text(value,
              style: AppTextStyles.labelSmall
                  .copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}