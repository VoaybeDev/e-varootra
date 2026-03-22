import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/formatters.dart';
import '../../app/utils/validators.dart';
import '../../core/database/daos/product_dao.dart';
import '../../core/models/product_unit_model.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_text.dart';
import '../../core/widgets/search_field.dart';
import 'products_provider.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsNotifierProvider);

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
                      'Produits',
                      gradient: AppGradients.brand,
                      style: AppTextStyles.headlineLarge,
                    ),
                  ),
                  GradientButton(
                    label: 'Ajouter',
                    icon: Icons.add,
                    size: GradientButtonSize.small,
                    onPressed: () => _openForm(context, ref),
                  ),
                ],
              ),
            ),

            // Recherche
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: SearchField(
                placeholder: 'Rechercher un produit...',
                onChanged: (v) => setState(() => _search = v),
              ),
            ),

            const SizedBox(height: 12),

            // Liste
            Expanded(
              child: productsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.accent),
                ),
                error: (e, _) => EmptyState(
                  icon: Icons.error_outline,
                  message: 'Erreur : $e',
                  iconColor: AppColors.danger,
                ),
                data: (products) {
                  final filtered = _search.trim().isEmpty
                      ? products
                      : products
                      .where((p) => p.product.nom
                      .toLowerCase()
                      .contains(_search.toLowerCase()))
                      .toList();

                  if (filtered.isEmpty) {
                    return EmptyState(
                      icon: Icons.inventory_2_outlined,
                      message: _search.isEmpty
                          ? 'Aucun produit pour le moment'
                          : 'Aucun resultat pour "$_search"',
                      actionLabel:
                      _search.isEmpty ? 'Ajouter un produit' : null,
                      onAction: _search.isEmpty
                          ? () => _openForm(context, ref)
                          : null,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => ref
                        .read(productsNotifierProvider.notifier)
                        .load(),
                    color: AppColors.accent,
                    backgroundColor: AppColors.bgCard,
                    child: ListView.builder(
                      padding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => _ProductCard(
                        productWithUnits: filtered[i],
                        onEdit: () =>
                            _openForm(context, ref,
                                product: filtered[i]),
                        onDelete: () =>
                            _confirmDelete(context, ref, filtered[i]),
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

  void _openForm(BuildContext context, WidgetRef ref,
      {ProductWithUnits? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductForm(
        product: product,
        onSaved: () {
          ref.read(productsNotifierProvider.notifier).load();
          ref.invalidate(allProductUnitsProvider);
          Navigator.pop(context);
          AppToast.show(
            context,
            product != null ? 'Produit modifie' : 'Produit ajoute',
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, ProductWithUnits p) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF10182A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text('Supprimer ${p.product.nom} ?',
            style: AppTextStyles.headlineSmall),
        content: Text(
          'Cette action est irreversible.',
          style: AppTextStyles.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer',
                style: TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final error = await ref
          .read(productsNotifierProvider.notifier)
          .deleteProduct(p.product.id);
      if (mounted) {
        if (error != null) {
          AppToast.show(context, error, type: ToastType.error);
        } else {
          AppToast.show(context, 'Produit supprime');
        }
      }
    }
  }
}

// ═══════════════════════════════
// CARTE PRODUIT
// ═══════════════════════════════
class _ProductCard extends ConsumerStatefulWidget {
  final ProductWithUnits productWithUnits;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.productWithUnits,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  ConsumerState<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<_ProductCard> {
  bool _showHistory = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.productWithUnits;
    final totalHistory = p.units.fold<int>(
        0, (sum, u) => sum + u.history.length);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header produit
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        p.product.nom,
                        gradient: AppGradients.brand,
                        style: AppTextStyles.headlineSmall,
                      ),
                      if (p.product.description != null &&
                          p.product.description!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          p.product.description!,
                          style: AppTextStyles.bodySmall
                              .copyWith(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onEdit,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.badgeAccentBg,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Icon(Icons.edit_outlined,
                            size: 14, color: AppColors.accent),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: widget.onDelete,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.badgeDangerBg,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Icon(Icons.delete_outline,
                            size: 14, color: AppColors.danger),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Chips unites
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: p.units.map((u) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.bgCardHover,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        u.unit.nomUnite ?? '?',
                        style: AppTextStyles.labelSmall
                            .copyWith(fontSize: 11),
                      ),
                      const SizedBox(width: 5),
                      GradientText(
                        AppFormatters.currency(u.unit.prixUnitaire),
                        gradient: AppGradients.brand,
                        style: AppTextStyles.labelSmall
                            .copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Bouton historique
          if (totalHistory > 0)
            GestureDetector(
              onTap: () =>
                  setState(() => _showHistory = !_showHistory),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.history,
                        size: 12, color: AppColors.textFaint),
                    const SizedBox(width: 5),
                    Text(
                      'Historique prix ($totalHistory)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textFaint,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _showHistory
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 14,
                      color: AppColors.textFaint,
                    ),
                  ],
                ),
              ),
            ),

          // Historique des prix
          if (_showHistory)
            Container(
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: p.units.expand((u) {
                  if (u.history.isEmpty) return <Widget>[];
                  return u.history.map((h) =>
                      _PriceHistoryRow(
                        entry: h,
                        unitName: u.unit.nomUnite ?? '?',
                      ));
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════
// LIGNE HISTORIQUE PRIX
// ═══════════════════════════════
class _PriceHistoryRow extends StatelessWidget {
  final PriceHistoryEntry entry;
  final String unitName;

  const _PriceHistoryRow({
    required this.entry,
    required this.unitName,
  });

  @override
  Widget build(BuildContext context) {
    final pct = entry.pourcentageChangement;
    final pctStr =
        '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(1)}%';

    // Couleur selon hausse/baisse
    final color =
    entry.estHausse ? AppColors.danger : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: AppColors.border.withValues(alpha: 0.5)),
          left: BorderSide(
            color: entry.estHausse
                ? AppColors.danger
                : AppColors.success,
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          // Emoji + unite
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    entry.emoji,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    unitName,
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              // Prix ancien -> nouveau
              Row(
                children: [
                  Text(
                    AppFormatters.currency(entry.ancienPrix),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textFaint,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.arrow_forward,
                        size: 10, color: AppColors.textFaint),
                  ),
                  Text(
                    AppFormatters.currency(entry.nouveauPrix),
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      pctStr,
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // Pseudo + date + heure
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 10, color: AppColors.accent),
                  const SizedBox(width: 3),
                  Text(
                    '@${entry.pseudo}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(Icons.schedule_outlined,
                      size: 10, color: AppColors.textFaint),
                  const SizedBox(width: 3),
                  Text(
                    '${AppFormatters.dateShort(entry.dateModification)} ${entry.dateModification.hour.toString().padLeft(2, '0')}:${entry.dateModification.minute.toString().padLeft(2, '0')}',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════
// FORMULAIRE PRODUIT
// ═══════════════════════════════
class _ProductForm extends ConsumerStatefulWidget {
  final ProductWithUnits? product;
  final VoidCallback onSaved;

  const _ProductForm({this.product, required this.onSaved});

  @override
  ConsumerState<_ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends ConsumerState<_ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomCtrl;
  late final TextEditingController _descCtrl;
  final List<_UnitEntry> _units = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(
        text: widget.product?.product.nom ?? '');
    _descCtrl = TextEditingController(
        text: widget.product?.product.description ?? '');

    if (widget.product != null) {
      for (final u in widget.product!.units) {
        _units.add(_UnitEntry(
          id: u.unit.id,
          nameCtrl:
          TextEditingController(text: u.unit.nomUnite ?? ''),
          priceCtrl: TextEditingController(
              text: u.unit.prixUnitaire.toStringAsFixed(0)),
        ));
      }
    } else {
      _units.add(_UnitEntry(
        nameCtrl: TextEditingController(),
        priceCtrl: TextEditingController(),
      ));
    }
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _descCtrl.dispose();
    for (final u in _units) {
      u.nameCtrl.dispose();
      u.priceCtrl.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final validUnits = _units
        .where((u) =>
    u.nameCtrl.text.trim().isNotEmpty &&
        u.priceCtrl.text.trim().isNotEmpty)
        .toList();

    if (validUnits.isEmpty) {
      AppToast.show(context, 'Ajoutez au moins une unite avec un prix',
          type: ToastType.error);
      return;
    }

    setState(() => _isLoading = true);

    String? error;
    if (widget.product != null) {
      error = await ref
          .read(productsNotifierProvider.notifier)
          .updateProduct(
        productId: widget.product!.product.id,
        nom: _nomCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        units: validUnits
            .map((u) => (
        id: u.id,
        uniteName: u.nameCtrl.text.trim(),
        prix: double.tryParse(u.priceCtrl.text) ?? 0,
        ))
            .toList(),
      );
    } else {
      error = await ref
          .read(productsNotifierProvider.notifier)
          .createProduct(
        nom: _nomCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        units: validUnits
            .map((u) => (
        uniteName: u.nameCtrl.text.trim(),
        prix: double.tryParse(u.priceCtrl.text) ?? 0,
        ))
            .toList(),
      );
    }

    setState(() => _isLoading = false);

    if (error != null && mounted) {
      AppToast.show(context, error, type: ToastType.error);
    } else {
      widget.onSaved();
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
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, ctrl) => Column(
          children: [
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
                        child: GradientText(
                          widget.product != null
                              ? 'Modifier produit'
                              : 'Nouveau produit',
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
                controller: ctrl,
                padding: EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom
                      Text('NOM *', style: AppTextStyles.inputLabel),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _nomCtrl,
                        validator: AppValidators.requiredName,
                        style: AppTextStyles.input,
                        decoration: const InputDecoration(
                          hintText: 'Ex: Riz, Farine, Sucre...',
                          prefixIcon: Icon(
                              Icons.inventory_2_outlined,
                              size: 16,
                              color: AppColors.textFaint),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Description
                      Text('DESCRIPTION',
                          style: AppTextStyles.inputLabel),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _descCtrl,
                        style: AppTextStyles.input,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'Description optionnelle...',
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Unites & Prix
                      Row(
                        children: [
                          Expanded(
                            child: Text('UNITES & PRIX',
                                style: AppTextStyles.inputLabel),
                          ),
                          GestureDetector(
                            onTap: () => setState(() {
                              _units.add(_UnitEntry(
                                nameCtrl: TextEditingController(),
                                priceCtrl: TextEditingController(),
                              ));
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.bgCardHover,
                                borderRadius:
                                BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.add,
                                      size: 12,
                                      color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text('Ajouter',
                                      style:
                                      AppTextStyles.labelSmall),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      ...List.generate(_units.length, (i) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.bgCardHover,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _units[i].nameCtrl,
                                  style: AppTextStyles.input,
                                  decoration: const InputDecoration(
                                    hintText: 'Unite (pièce, kg...)',
                                    contentPadding:
                                    EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10),
                                  ),
                                  validator: (v) =>
                                  v != null && v.trim().isEmpty
                                      ? 'Requis'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 110,
                                child: TextFormField(
                                  controller: _units[i].priceCtrl,
                                  keyboardType: TextInputType.number,
                                  style: AppTextStyles.input,
                                  decoration: const InputDecoration(
                                    hintText: 'Prix Ar',
                                    contentPadding:
                                    EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty)
                                      return 'Requis';
                                    if (double.tryParse(v) == null)
                                      return 'Invalide';
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _units.length > 1
                                    ? () => setState(
                                        () => _units.removeAt(i))
                                    : null,
                                child: Opacity(
                                  opacity:
                                  _units.length > 1 ? 1.0 : 0.3,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.badgeDangerBg,
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.close,
                                        size: 13,
                                        color: AppColors.danger),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 18),

                      GradientButton(
                        label: 'Enregistrer',
                        icon: Icons.save_outlined,
                        onPressed: _isLoading ? null : _save,
                        fullWidth: true,
                        size: GradientButtonSize.large,
                        isLoading: _isLoading,
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

class _UnitEntry {
  final int? id;
  final TextEditingController nameCtrl;
  final TextEditingController priceCtrl;

  _UnitEntry({
    this.id,
    required this.nameCtrl,
    required this.priceCtrl,
  });
}