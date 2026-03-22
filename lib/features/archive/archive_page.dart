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
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_text.dart';
import '../../core/widgets/stat_card.dart';
import '../archive/archive_provider.dart';

class ArchivePage extends ConsumerWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archiveAsync = ref.watch(paidInvoicesByClientProvider);
    final statsAsync = ref.watch(archiveStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientText(
                    'Archive',
                    gradient: AppGradients.green,
                    style: AppTextStyles.headlineLarge,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Factures entierement payees',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Stats archive
            statsAsync.when(
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
              data: (stats) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.done_all,
                        label: 'Payees',
                        value: '${stats.nombreFactures}',
                        gradient: AppGradients.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        icon: Icons.people_outline,
                        label: 'Clients',
                        value: '${stats.nombreClients}',
                        gradient: AppGradients.brand,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        icon: Icons.payments_outlined,
                        label: 'Encaisse',
                        value: AppFormatters.currencyCompact(
                            stats.totalEncaisse),
                        gradient: AppGradients.greenLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Notice lecture seule
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.badgeWarningBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.badgeWarningBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline,
                        color: AppColors.warning, size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lecture seule - Les factures archivees ne peuvent pas etre modifiees',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.warning,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Liste
            Expanded(
              child: archiveAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
                error: (e, _) => EmptyState(
                  icon: Icons.error_outline,
                  message: 'Erreur : $e',
                  iconColor: AppColors.danger,
                ),
                data: (map) {
                  if (map.isEmpty) {
                    return const EmptyState(
                      icon: Icons.archive_outlined,
                      message: 'Aucune facture archivee pour le moment',
                    );
                  }

                  final entries = map.entries.toList()
                    ..sort((a, b) {
                      final totA = a.value.fold(
                          0.0, (s, inv) => s + inv.montantTotal);
                      final totB = b.value.fold(
                          0.0, (s, inv) => s + inv.montantTotal);
                      return totB.compareTo(totA);
                    });

                  return RefreshIndicator(
                    onRefresh: () async =>
                        ref.invalidate(paidInvoicesByClientProvider),
                    color: AppColors.accent,
                    backgroundColor: AppColors.bgCard,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: entries.length,
                      itemBuilder: (_, i) => _ArchiveClientCard(
                        client: entries[i].key,
                        invoices: entries[i].value,
                        index: i,
                        onTap: () => context.go(
                          '${AppRoutes.archive}/${entries[i].key.id}',
                        ),
                      ),
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
}

class _ArchiveClientCard extends StatelessWidget {
  final ClientModel client;
  final List<InvoiceModel> invoices;
  final int index;
  final VoidCallback onTap;

  const _ArchiveClientCard({
    required this.client,
    required this.invoices,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalEncaisse =
    invoices.fold(0.0, (s, inv) => s + inv.montantTotal);

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
                      style:
                      AppTextStyles.labelLarge.copyWith(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    client.telephone.isNotEmpty ? client.telephone : '-',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.badgeSuccessBg,
                      borderRadius: BorderRadius.circular(100),
                      border:
                      Border.all(color: AppColors.badgeSuccessBorder),
                    ),
                    child: Text(
                      '${invoices.length} payee${invoices.length > 1 ? 's' : ''}',
                      style: AppTextStyles.badge
                          .copyWith(color: AppColors.success),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Montant encaisse
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GradientText(
                  AppFormatters.currency(totalEncaisse),
                  gradient: AppGradients.green,
                  style: AppTextStyles.amount,
                ),
                const SizedBox(height: 2),
                Text('Encaisse', style: AppTextStyles.caption),
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