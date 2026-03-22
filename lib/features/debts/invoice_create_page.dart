import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/formatters.dart';
import '../../core/models/client_model.dart';
import '../../core/models/product_unit_model.dart';
import '../../core/services/invoice_service.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_text.dart';
import '../archive/archive_provider.dart';
import '../auth/auth_provider.dart';
import '../clients/clients_provider.dart';
import '../dashboard/dashboard_provider.dart';
import '../home/home_provider.dart';
import '../products/products_provider.dart';
import 'debts_provider.dart';

class InvoiceCreatePage extends ConsumerStatefulWidget {
  final int? preselectedClientId;
  final VoidCallback? onCreated;

  const InvoiceCreatePage({
    super.key,
    this.preselectedClientId,
    this.onCreated,
  });

  @override
  ConsumerState<InvoiceCreatePage> createState() =>
      _InvoiceCreatePageState();
}

class _InvoiceCreatePageState extends ConsumerState<InvoiceCreatePage> {
  ClientModel? _selectedClient;
  DateTime _selectedDate = DateTime.now();
  final List<_InvoiceLine> _lines = [];
  double _paiementInitial = 0;
  bool _isLoading = false;
  bool _paiementTotal = false;

  @override
  void initState() {
    super.initState();
    _addLine();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(allProductUnitsProvider);
      if (widget.preselectedClientId != null) {
        final clients =
            ref.read(clientsNotifierProvider).value ?? [];
        if (clients.isNotEmpty) {
          try {
            final client = clients.firstWhere(
                    (c) => c.id == widget.preselectedClientId);
            setState(() => _selectedClient = client);
          } catch (_) {}
        }
      }
    });
  }

  void _addLine() {
    setState(() => _lines.add(_InvoiceLine()));
  }

  double get _total => _lines.fold(
    0.0,
        (s, l) =>
    s + (l.productUnit?.prixUnitaire ?? 0) * l.quantite,
  );

  double get _restant =>
      (_total - _paiementInitial).clamp(0.0, double.infinity);

  // Detecte si la facture genere une dette
  bool get _aUneDette => _paiementInitial < _total;

  // Verifie si on peut enregistrer
  bool get _peutEnregistrer {
    if (_selectedClient == null) return false;
    if (_aUneDette && !_selectedClient!.estVerifie) return false;
    return true;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            onPrimary: Colors.white,
            surface: Color(0xFF10182A),
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (_selectedClient == null) {
      AppToast.show(context, 'Selectionnez un client',
          type: ToastType.error);
      return;
    }

    final validLines = _lines
        .where((l) => l.productUnit != null && l.quantite > 0)
        .toList();

    if (validLines.isEmpty) {
      AppToast.show(context, 'Ajoutez au moins un produit',
          type: ToastType.error);
      return;
    }

    // CIN requis SEULEMENT si la facture genere une dette
    if (_aUneDette && !_selectedClient!.estVerifie) {
      AppToast.show(
        context,
        'CIN et Photo CIN requis pour enregistrer une dette. Si le client paie tout maintenant, aucun CIN n\'est necessaire.',
        type: ToastType.error,
      );
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final service = ref.read(invoiceServiceProvider);
      final numero = await service.createInvoice(
        clientId: _selectedClient!.id,
        dateDette: _selectedDate,
        lignes: validLines
            .map((l) => InvoiceLineInput(
          produitUniteId: l.productUnit!.id,
          quantite: l.quantite,
          prixUnitaire: l.productUnit!.prixUnitaire,
        ))
            .toList(),
        enregistrePar: user.id,
        paiementInitial: _paiementInitial,
      );

      if (mounted) {
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

        Navigator.pop(context);
        AppToast.show(context, 'Facture $numero enregistree');
        widget.onCreated?.call();
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
    final clientsAsync = ref.watch(clientsNotifierProvider);
    final productUnitsAsync = ref.watch(allProductUnitsProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
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
                        'Nouvelle facture',
                        gradient: AppGradients.orange,
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

          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20,
                18,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Client + Date
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Client
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text('CLIENT *',
                                style: AppTextStyles.inputLabel),
                            const SizedBox(height: 7),
                            clientsAsync.when(
                              loading: () => const SizedBox(
                                height: 50,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: AppColors.accent,
                                        strokeWidth: 2)),
                              ),
                              error: (e, _) => const SizedBox(),
                              data: (clients) =>
                                  _DropdownField<ClientModel>(
                                    value: _selectedClient,
                                    hint: 'Selectionner',
                                    items: clients,
                                    itemLabel: (c) => c.nomComplet,
                                    onChanged: (c) {
                                      setState(() {
                                        _selectedClient = c;
                                        // Reset paiement si client change
                                        if (_paiementTotal) {
                                          _paiementTotal = false;
                                          _paiementInitial = 0;
                                        }
                                      });
                                    },
                                  ),
                            ),

                            // Badge statut client dynamique
                            if (_selectedClient != null) ...[
                              const SizedBox(height: 6),
                              _buildClientStatusBadge(),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text('DATE *',
                                style: AppTextStyles.inputLabel),
                            const SizedBox(height: 7),
                            GestureDetector(
                              onTap: _selectDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 13),
                                decoration: BoxDecoration(
                                  color: AppColors.inputBg,
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppColors.border,
                                      width: 1.5),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 14,
                                        color: AppColors.textFaint),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppFormatters.dateShort(
                                          _selectedDate),
                                      style: AppTextStyles.input,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Lignes produits
                  Row(
                    children: [
                      Expanded(
                        child: Text('PRODUITS',
                            style: AppTextStyles.inputLabel),
                      ),
                      GestureDetector(
                        onTap: _addLine,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.bgCardHover,
                            borderRadius: BorderRadius.circular(8),
                            border:
                            Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.add,
                                  size: 12,
                                  color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text('Ligne',
                                  style: AppTextStyles.labelSmall),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  productUnitsAsync.when(
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.accent,
                            strokeWidth: 2)),
                    error: (e, _) => const SizedBox(),
                    data: (productUnits) => Column(
                      children: List.generate(_lines.length, (i) {
                        return _InvoiceLineWidget(
                          line: _lines[i],
                          productUnits: productUnits,
                          onRemove: _lines.length > 1
                              ? () =>
                              setState(() => _lines.removeAt(i))
                              : null,
                          onChanged: () => setState(() {
                            if (_paiementTotal) {
                              _paiementInitial = _total;
                            }
                          }),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Total
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: AppGradients.invoiceTotal,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.badgeAccentBorder),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calculate_outlined,
                                size: 14, color: AppColors.accent),
                            const SizedBox(width: 8),
                            Text('Total',
                                style: AppTextStyles.labelSmall
                                    .copyWith(
                                    color: AppColors.textMuted)),
                          ],
                        ),
                        GradientText(
                          AppFormatters.currency(_total),
                          gradient: AppGradients.orange,
                          style: AppTextStyles.amountLarge,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Paiement initial
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.badgeSuccessBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.badgeSuccessBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'PAIEMENT INITIAL (OPTIONNEL)',
                              style: AppTextStyles.inputLabel
                                  .copyWith(
                                  color: AppColors.success),
                            ),
                            const Spacer(),
                            // Bouton payer tout
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _paiementTotal = !_paiementTotal;
                                  _paiementInitial =
                                  _paiementTotal ? _total : 0;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _paiementTotal
                                      ? AppColors.success
                                      : AppColors.bgCardHover,
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _paiementTotal
                                        ? AppColors.success
                                        : AppColors.border,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _paiementTotal
                                          ? Icons.check_circle_outline
                                          : Icons.payments_outlined,
                                      size: 12,
                                      color: _paiementTotal
                                          ? Colors.white
                                          : AppColors.textMuted,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _paiementTotal
                                          ? 'Tout paye'
                                          : 'Payer tout',
                                      style:
                                      AppTextStyles.caption.copyWith(
                                        color: _paiementTotal
                                            ? Colors.white
                                            : AppColors.textMuted,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text('Montant paye',
                                      style: AppTextStyles.caption),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    key: ValueKey(
                                        '${_paiementTotal}_$_total'),
                                    initialValue: _paiementInitial
                                        .toStringAsFixed(0),
                                    keyboardType:
                                    TextInputType.number,
                                    readOnly: _paiementTotal,
                                    style: AppTextStyles.input,
                                    onChanged: (v) =>
                                        setState(() {
                                          _paiementInitial =
                                              (double.tryParse(v) ?? 0)
                                                  .clamp(0.0, _total);
                                        }),
                                    decoration: InputDecoration(
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10),
                                      fillColor: _paiementTotal
                                          ? AppColors.badgeSuccessBg
                                          : AppColors.inputBg,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text('Restant',
                                      style: AppTextStyles.caption),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 13),
                                    decoration: BoxDecoration(
                                      color: AppColors.inputBg,
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      border: Border.all(
                                          color: AppColors.border,
                                          width: 1.5),
                                    ),
                                    child: Text(
                                      AppFormatters.currency(_restant),
                                      style: AppTextStyles.input
                                          .copyWith(
                                        color: _restant > 0
                                            ? AppColors.warning
                                            : AppColors.success,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Info achat comptant vs dette
                        if (_total > 0) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: _aUneDette
                                  ? AppColors.badgeWarningBg
                                  : AppColors.badgeSuccessBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _aUneDette
                                      ? Icons.schedule_outlined
                                      : Icons.check_circle_outline,
                                  size: 12,
                                  color: _aUneDette
                                      ? AppColors.warning
                                      : AppColors.success,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _aUneDette
                                      ? 'Dette enregistree - CIN requis'
                                      : 'Achat comptant - aucune dette',
                                  style: AppTextStyles.caption.copyWith(
                                    color: _aUneDette
                                        ? AppColors.warning
                                        : AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  GradientButton.orange(
                    label: 'Enregistrer la facture',
                    icon: Icons.save_outlined,
                    onPressed:
                    (_isLoading || !_peutEnregistrer) ? null : _save,
                    fullWidth: true,
                    size: GradientButtonSize.large,
                    isLoading: _isLoading,
                  ),

                  // Message si bouton desactive a cause du CIN
                  if (_selectedClient != null &&
                      _aUneDette &&
                      !_selectedClient!.estVerifie) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.badgeDangerBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.badgeDangerBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 14, color: AppColors.danger),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Modifiez ce client pour ajouter son CIN et sa Photo CIN, ou faites payer tout maintenant.',
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.danger),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Badge dynamique selon etat client et si c'est une dette
  Widget _buildClientStatusBadge() {
    if (_selectedClient == null) return const SizedBox.shrink();

    // Achat comptant - pas de CIN requis
    if (!_aUneDette) {
      return Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.badgeSuccessBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.badgeSuccessBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.payments_outlined,
                size: 12, color: AppColors.success),
            const SizedBox(width: 6),
            Text(
              'Achat comptant - CIN non requis',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.success),
            ),
          ],
        ),
      );
    }

    // Dette - CIN manquant
    if (!_selectedClient!.estVerifie) {
      return Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.badgeDangerBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.badgeDangerBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_outlined,
                size: 12, color: AppColors.danger),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Dette detectee - CIN + Photo CIN manquants',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.danger),
              ),
            ),
          ],
        ),
      );
    }

    // Dette - client verifie
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.badgeSuccessBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.badgeSuccessBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_outlined,
              size: 12, color: AppColors.success),
          const SizedBox(width: 6),
          Text(
            'Client verifie - dette autorisee',
            style: AppTextStyles.caption
                .copyWith(color: AppColors.success),
          ),
        ],
      ),
    );
  }
}

