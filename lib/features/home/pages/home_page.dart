import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/utils/formatters.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/stat_card.dart';
import '../../auth/auth_provider.dart';
import '../../home/home_provider.dart';
import '../../debts/debts_provider.dart';
import '../../../core/widgets/app_header.dart';
import '../../archive/archive_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final selectedMonth = ref.watch(selectedMonthHeaderProvider);
    final statsAsync = ref.watch(
      homeStatsProvider((selectedMonth.$1, selectedMonth.$2)),
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(homeStatsProvider);
        ref.invalidate(activeInvoicesByClientProvider);
        ref.invalidate(paidInvoicesByClientProvider);
      },
      color: AppColors.accent,
      backgroundColor: AppColors.bgCard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message de bienvenue
            _WelcomeHeader(
              userName: user?.prenomAffichage ?? 'vous',
              month: selectedMonth.$1,
              year: selectedMonth.$2,
            ),

            const SizedBox(height: 18),

            // Stats
            statsAsync.when(
              loading: () => const _StatsLoading(),
              error: (e, _) => EmptyState(
                icon: Icons.error_outline,
                message: 'Erreur de chargement',
                iconColor: AppColors.danger,
              ),
              data: (stats) => Column(
                children: [
                  // Grille stats principales
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.3,
                    children: [
                      StatCard(
                        icon: Icons.inventory_2_outlined,
                        label: 'Produits',
                        value: '${stats.produitsActifs}',
                        gradient: AppGradients.brand,
                      ),
                      StatCard(
                        icon: Icons.people_outline,
                        label: 'Clients',
                        value: '${stats.clientsActifs}',
                        gradient: AppGradients.orange,
                      ),
                      StatCard(
                        icon: Icons.schedule_outlined,
                        label: 'Dettes actives',
                        value: '${stats.facturesActives}',
                        subtitle: AppFormatters.monthYearShort(
                          selectedMonth.$1,
                          selectedMonth.$2,
                        ),
                        gradient: AppGradients.rose,
                      ),
                      StatCard(
                        icon: Icons.check_circle_outline,
                        label: 'Dettes payees',
                        value: '${stats.facturesPayees}',
                        gradient: AppGradients.green,
                      ),
                      StatCard(
                        icon: Icons.hourglass_bottom_outlined,
                        label: 'Montant restant',
                        value: AppFormatters.currencyCompact(
                            stats.montantRestant),
                        gradient: AppGradients.violet,
                      ),
                      StatCard(
                        icon: Icons.payments_outlined,
                        label: 'Paiements recus',
                        value: AppFormatters.currencyCompact(
                            stats.paiementsRecus),
                        gradient: AppGradients.greenLight,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Total dettes creees (pleine largeur)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            gradient: AppGradients.orange,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(
                            Icons.bar_chart,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TOTAL DETTES CREEES',
                              style: AppTextStyles.caption,
                            ),
                            const SizedBox(height: 3),
                            GradientText(
                              AppFormatters.currency(stats.totalDettesCreees),
                              gradient: AppGradients.orange,
                              style: AppTextStyles.statValue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Resume financier
                  _FinancialSummary(stats: stats),

                  const SizedBox(height: 14),

                  // Bouton dashboard
                  GradientButton(
                    label: 'Voir le tableau de bord',
                    icon: Icons.bar_chart_outlined,
                    onPressed: () => context.go(AppRoutes.dashboard),
                    fullWidth: true,
                    size: GradientButtonSize.large,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  final String userName;
  final int month;
  final int year;

  const _WelcomeHeader({
    required this.userName,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          'Bonjour, $userName',
          gradient: AppGradients.brand,
          style: AppTextStyles.headlineLarge,
        ),
        const SizedBox(height: 3),
        Text(
          AppFormatters.monthYear(month, year),
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }
}

class _FinancialSummary extends StatelessWidget {
  final dynamic stats;

  const _FinancialSummary({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.cardAccent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.borderActive.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.pie_chart_outline,
                color: AppColors.accent,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                'Resume financier',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.2,
            children: [
              _SummaryItem(
                label: 'Taux recouvrement',
                value: AppFormatters.percent(stats.tauxRecouvrement),
              ),
              _SummaryItem(
                label: 'Taux soldees',
                value: AppFormatters.percent(stats.tauxSoldees),
              ),
              _SummaryItem(
                label: 'Moyenne / dette',
                value: AppFormatters.currencyCompact(stats.moyenneParDette),
              ),
              _SummaryItem(
                label: 'Performance',
                value: stats.performance,
                isText: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isText;

  const _SummaryItem({
    required this.label,
    required this.value,
    this.isText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 4),
          isText
              ? Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          )
              : GradientText(
            value,
            gradient: AppGradients.green,
            style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _StatsLoading extends StatelessWidget {
  const _StatsLoading();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.3,
      children: List.generate(
        6,
            (_) => Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}