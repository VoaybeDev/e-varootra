import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/formatters.dart';
import '../../core/models/invoice_model.dart';
import '../../core/services/pdf_service.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/badge_status.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_text.dart';
import '../debts/debts_provider.dart';
import '../debts/payment_sheet.dart';

class DebtDetailPage extends ConsumerWidget {
  final int clientId;

  const DebtDetailPage({super.key, required this.clientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(clientInvoicesProvider(clientId));

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: invoicesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (invoices) {
          if (invoices.isEmpty) {
            return SafeArea(
              child: Column(
                children: [
                  _BackRow(
                    title: 'Factures',
                    subtitle: '-',
                    amount: '0 Ar',
                    gradient: AppGradients.rose,
                  ),
                  const Expanded(
                    child: EmptyState(
                      icon: Icons.receipt_long_outlined,
                      message: 'Aucune dette active',
                    ),
                  ),
                ],
              ),
            );
          }

          final nomClient = invoices.first.nomClient;
          final telClient = invoices.first.telephoneClient;
          final totalRestant =
          invoices.fold(0.0, (s, inv) => s + inv.montantRestant);

          return SafeArea(
            child: Column(
              children: [
                _BackRow(
                  title: nomClient,
                  subtitle: telClient,
                  amount: AppFormatters.currency(totalRestant),
                  gradient: AppGradients.rose,
                ),
                _SortBar(clientId: clientId),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        ref.invalidate(clientInvoicesProvider(clientId)),
                    color: AppColors.accent,
                    backgroundColor: AppColors.bgCard,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: invoices.length,
                      itemBuilder: (_, i) => _InvoiceCard(
                        invoice: invoices[i],
                        isArchive: false,
                        onPay: () => _openPayment(context, ref, invoices[i]),
                        onView: () => _viewInvoice(context, invoices[i]),
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

  void _openPayment(
      BuildContext context, WidgetRef ref, InvoiceModel invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentSheet(
        invoice: invoice,
        onPaid: () {
          ref.invalidate(clientInvoicesProvider(clientId));
          ref.invalidate(activeInvoicesByClientProvider);
          AppToast.show(context, 'Paiement enregistre');
        },
      ),
    );
  }

  void _viewInvoice(BuildContext context, InvoiceModel invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InvoiceViewer(invoice: invoice),
    );
  }
}

class _BackRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final LinearGradient gradient;

  const _BackRow({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.gradient,
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
              Text('Total du', style: AppTextStyles.caption),
              GradientText(
                amount,
                gradient: gradient,
                style: AppTextStyles.amount,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SortBar extends ConsumerWidget {
  final int clientId;

  const _SortBar({required this.clientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(debtSortProvider);

    final items = [
      (DebtSortMode.dateDesc, 'Date -'),
      (DebtSortMode.dateAsc, 'Date +'),
      (DebtSortMode.montantDesc, 'Montant -'),
      (DebtSortMode.montantAsc, 'Montant +'),
      (DebtSortMode.restantDesc, 'Restant -'),
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
            onTap: () =>
            ref.read(debtSortProvider.notifier).state = mode,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.badgeAccentBg
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isActive
                      ? AppColors.badgeAccentBorder
                      : AppColors.border,
                ),
              ),
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color:
                  isActive ? AppColors.accent : AppColors.textMuted,
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

class _InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final bool isArchive;
  final VoidCallback? onPay;
  final VoidCallback onView;

  const _InvoiceCard({
    required this.invoice,
    required this.isArchive,
    this.onPay,
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
                _AmountItem(
                    label: 'Total',
                    value: AppFormatters.currency(invoice.montantTotal)),
                const SizedBox(width: 14),
                _AmountItem(
                  label: 'Paye',
                  value: AppFormatters.currency(invoice.montantPaye),
                  color: AppColors.success,
                ),
                if (!isArchive) ...[
                  const SizedBox(width: 14),
                  _AmountItem(
                    label: 'Restant',
                    value:
                    AppFormatters.currency(invoice.montantRestant),
                    color: invoice.montantRestant > 0
                        ? AppColors.danger
                        : AppColors.success,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                border:
                Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  if (!isArchive &&
                      invoice.montantRestant > 0 &&
                      onPay != null)
                    Expanded(
                      child: GestureDetector(
                        onTap: onPay,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: AppGradients.brand,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.payments_outlined,
                                  size: 12, color: Colors.white),
                              const SizedBox(width: 6),
                              Text('Payer',
                                  style: AppTextStyles.buttonSmall
                                      .copyWith(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (!isArchive &&
                      invoice.montantRestant > 0 &&
                      onPay != null)
                    const SizedBox(width: 8),
                  Expanded(
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
                                size: 12,
                                color: AppColors.textMuted),
                            const SizedBox(width: 6),
                            Text('Voir',
                                style: AppTextStyles.buttonSmall
                                    .copyWith(
                                    fontSize: 12,
                                    color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ),
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

class _AmountItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _AmountItem(
      {required this.label, required this.value, this.color});

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

// ═══════════════════════════════
// VIEWER FACTURE REORGANISE
// ═══════════════════════════════
class _InvoiceViewer extends StatelessWidget {
  final InvoiceModel invoice;

  const _InvoiceViewer({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
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
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: AppColors.textFaint,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GradientText(
                            invoice.numeroFacture,
                            gradient: AppGradients.brand,
                            style: AppTextStyles.headlineMedium,
                          ),
                          const SizedBox(height: 2),
                          BadgeStatus(status: invoice.statut),
                        ],
                      ),
                    ),
                    // Bouton imprimer
                    GestureDetector(
                      onTap: () =>
                          PdfService.previewInvoice(context, invoice),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: AppGradients.brand,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.print_outlined,
                                size: 14, color: Colors.white),
                            SizedBox(width: 6),
                            Text('Imprimer',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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

          const SizedBox(height: 12),

          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bloc info client/vendeur
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bgCardHover,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _InfoBlock(
                            items: [
                              ('Date', AppFormatters.dateShort(
                                  invoice.dateDette)),
                              ('Vendeur', invoice.nomVendeur),
                            ],
                          ),
                        ),
                        Container(
                            width: 1,
                            height: 50,
                            color: AppColors.border),
                        Expanded(
                          child: _InfoBlock(
                            alignRight: true,
                            items: [
                              ('Client', invoice.nomClient),
                              ('Tel',
                              invoice.telephoneClient.isNotEmpty
                                  ? invoice.telephoneClient
                                  : '-'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tableau produits
                  Text('PRODUITS', style: AppTextStyles.inputLabel),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCardHover,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        // Header tableau
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                BorderSide(color: AppColors.border)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Text('Produit',
                                      style: AppTextStyles.caption
                                          .copyWith(
                                          fontWeight:
                                          FontWeight.w700))),
                              SizedBox(
                                  width: 40,
                                  child: Text('Qte',
                                      style: AppTextStyles.caption
                                          .copyWith(
                                          fontWeight: FontWeight
                                              .w700),
                                      textAlign: TextAlign.center)),
                              SizedBox(
                                  width: 70,
                                  child: Text('Prix U.',
                                      style: AppTextStyles.caption
                                          .copyWith(
                                          fontWeight:
                                          FontWeight.w700),
                                      textAlign: TextAlign.right)),
                              SizedBox(
                                  width: 75,
                                  child: Text('Total',
                                      style: AppTextStyles.caption
                                          .copyWith(
                                          fontWeight:
                                          FontWeight.w700),
                                      textAlign: TextAlign.right)),
                            ],
                          ),
                        ),

                        // Lignes
                        ...invoice.lignes.asMap().entries.map((e) {
                          final l = e.value;
                          final isLast =
                              e.key == invoice.lignes.length - 1;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              border: isLast
                                  ? null
                                  : const Border(
                                  bottom: BorderSide(
                                      color: AppColors.border)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    l.descriptionProduit,
                                    style: AppTextStyles.labelSmall
                                        .copyWith(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    'x${l.quantite.toStringAsFixed(l.quantite % 1 == 0 ? 0 : 1)}',
                                    style: AppTextStyles.caption
                                        .copyWith(
                                        color:
                                        AppColors.textPrimary),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    AppFormatters.currency(
                                        l.prixUnitaireFige),
                                    style: AppTextStyles.caption,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                SizedBox(
                                  width: 75,
                                  child: Text(
                                    AppFormatters.currency(
                                        l.montantTotal),
                                    style:
                                    AppTextStyles.labelSmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Totaux
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: AppGradients.invoiceTotal,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.badgeAccentBorder),
                    ),
                    child: Column(
                      children: [
                        _TotalRow(
                            label: 'Total',
                            value: AppFormatters.currency(
                                invoice.montantTotal)),
                        _TotalRow(
                          label: 'Paye',
                          value: AppFormatters.currency(
                              invoice.montantPaye),
                          color: AppColors.success,
                        ),
                        const Divider(
                            color: AppColors.border, height: 16),
                        _TotalRow(
                          label: 'Restant',
                          value: AppFormatters.currency(
                              invoice.montantRestant),
                          color: invoice.montantRestant > 0
                              ? AppColors.danger
                              : AppColors.success,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),

                  // Historique paiements
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
                        border: const Border(
                          left: BorderSide(
                              color: AppColors.success, width: 3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                        Icons.schedule_outlined,
                                        size: 10,
                                        color: AppColors.textMuted),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${AppFormatters.dateShort(p.datePaiement)} - ${p.dateCreation.hour.toString().padLeft(2, '0')}:${p.dateCreation.minute.toString().padLeft(2, '0')}',
                                      style: AppTextStyles.caption
                                          .copyWith(
                                          fontWeight:
                                          FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                if (p.nomUtilisateur != null)
                                  Row(
                                    children: [
                                      const Icon(
                                          Icons.person_outline,
                                          size: 10,
                                          color: AppColors.accent),
                                      const SizedBox(width: 4),
                                      Text(
                                        p.nomUtilisateur!,
                                        style: AppTextStyles.caption
                                            .copyWith(
                                            color:
                                            AppColors.accent,
                                            fontWeight:
                                            FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 3),
                                Text(
                                  'Ref: ${p.referencePaiement}',
                                  style: AppTextStyles.caption
                                      .copyWith(
                                      color:
                                      AppColors.textFaint),
                                ),
                                Text(
                                  p.modePaiement,
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
                            style: AppTextStyles.labelSmall.copyWith(
                                fontWeight: FontWeight.w700),
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

class _InfoBlock extends StatelessWidget {
  final List<(String, String)> items;
  final bool alignRight;

  const _InfoBlock({required this.items, this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: alignRight ? 12 : 0, right: alignRight ? 0 : 12),
      child: Column(
        crossAxisAlignment: alignRight
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Column(
              crossAxisAlignment: alignRight
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(item.$1, style: AppTextStyles.caption),
                Text(item.$2,
                    style: AppTextStyles.labelSmall
                        .copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isBold;

  const _TotalRow({
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