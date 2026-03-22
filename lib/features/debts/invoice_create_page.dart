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

// Groupe: un produit avec toutes ses unites disponibles
class _ProductGroup {
  final String nomProduit;
  final List<ProductUnitModel> units;
  const _ProductGroup({required this.nomProduit, required this.units});
}

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
        final clients = ref.read(clientsNotifierProvider).value ?? [];
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

  List<_ProductGroup> _buildGroups(List<ProductUnitModel> allUnits) {
    final Map<String, List<ProductUnitModel>> map = {};
    for (final pu in allUnits) {
      final nom = pu.nomProduit ?? '?';
      map.putIfAbsent(nom, () => []).add(pu);
    }
    return map.entries
        .map((e) => _ProductGroup(nomProduit: e.key, units: e.value))
        .toList()
      ..sort((a, b) => a.nomProduit.compareTo(b.nomProduit));
  }

  void _addLine() => setState(() => _lines.add(_InvoiceLine()));

  double get _total => _lines.fold(
      0.0, (s, l) => s + (l.selectedUnit?.prixUnitaire ?? 0) * l.quantite);

  double get _restant =>
      (_total - _paiementInitial).clamp(0.0, double.infinity);

  bool get _aUneDette => _paiementInitial < _total;

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
    final validLines =
    _lines.where((l) => l.selectedUnit != null && l.quantite > 0).toList();
    if (validLines.isEmpty) {
      AppToast.show(context, 'Ajoutez au moins un produit valide',
          type: ToastType.error);
      return;
    }
    if (_aUneDette && !_selectedClient!.estVerifie) {
      AppToast.show(
        context,
        'CIN et Photo CIN requis pour une dette. Payez tout maintenant si pas de CIN.',
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
          produitUniteId: l.selectedUnit!.id,
          quantite: l.quantite,
          prixUnitaire: l.selectedUnit!.prixUnitaire,
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
      if (mounted) AppToast.show(context, e.toString(), type: ToastType.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildClientBadge() {
    if (_selectedClient == null) return const SizedBox.shrink();
    if (!_aUneDette) {
      return _StatusBadge(
        icon: Icons.payments_outlined,
        text: 'Achat comptant - CIN non requis',
        color: AppColors.success,
        bgColor: AppColors.badgeSuccessBg,
        borderColor: AppColors.badgeSuccessBorder,
      );
    }
    if (!_selectedClient!.estVerifie) {
      return _StatusBadge(
        icon: Icons.warning_amber_outlined,
        text: 'Dette detectee - CIN + Photo CIN manquants',
        color: AppColors.danger,
        bgColor: AppColors.badgeDangerBg,
        borderColor: AppColors.badgeDangerBorder,
      );
    }
    return _StatusBadge(
      icon: Icons.verified_outlined,
      text: 'Client verifie - dette autorisee',
      color: AppColors.success,
      bgColor: AppColors.badgeSuccessBg,
      borderColor: AppColors.badgeSuccessBorder,
    );
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
                    width: 36, height: 4,
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
                      child: GradientText('Nouvelle facture',
                          gradient: AppGradients.orange,
                          style: AppTextStyles.headlineMedium),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 30, height: 30,
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

          // Contenu
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  20, 18, 20,
                  MediaQuery.of(context).viewInsets.bottom + 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── CLIENT + DATE ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CLIENT *', style: AppTextStyles.inputLabel),
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
                              data: (clients) => _ClientDropdown(
                                value: _selectedClient,
                                clients: clients,
                                onChanged: (c) => setState(() {
                                  _selectedClient = c;
                                  if (_paiementTotal) {
                                    _paiementTotal = false;
                                    _paiementInitial = 0;
                                  }
                                }),
                              ),
                            ),
                            if (_selectedClient != null) ...[
                              const SizedBox(height: 6),
                              _buildClientBadge(),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DATE *', style: AppTextStyles.inputLabel),
                            const SizedBox(height: 7),
                            GestureDetector(
                              onTap: _selectDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 13),
                                decoration: BoxDecoration(
                                  color: AppColors.inputBg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppColors.border, width: 1.5),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today_outlined,
                                        size: 14, color: AppColors.textFaint),
                                    const SizedBox(width: 8),
                                    Text(AppFormatters.dateShort(_selectedDate),
                                        style: AppTextStyles.input),
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

                  // ── PRODUITS ──
                  Row(
                    children: [
                      Expanded(
                          child: Text('PRODUITS',
                              style: AppTextStyles.inputLabel)),
                      GestureDetector(
                        onTap: _addLine,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.bgCardHover,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.add,
                                  size: 12, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text('Ligne', style: AppTextStyles.labelSmall),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // En-tete colonnes
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text('Produit',
                              style: AppTextStyles.caption
                                  .copyWith(fontWeight: FontWeight.w700)),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text('Unite',
                              style: AppTextStyles.caption
                                  .copyWith(fontWeight: FontWeight.w700)),
                        ),
                        SizedBox(
                          width: 52,
                          child: Text('Qte',
                              style: AppTextStyles.caption
                                  .copyWith(fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center),
                        ),
                        const SizedBox(width: 34),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),

                  productUnitsAsync.when(
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.accent, strokeWidth: 2)),
                    error: (e, _) => const SizedBox(),
                    data: (allUnits) {
                      final groups = _buildGroups(allUnits);
                      return Column(
                        children: List.generate(_lines.length, (i) {
                          return _InvoiceLineWidget(
                            key: ValueKey(i),
                            line: _lines[i],
                            groups: groups,
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
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // ── TOTAL ──
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: AppGradients.invoiceTotal,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.badgeAccentBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calculate_outlined,
                                size: 14, color: AppColors.accent),
                            const SizedBox(width: 8),
                            Text('Total',
                                style: AppTextStyles.labelSmall
                                    .copyWith(color: AppColors.textMuted)),
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

                  // ── PAIEMENT INITIAL ──
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.badgeSuccessBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.badgeSuccessBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('PAIEMENT INITIAL (OPTIONNEL)',
                                style: AppTextStyles.inputLabel
                                    .copyWith(color: AppColors.success)),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => setState(() {
                                _paiementTotal = !_paiementTotal;
                                _paiementInitial =
                                _paiementTotal ? _total : 0;
                              }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _paiementTotal
                                      ? AppColors.success
                                      : AppColors.bgCardHover,
                                  borderRadius: BorderRadius.circular(8),
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
                                      _paiementTotal ? 'Tout paye' : 'Payer tout',
                                      style: AppTextStyles.caption.copyWith(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Montant paye',
                                      style: AppTextStyles.caption),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    key: ValueKey(
                                        '${_paiementTotal}_${_total.toStringAsFixed(0)}'),
                                    initialValue:
                                    _paiementInitial.toStringAsFixed(0),
                                    keyboardType: TextInputType.number,
                                    readOnly: _paiementTotal,
                                    style: AppTextStyles.input,
                                    onChanged: (v) => setState(() {
                                      _paiementInitial =
                                          (double.tryParse(v) ?? 0)
                                              .clamp(0.0, _total);
                                    }),
                                    decoration: InputDecoration(
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Restant', style: AppTextStyles.caption),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 13),
                                    decoration: BoxDecoration(
                                      color: AppColors.inputBg,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: AppColors.border, width: 1.5),
                                    ),
                                    child: Text(
                                      AppFormatters.currency(_restant),
                                      style: AppTextStyles.input.copyWith(
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

                  if (_selectedClient != null &&
                      _aUneDette &&
                      !_selectedClient!.estVerifie) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.badgeDangerBg,
                        borderRadius: BorderRadius.circular(10),
                        border:
                        Border.all(color: AppColors.badgeDangerBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 14, color: AppColors.danger),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Modifiez ce client pour ajouter son CIN et Photo CIN, ou payez tout maintenant.',
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
}

// ═══════════════════════════════════════════
// BADGE STATUT
// ═══════════════════════════════════════════
class _StatusBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color bgColor;
  final Color borderColor;

  const _StatusBadge({
    required this.icon,
    required this.text,
    required this.color,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(text,
                style: AppTextStyles.caption.copyWith(color: color)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// MODELE LIGNE FACTURE
// ═══════════════════════════════════════════
class _InvoiceLine {
  String? selectedProductName;
  ProductUnitModel? selectedUnit;
  double quantite = 1;

  List<ProductUnitModel> getAvailableUnits(List<_ProductGroup> groups) {
    if (selectedProductName == null) return [];
    try {
      return groups
          .firstWhere((g) => g.nomProduit == selectedProductName)
          .units;
    } catch (_) {
      return [];
    }
  }
}

// ═══════════════════════════════════════════
// WIDGET LIGNE FACTURE
// ═══════════════════════════════════════════
class _InvoiceLineWidget extends StatefulWidget {
  final _InvoiceLine line;
  final List<_ProductGroup> groups;
  final VoidCallback? onRemove;
  final VoidCallback onChanged;

  const _InvoiceLineWidget({
    super.key,
    required this.line,
    required this.groups,
    this.onRemove,
    required this.onChanged,
  });

  @override
  State<_InvoiceLineWidget> createState() => _InvoiceLineWidgetState();
}

class _InvoiceLineWidgetState extends State<_InvoiceLineWidget> {
  late final TextEditingController _qteCtrl;

  @override
  void initState() {
    super.initState();
    _qteCtrl = TextEditingController(
        text: widget.line.quantite.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _qteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final line = widget.line;
    final availableUnits = line.getAvailableUnits(widget.groups);

    // Reset selectedUnit si plus dans la liste
    if (line.selectedUnit != null &&
        !availableUnits.any((u) => u.id == line.selectedUnit!.id)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => line.selectedUnit = null);
      });
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bgCardHover,
        borderRadius: BorderRadius.circular(12),
        border:
        Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── COMBO PRODUIT ──
              Expanded(
                flex: 5,
                child: _StringDropdown(
                  value: line.selectedProductName,
                  hint: 'Produit',
                  items:
                  widget.groups.map((g) => g.nomProduit).toList(),
                  onChanged: (nom) {
                    setState(() {
                      line.selectedProductName = nom;
                      line.selectedUnit = null;
                      final units =
                      line.getAvailableUnits(widget.groups);
                      if (units.length == 1) {
                        line.selectedUnit = units.first;
                      }
                    });
                    widget.onChanged();
                  },
                ),
              ),

              const SizedBox(width: 6),

              // ── COMBO UNITE ──
              Expanded(
                flex: 4,
                child: _UnitDropdown(
                  value: line.selectedUnit,
                  hint: 'Unite',
                  units: availableUnits,
                  enabled: line.selectedProductName != null,
                  onChanged: (u) {
                    setState(() => line.selectedUnit = u);
                    widget.onChanged();
                  },
                ),
              ),

              const SizedBox(width: 6),

              // ── QUANTITE ──
              SizedBox(
                width: 52,
                child: TextFormField(
                  controller: _qteCtrl,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.input.copyWith(fontSize: 13),
                  textAlign: TextAlign.center,
                  onChanged: (v) {
                    line.quantite = double.tryParse(v) ?? 1;
                    widget.onChanged();
                  },
                  decoration: const InputDecoration(
                    hintText: '1',
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // ── SUPPRIMER ──
              GestureDetector(
                onTap: widget.onRemove,
                child: Opacity(
                  opacity: widget.onRemove != null ? 1.0 : 0.3,
                  child: Container(
                    width: 28,
                    height: 28,
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

          // ── PRIX CALCULE ──
          if (line.selectedUnit != null) ...[
            const SizedBox(height: 8),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppGradients.invoiceTotal,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.badgeAccentBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppFormatters.currency(line.selectedUnit!.prixUnitaire)} × ${line.quantite.toStringAsFixed(line.quantite % 1 == 0 ? 0 : 1)}',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textMuted),
                  ),
                  GradientText(
                    '= ${AppFormatters.currency(line.selectedUnit!.prixUnitaire * line.quantite)}',
                    gradient: AppGradients.orange,
                    style: AppTextStyles.labelSmall
                        .copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// DROPDOWN CLIENT
// ═══════════════════════════════════════════
class _ClientDropdown extends StatelessWidget {
  final ClientModel? value;
  final List<ClientModel> clients;
  final ValueChanged<ClientModel?> onChanged;

  const _ClientDropdown({
    required this.value,
    required this.clients,
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
        child: DropdownButton<ClientModel>(
          value: value,
          hint: Text('Selectionner',
              style: AppTextStyles.input
                  .copyWith(color: AppColors.textFaint, fontSize: 14)),
          isExpanded: true,
          dropdownColor: const Color(0xFF10182A),
          style: AppTextStyles.input.copyWith(fontSize: 14),
          icon: const Icon(Icons.keyboard_arrow_down,
              color: AppColors.textFaint, size: 18),
          onChanged: onChanged,
          items: clients
              .map((c) => DropdownMenuItem<ClientModel>(
            value: c,
            child: Text(c.nomComplet,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.input.copyWith(fontSize: 14)),
          ))
              .toList(),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// DROPDOWN PRODUIT (String)
// ═══════════════════════════════════════════
class _StringDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _StringDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint,
              style: AppTextStyles.input
                  .copyWith(color: AppColors.textFaint, fontSize: 13),
              overflow: TextOverflow.ellipsis),
          isExpanded: true,
          dropdownColor: const Color(0xFF10182A),
          style: AppTextStyles.input.copyWith(fontSize: 13),
          icon: const Icon(Icons.keyboard_arrow_down,
              color: AppColors.textFaint, size: 16),
          onChanged: onChanged,
          items: items
              .map((nom) => DropdownMenuItem<String>(
            value: nom,
            child: Text(nom,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.input.copyWith(fontSize: 13)),
          ))
              .toList(),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// DROPDOWN UNITE (ProductUnitModel)
// ═══════════════════════════════════════════
class _UnitDropdown extends StatelessWidget {
  final ProductUnitModel? value;
  final String hint;
  final List<ProductUnitModel> units;
  final bool enabled;
  final ValueChanged<ProductUnitModel?> onChanged;

  const _UnitDropdown({
    required this.value,
    required this.hint,
    required this.units,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue =
    value != null && units.any((u) => u.id == value!.id) ? value : null;

    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: enabled ? AppColors.inputBg : AppColors.bgCardHover,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled
                ? AppColors.border
                : AppColors.border.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<ProductUnitModel>(
            value: safeValue,
            hint: Text(hint,
                style: AppTextStyles.input
                    .copyWith(color: AppColors.textFaint, fontSize: 13),
                overflow: TextOverflow.ellipsis),
            isExpanded: true,
            dropdownColor: const Color(0xFF10182A),
            style: AppTextStyles.input.copyWith(fontSize: 13),
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppColors.textFaint, size: 16),
            onChanged: enabled ? onChanged : null,
            items: units
                .map((u) => DropdownMenuItem<ProductUnitModel>(
              value: u,
              child: Text(
                u.nomUnite ?? u.symbolesUnite ?? '?',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.input.copyWith(fontSize: 13),
              ),
            ))
                .toList(),
          ),
        ),
      ),
    );
  }
}