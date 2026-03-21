import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/formatters.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_text.dart';
import '../../core/widgets/search_field.dart';
import '../products/products_provider.dart';

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
                onChanged: (v) {
                  setState(() => _search = v);
                  ref.read(productsNotifierProvider.notifier).load(v);
                },
              ),
            ),

            const SizedBox(height: 12),

            // Liste
            Expanded(
              child: productsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
                error: (e, _) => EmptyState(
                  icon: Icons.error_outline,
                  message: 'Erreur : $e',
                  iconColor: AppColors.danger,
                ),
                data: (products) {
                  if (products.isEmpty) {
                    return EmptyState(
                      icon: Icons.inventory_2_outlined,
                      message: _search.isEmpty
                          ? 'Aucun produit pour le moment'
                          : 'Aucun resultat pour "$_search"',
                      actionLabel:
                      _search.isEmpty ? 'Ajouter un produit' : null,
                      onAction:
                      _search.isEmpty ? () => _openForm(context, ref) : null,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async =>
                        ref.read(productsNotifierProvider.notifier).load(),
                    color: AppColors.accent,
                    backgroundColor: AppColors.bgCard,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: products.length,
                      itemBuilder: (_, i) => _ProductCard(
                        item: products[i],
                        onEdit: () =>
                            _openForm(context, ref, item: products[i]),
                        onDelete: () =>
                            _confirmDelete(context, ref, products[i]),
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
      {ProductWithUnits? item}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductForm(
        item: item,
        onSaved: () {
          ref.read(productsNotifierProvider.notifier).load();
          Navigator.pop(context);
          AppToast.show(
            context,
            item != null ? 'Produit modifie' : 'Produit ajoute',
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, ProductWithUnits item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF10182A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text('Supprimer ${item.product.nom} ?',
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
                    color: AppColors.danger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final error = await ref
          .read(productsNotifierProvider.notifier)
          .deactivate(item.product.id);
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

class _ProductCard extends StatefulWidget {
  final ProductWithUnits item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _histOpen = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.item.product;
    final units = widget.item.units;
    final allHist = units
        .expand((u) => u.history.map((h) => (
    unit: u.productUnit,
    history: h,
    )))
        .toList()
      ..sort((a, b) =>
          b.history.dateModification.compareTo(a.history.dateModification));

    return Container(
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
          // Header produit
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(
                      p.nom,
                      gradient: AppGradients.brand,
                      style: AppTextStyles.titleLarge,
                    ),
                    if (p.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          p.description,
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  _ActionBtn(
                    icon: Icons.edit_outlined,
                    color: AppColors.accent,
                    bg: AppColors.badgeAccentBg,
                    onTap: widget.onEdit,
                  ),
                  const SizedBox(width: 6),
                  _ActionBtn(
                    icon: Icons.delete_outline,
                    color: AppColors.danger,
                    bg: AppColors.badgeDangerBg,
                    onTap: widget.onDelete,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Chips unites
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: units.map((u) {
              final label = u.productUnit.labelUnite;
              final prix = AppFormatters.currency(u.productUnit.prixUnitaire);
              return Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.badgeAccentBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.badgeAccentBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label, style: AppTextStyles.labelSmall),
                    const SizedBox(width: 6),
                    GradientText(
                      prix,
                      gradient: AppGradients.green,
                      style: AppTextStyles.labelSmall
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          // Historique prix
          if (allHist.isNotEmpty) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => setState(() => _histOpen = !_histOpen),
              child: Row(
                children: [
                  const Icon(Icons.history,
                      size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 5),
                  Text(
                    'Historique prix (${allHist.length})',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    _histOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
            if (_histOpen) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  children: allHist.take(8).map((entry) {
                    final isUp =
                        entry.history.nouveauPrix > entry.history.ancienPrix;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.bgCardHover,
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          left: BorderSide(
                            color:
                            isUp ? AppColors.danger : AppColors.success,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.productUnit.labelUnite,
                                  style: AppTextStyles.labelSmall.copyWith(
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Text(
                                      AppFormatters.currency(
                                          entry.history.ancienPrix),
                                      style: AppTextStyles.caption.copyWith(
                                          color: AppColors.textFaint),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: Icon(Icons.arrow_forward,
                                          size: 10,
                                          color: AppColors.textFaint),
                                    ),
                                    Text(
                                      AppFormatters.currency(
                                          entry.history.nouveauPrix),
                                      style: AppTextStyles.caption.copyWith(
                                        color: isUp
                                            ? AppColors.danger
                                            : AppColors.success,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            AppFormatters.dateFromString(
                              entry.history.dateModification.toString(),
                            ),
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _ProductForm extends ConsumerStatefulWidget {
  final ProductWithUnits? item;
  final VoidCallback onSaved;

  const _ProductForm({this.item, required this.onSaved});

  @override
  ConsumerState<_ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends ConsumerState<_ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomCtrl;
  late final TextEditingController _descCtrl;
  bool _isLoading = false;

  // Lignes unites
  final List<_UnitLine> _unitLines = [];

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.item?.product.nom ?? '');
    _descCtrl =
        TextEditingController(text: widget.item?.product.description ?? '');

    if (widget.item != null) {
      for (final u in widget.item!.units) {
        _unitLines.add(_UnitLine(
          id: u.productUnit.id,
          labelCtrl: TextEditingController(
              text: u.productUnit.labelUnite),
          prixCtrl: TextEditingController(
              text: u.productUnit.prixUnitaire.toStringAsFixed(0)),
        ));
      }
    } else {
      _addLine();
    }
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _descCtrl.dispose();
    for (final l in _unitLines) {
      l.labelCtrl.dispose();
      l.prixCtrl.dispose();
    }
    super.dispose();
  }

  void _addLine() {
    setState(() => _unitLines.add(_UnitLine(
      labelCtrl: TextEditingController(),
      prixCtrl: TextEditingController(),
    )));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final inputs = _unitLines
        .where((l) => l.labelCtrl.text.trim().isNotEmpty)
        .map((l) => ProductUnitInput(
      id: l.id,
      label: l.labelCtrl.text.trim(),
      prix: double.tryParse(l.prixCtrl.text) ?? 0,
    ))
        .toList();

    if (inputs.isEmpty) {
      AppToast.show(context, 'Ajoutez au moins une unite',
          type: ToastType.error);
      return;
    }

    setState(() => _isLoading = true);
    final userId = 1; // recuperer depuis authProvider en production

    String? error;
    if (widget.item != null) {
      error = await ref.read(productsNotifierProvider.notifier).updateProduct(
        productId: widget.item!.product.id,
        nom: _nomCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        unitInputs: inputs,
        userId: userId,
      );
    } else {
      error = await ref.read(productsNotifierProvider.notifier).createProduct(
        nom: _nomCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        unitInputs: inputs,
        userId: userId,
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
                          widget.item != null
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
                      _Label('Nom *'),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _nomCtrl,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Requis'
                            : null,
                        style: AppTextStyles.input,
                        decoration: const InputDecoration(
                            hintText: 'Ex: Riz blanc 25kg'),
                      ),

                      const SizedBox(height: 14),

                      // Description
                      _Label('Description'),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _descCtrl,
                        style: AppTextStyles.input,
                        maxLines: 2,
                        decoration: const InputDecoration(
                            hintText: 'Description optionnelle...'),
                      ),

                      const SizedBox(height: 18),

                      // Unites
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'UNITES & PRIX',
                              style: AppTextStyles.inputLabel,
                            ),
                          ),
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
                                  Text('Ajouter',
                                      style: AppTextStyles.labelSmall),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Lignes
                      ...List.generate(_unitLines.length, (i) {
                        final line = _unitLines[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: line.labelCtrl,
                                  style: AppTextStyles.input.copyWith(
                                      fontSize: 13),
                                  decoration: const InputDecoration(
                                    hintText: 'Unite (ex: kg)',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: line.prixCtrl,
                                  keyboardType: TextInputType.number,
                                  style: AppTextStyles.input.copyWith(
                                      fontSize: 13),
                                  decoration: const InputDecoration(
                                    hintText: 'Prix (Ar)',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _unitLines.length > 1
                                    ? () => setState(
                                        () => _unitLines.removeAt(i))
                                    : null,
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

class _UnitLine {
  final int? id;
  final TextEditingController labelCtrl;
  final TextEditingController prixCtrl;

  _UnitLine({this.id, required this.labelCtrl, required this.prixCtrl});
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: AppTextStyles.inputLabel);
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }
}