class _InvoiceLine {
  ProductUnitModel? productUnit;
  double quantite = 1;
}

class _InvoiceLineWidget extends StatelessWidget {
  final _InvoiceLine line;
  final List<ProductUnitModel> productUnits;
  final VoidCallback? onRemove;
  final VoidCallback onChanged;

  const _InvoiceLineWidget({
    required this.line,
    required this.productUnits,
    this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bgCardHover,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Produit
          Expanded(
            flex: 3,
            child: _DropdownField<ProductUnitModel>(
              value: line.productUnit,
              hint: 'Produit',
              items: productUnits,
              itemLabel: (pu) => pu.labelComplet,
              onChanged: (pu) {
                line.productUnit = pu;
                onChanged();
              },
            ),
          ),

          const SizedBox(width: 8),

          // Prix (affichage readonly)
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 13),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                line.productUnit != null
                    ? AppFormatters.currency(
                    line.productUnit!.prixUnitaire)
                    : '-',
                style: AppTextStyles.input.copyWith(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Quantite
          SizedBox(
            width: 60,
            child: TextFormField(
              initialValue: '1',
              keyboardType: TextInputType.number,
              style: AppTextStyles.input.copyWith(fontSize: 13),
              onChanged: (v) {
                line.quantite = double.tryParse(v) ?? 1;
                onChanged();
              },
              decoration: const InputDecoration(
                hintText: 'Qte',
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: 13),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Supprimer ligne
          GestureDetector(
            onTap: onRemove,
            child: Opacity(
              opacity: onRemove != null ? 1.0 : 0.3,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.badgeDangerBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.close,
                    size: 12, color: AppColors.danger),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  const _DropdownField({
    required this.value,
    required this.hint,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint,
              style: AppTextStyles.input.copyWith(
                  color: AppColors.textFaint, fontSize: 14)),
          isExpanded: true,
          dropdownColor: const Color(0xFF10182A),
          style: AppTextStyles.input.copyWith(fontSize: 14),
          icon: const Icon(Icons.keyboard_arrow_down,
              color: AppColors.textFaint, size: 18),
          items: items
              .map((item) => DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemLabel(item),
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.input.copyWith(fontSize: 14),
            ),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}