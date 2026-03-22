import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/formatters.dart';
import '../../core/models/invoice_model.dart';
import '../../core/widgets/badge_status.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_text.dart';
import '../archive/archive_provider.dart';
import '../debts/debt_detail_page.dart';

class ArchiveDetailPage extends ConsumerWidget {
  final int clientId;

  const ArchiveDetailPage({super.key, required this.clientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(clientPaidInvoicesProvider(clientId));
    final sortMode = ref.watch(archiveSortProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: invoicesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (invoices) {
          // Tri
          final sorted = [...invoices];
          switch (sortMode) {
            case ArchiveSortMode.dateDesc:
              sorted.sort(
                      (a, b) => b.dateDette.compareTo(a.dateDette));
              break;
            case ArchiveSortMode.dateAsc:
              sorted.sort(
                      (a, b) => a.dateDette.compareTo(b.dateDette));
              break;
            case ArchiveSortMode.montantDesc:
              sorted.sort(
                      (a, b) => b.montantTotal.compareTo(a.montantTotal));
              break;
            case ArchiveSortMode.montantAsc:
              sorted.sort(
                      (a, b) => a.montantTotal.compareTo(b.montantTotal));
              break;
          }

          if (sorted.isEmpty) {
            return SafeArea(
              child: Column(
                children: [
                  _BackRow(
                    title: 'Archive',
                    subtitle: '-',
                    amount: '0 Ar',
                  ),
                  const Expanded(
                    child: EmptyState(
                      icon: Icons.archive_outlined,
                      message: 'Aucune facture archivee',
                    ),
                  ),
                ],
              ),
            );
          }

          final nomClient = sorted.first.nomClient;
          final telClient = sorted.first.telephoneClient;
          final totalEncaisse =
          sorted.fold(0.0, (s, inv) => s + inv.montantTotal);

          return SafeArea(
            child: Column(
              children: [
                _BackRow(
                  title: nomClient,
                  subtitle: telClient,
                  amount: AppFormatters.currency(totalEncaisse),
                ),

                // Notice
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.badgeWarningBg,
                      borderRadius: BorderRadius.circular(10),
                      border:
                      Border.all(color: AppColors.badgeWarningBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline,
                            color: AppColors.warning, size: 12),
                        const SizedBox(width: 8),
                        Text(
                          'Lecture seule - Factures archivees',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.warning,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tri
                _ArchiveSortBar(
                  current: sortMode,
                  onChanged: (mode) =>
                  ref.read(archiveSortProvider.notifier).state = mode,
                ),

                // Liste
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        ref.invalidate(clientPaidInvoicesProvider(clientId)),
                    color: AppColors.accent,
                    backgroundColor: AppColors.bgCard,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: sorted.length,
                      itemBuilder: (_, i) => _ArchiveInvoiceCard(
                        invoice: sorted[i],
                        onView: () => _viewInvoice(context, sorted[i]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _viewInvoice(BuildContext context, InvoiceModel invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InvoiceArchiveViewer(invoice: invoice),
    );
  }
}

class _BackRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;

  const _BackRow({
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headlineSmall),
                Text(subtitle,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Encaisse', style: AppTextStyles.caption),
              GradientText(
                amount,
                gradient: AppGradients.green,
                style: AppTextStyles.amount,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArchiveSortBar extends StatelessWidget {
  final ArchiveSortMode current;
  final ValueChanged<ArchiveSortMode> onChanged;

  const _ArchiveSortBar({
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (ArchiveSortMode.dateDesc, 'Date -'),
      (ArchiveSortMode.dateAsc, 'Date +'),
      (ArchiveSortMode.montantDesc, 'Montant -'),
      (ArchiveSortMode.montantAsc, 'Montant +'),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final (mode, label) = items[i];
          final isActive = current == mode;
          return GestureDetector(
            onTap: () => onChanged(mode),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.badgeSuccessBg
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isActive
                      ? AppColors.badgeSuccessBorder
                      : AppColors.border,
                ),
              ),
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color:
                  isActive ? AppColors.success : AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ArchiveInvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final VoidCallback onView;

  const _ArchiveInvoiceCard({
    required this.invoice,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onView,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        invoice.numeroFacture,
                        gradient: AppGradients.brand,
                        style: AppTextStyles.invoiceNumber,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppFormatters.dateShort(invoice.dateDette),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                BadgeStatus(status: invoice.statut),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              invoice.descriptionProduits,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                _AmountChip(
                  label: 'Total',
                  value: AppFormatters.currency(invoice.montantTotal),
                ),
                const SizedBox(width: 14),
                _AmountChip(
                  label: 'Encaisse',
                  value: AppFormatters.currency(invoice.montantPaye),
                  color: AppColors.success,
                ),
              ],
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                border:
                Border(top: BorderSide(color: AppColors.border)),
              ),
              child: GestureDetector(
                onTap: onView,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.bgCardHover,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.visibility_outlined,
                          size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        'Voir la facture',
                        style: AppTextStyles.buttonSmall.copyWith(
                            fontSize: 12,
                            color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _AmountChip({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.labelSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: color ?? AppColors.textPrimary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _InvoiceArchiveViewer extends StatelessWidget {
  final InvoiceModel invoice;

  const _InvoiceArchiveViewer({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF10182A), Color(0xFF0A1020)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: AppColors.border),
          left: BorderSide(color: AppColors.border),
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: Column(
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
                Row(
                  children: [
                    Expanded(
                      child: GradientText(
                        invoice.numeroFacture,
                        gradient: AppGradients.brand,
                        style: AppTextStyles.headlineMedium,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.bgCardHover,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.close,
                            size: 14, color: AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notice
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.badgeSuccessBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.badgeSuccessBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: AppColors.success, size: 14),
                        const SizedBox(width: 8),
                        Text(
                          'Facture entierement payee',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Meta
                  Row(
                    children: [
                      Expanded(
                        child: _MetaItem(
                          label: 'Date',
                          value: AppFormatters.dateShort(
                              invoice.dateDette),
                          label2: 'Vendeur',
                          value2: invoice.nomVendeur,
                        ),
                      ),
                      Expanded(
                        child: _MetaItem(
                          label: 'Client',
                          value: invoice.nomClient,
                          label2: 'Tel',
                          value2: invoice.telephoneClient.isNotEmpty
                              ? invoice.telephoneClient
                              : '-',
                          alignRight: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text('PRODUITS', style: AppTextStyles.inputLabel),
                  const SizedBox(height: 8),

                  ...invoice.lignes.asMap().entries.map((e) {
                    final l = e.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.bgCardHover,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l.descriptionProduit,
                              style: AppTextStyles.labelSmall,
                            ),
                          ),
                          Text(
                            'x${l.quantite.toStringAsFixed(l.quantite % 1 == 0 ? 0 : 1)}',
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppFormatters.currency(l.montantTotal),
                            style: AppTextStyles.labelSmall
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: AppGradients.invoiceTotal,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.badgeSuccessBorder),
                    ),
                    child: Column(
                      children: [
                        _TotalLine(
                          label: 'Total',
                          value: AppFormatters.currency(
                              invoice.montantTotal),
                        ),
                        _TotalLine(
                          label: 'Paye',
                          value: AppFormatters.currency(
                              invoice.montantPaye),
                          color: AppColors.success,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),

                  if (invoice.paiements.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('HISTORIQUE PAIEMENTS',
                        style: AppTextStyles.inputLabel),
                    const SizedBox(height: 8),
                    ...invoice.paiements.map((p) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.bgCardHover,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppFormatters.dateShort(
                                      p.datePaiement),
                                  style: AppTextStyles.caption,
                                ),
                                Text(
                                  'Ref: ${p.referencePaiement}',
                                  style: AppTextStyles.caption
                                      .copyWith(
                                      color:
                                      AppColors.textFaint),
                                ),
                              ],
                            ),
                          ),
                          GradientText(
                            '+${AppFormatters.currency(p.montantPaye)}',
                            gradient: AppGradients.green,
                            style: AppTextStyles.labelSmall
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String label;
  final String value;
  final String label2;
  final String value2;
  final bool alignRight;

  const _MetaItem({
    required this.label,
    required this.value,
    required this.label2,
    required this.value2,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        Text(value,
            style: AppTextStyles.labelSmall
                .copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(label2, style: AppTextStyles.caption),
        Text(value2,
            style: AppTextStyles.labelSmall
                .copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _TotalLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isBold;

  const _TotalLine({
    required this.label,
    required this.value,
    this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.labelSmall.copyWith(
                  fontWeight:
                  isBold ? FontWeight.w800 : FontWeight.w600)),
          Text(
            value,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight:
              isBold ? FontWeight.w800 : FontWeight.w700,
              color: color ?? AppColors.textPrimary,
              fontSize: isBold ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }
}