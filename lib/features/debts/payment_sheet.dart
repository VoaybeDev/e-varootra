import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/constants.dart';
import '../../app/utils/formatters.dart';
import '../../core/models/invoice_model.dart';
import '../../core/services/payment_service.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_text.dart';
import '../auth/auth_provider.dart';

class PaymentSheet extends ConsumerStatefulWidget {
  final InvoiceModel invoice;
  final VoidCallback onPaid;

  const PaymentSheet({
    super.key,
    required this.invoice,
    required this.onPaid,
  });

  @override
  ConsumerState<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<PaymentSheet> {
  final _ctrl = TextEditingController();
  String _modePaiement = 'Especes';
  bool _isLoading = false;

  double get _montant => double.tryParse(_ctrl.text) ?? 0;

  @override
  void initState() {
    super.initState();
    _ctrl.text = widget.invoice.montantRestant.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _setQuick(String mode) {
    final restant = widget.invoice.montantRestant;
    double val;
    switch (mode) {
      case 'full':
        val = restant;
        break;
      case 'half':
        val = (restant / 2).ceilToDouble();
        break;
      case 'third':
        val = (restant / 3).ceilToDouble();
        break;
      default:
        val = restant;
    }
    setState(() => _ctrl.text = val.toStringAsFixed(0));
  }

  Future<void> _pay() async {
    if (_montant <= 0) {
      AppToast.show(context, 'Montant invalide', type: ToastType.error);
      return;
    }
    if (_montant > widget.invoice.montantRestant) {
      AppToast.show(
        context,
        'Depasse le restant (${AppFormatters.currency(widget.invoice.montantRestant)})',
        type: ToastType.error,
      );
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final service = ref.read(paymentServiceProvider);
      await service.payInvoice(
        numeroFacture: widget.invoice.numeroFacture,
        montantTotal: _montant,
        enregistrePar: user.id,
        nomClient: widget.invoice.nomClient,
        datePaiement: DateTime.now(),
        modePaiement: _modePaiement,
      );

      if (mounted) {
        Navigator.pop(context);
        widget.onPaid();
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(context, e.toString(), type: ToastType.error);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: EdgeInsets.fromLTRB(
        20,
        6,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pull
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

          // Titre
          Row(
            children: [
              Expanded(
                child: GradientText(
                  'Enregistrer un paiement',
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

          const SizedBox(height: 16),

          // Info facture
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.badgeAccentBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.badgeAccentBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  widget.invoice.numeroFacture,
                  gradient: AppGradients.brand,
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _InfoItem(
                      label: 'Total',
                      value: AppFormatters.currency(widget.invoice.montantTotal),
                    ),
                    const SizedBox(width: 18),
                    _InfoItem(
                      label: 'Paye',
                      value: AppFormatters.currency(widget.invoice.montantPaye),
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 18),
                    _InfoItem(
                      label: 'Restant',
                      value:
                      AppFormatters.currency(widget.invoice.montantRestant),
                      color: AppColors.danger,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Montant
          Text('MONTANT A PAYER', style: AppTextStyles.inputLabel),
          const SizedBox(height: 7),
          TextFormField(
            controller: _ctrl,
            keyboardType: TextInputType.number,
            style: AppTextStyles.input,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: '0',
              prefixIcon: Icon(Icons.payments_outlined,
                  size: 16, color: AppColors.textFaint),
            ),
          ),

          const SizedBox(height: 10),

          // Boutons rapides
          Row(
            children: [
              _QuickBtn(
                label: 'Tout payer',
                sublabel:
                AppFormatters.currencyCompact(widget.invoice.montantRestant),
                color: AppColors.accent,
                bg: AppColors.badgeAccentBg,
                border: AppColors.badgeAccentBorder,
                onTap: () => _setQuick('full'),
              ),
              const SizedBox(width: 8),
              _QuickBtn(
                label: '1/2 restant',
                sublabel: AppFormatters.currencyCompact(
                    widget.invoice.montantRestant / 2),
                color: AppColors.warning,
                bg: AppColors.badgeWarningBg,
                border: AppColors.badgeWarningBorder,
                onTap: () => _setQuick('half'),
              ),
              const SizedBox(width: 8),
              _QuickBtn(
                label: '1/3 restant',
                sublabel: AppFormatters.currencyCompact(
                    widget.invoice.montantRestant / 3),
                color: const Color(0xFFFF9D6C),
                bg: const Color.fromRGBO(255, 107, 53, 0.07),
                border: const Color.fromRGBO(255, 107, 53, 0.2),
                onTap: () => _setQuick('third'),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Mode paiement
          Text('MODE DE PAIEMENT', style: AppTextStyles.inputLabel),
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _modePaiement,
                isExpanded: true,
                dropdownColor: const Color(0xFF10182A),
                style: AppTextStyles.input,
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: AppColors.textFaint, size: 18),
                items: AppConstants.paymentModes
                    .map((m) => DropdownMenuItem(
                  value: m,
                  child: Text(m, style: AppTextStyles.input),
                ))
                    .toList(),
                onChanged: (v) => setState(() => _modePaiement = v!),
              ),
            ),
          ),

          const SizedBox(height: 16),

          GradientButton(
            label: 'Valider le paiement',
            icon: Icons.check_circle_outline,
            onPressed: _isLoading ? null : _pay,
            fullWidth: true,
            size: GradientButtonSize.large,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _InfoItem({required this.label, required this.value, this.color});

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

class _QuickBtn extends StatelessWidget {
  final String label;
  final String sublabel;
  final Color color;
  final Color bg;
  final Color border;
  final VoidCallback onTap;

  const _QuickBtn({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.bg,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                    color: color, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              Text(
                sublabel,
                style: AppTextStyles.caption
                    .copyWith(color: color.withOpacity(0.7), fontSize: 9),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}