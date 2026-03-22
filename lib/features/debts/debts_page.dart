import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/formatters.dart';
import '../../core/models/client_model.dart';
import '../../core/models/invoice_model.dart';
import '../../core/widgets/badge_status.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_text.dart';
import '../../core/widgets/search_field.dart';
import '../archive/archive_provider.dart';
import '../dashboard/dashboard_provider.dart';
import '../debts/debts_provider.dart';
import '../debts/invoice_create_page.dart';
import '../home/home_provider.dart';

class DebtsPage extends ConsumerStatefulWidget {
  const DebtsPage({super.key});

  @override
  ConsumerState<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends ConsumerState<DebtsPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(activeInvoicesByClientProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: GradientText(
                      'Dettes',
                      gradient: AppGradients.brand,
                      style: AppTextStyles.headlineLarge,
                    ),
                  ),
                  GradientButton.orange(
                    label: 'Nouvelle',
                    icon: Icons.add,
                    size: GradientButtonSize.small,
                    onPressed: () => _openCreate(context),
                  ),
                ],
              ),
            ),

            // Recherche
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: SearchField(
                placeholder: 'Rechercher un client...',
                onChanged: (v) => setState(() => _search = v),
              ),
            ),

            const SizedBox(height: 12),

            // Liste
            Expanded(
              child: invoicesAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
                error: (e, _) => EmptyState(
                  icon: Icons.error_outline,
                  message: 'Erreur : $e',
                  iconColor: AppColors.danger,
                ),
                data: (map) {
                  final entries = map.entries.where((e) {
                    if (_search.trim().isEmpty) return true;
                    return e.key.nomComplet
                        .toLowerCase()
                        .contains(_search.toLowerCase());
                  }).toList()
                    ..sort((a, b) {
                      final totA =
                      a.value.fold(0.0, (s, inv) => s + inv.montantRestant);
                      final totB =
                      b.value.fold(0.0, (s, inv) => s + inv.montantRestant);
                      return totB.compareTo(totA);
                    });

                  if (entries.isEmpty) {
                    return EmptyState(
                      icon: Icons.check_circle_outline,
                      message: _search.isEmpty
                          ? 'Aucune dette en cours'
                          : 'Aucun resultat',
                      iconColor: AppColors.success,
                      actionLabel:
                      _search.isEmpty ? 'Creer une facture' : null,
                      onAction:
                      _search.isEmpty ? () => _openCreate(context) : null,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(activeInvoicesByClientProvider);
                      ref.invalidate(homeStatsProvider);
                    },
                    color: AppColors.accent,
                    backgroundColor: AppColors.bgCard,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: entries.length,
                      itemBuilder: (_, i) {
                        final client = entries[i].key;
                        final invoices = entries[i].value;
                        return _ClientDebtCard(
                          client: client,
                          invoices: invoices,
                          index: i,
                          onTap: () => context.go(
                            '${AppRoutes.debts}/${client.id}',
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCreate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => InvoiceCreatePage(
        onCreated: () {
          // Invalider tous les providers concernes
          ref.invalidate(activeInvoicesByClientProvider);
          ref.invalidate(paidInvoicesByClientProvider);
          ref.invalidate(archiveStatsProvider);
          ref.invalidate(homeStatsProvider);
          ref.invalidate(dashboardStatsProvider);
          ref.invalidate(topClientsProvider);
          ref.invalidate(topProductsProvider);
          ref.invalidate(repartitionDettesProvider);
          ref.invalidate(dailyPaymentsProvider);
          ref.invalidate(vendeurStatsProvider);
        },
      ),
    );
  }
}

class _ClientDebtCard extends StatelessWidget {
  final ClientModel client;
  final List<InvoiceModel> invoices;
  final int index;
  final VoidCallback onTap;

  const _ClientDebtCard({
    required this.client,
    required this.invoices,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalRestant =
    invoices.fold(0.0, (s, inv) => s + inv.montantRestant);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppGradients.avatarAt(index),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  AppFormatters.firstLetter(client.nomComplet),
                  style: AppTextStyles.titleMedium
                      .copyWith(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(client.nomComplet,
                      style: AppTextStyles.labelLarge.copyWith(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    client.telephone.isNotEmpty ? client.telephone : '-',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  // Badges factures
                  Wrap(
                    spacing: 4,
                    children: [
                      ...invoices.take(2).map(
                            (inv) => BadgeStatus(status: inv.statut),
                      ),
                      if (invoices.length > 2)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.badgeAccentBg,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: AppColors.badgeAccentBorder),
                          ),
                          child: Text(
                            '+${invoices.length - 2}',
                            style: AppTextStyles.badge
                                .copyWith(color: AppColors.accent),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Montant + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GradientText(
                  AppFormatters.currency(totalRestant),
                  gradient: AppGradients.rose,
                  style: AppTextStyles.amount,
                ),
                const SizedBox(height: 2),
                Text(
                  '${invoices.length} facture${invoices.length > 1 ? 's' : ''}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),

            const SizedBox(width: 8),

            const Icon(Icons.chevron_right,
                color: AppColors.textFaint, size: 16),
          ],
        ),
      ),
    );
  }
}