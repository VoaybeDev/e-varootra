import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/formatters.dart';
import '../../app/utils/validators.dart';
import '../../core/models/client_model.dart';
import '../../core/widgets/app_sheet.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_text.dart';
import '../../core/widgets/search_field.dart';
import '../clients/clients_provider.dart';

class ClientsPage extends ConsumerStatefulWidget {
  const ClientsPage({super.key});

  @override
  ConsumerState<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends ConsumerState<ClientsPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsNotifierProvider);

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
                      'Clients',
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
                placeholder: 'Rechercher un client...',
                onChanged: (v) => setState(() => _search = v),
              ),
            ),

            const SizedBox(height: 12),

            // Liste
            Expanded(
              child: clientsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
                error: (e, _) => EmptyState(
                  icon: Icons.error_outline,
                  message: 'Erreur : $e',
                  iconColor: AppColors.danger,
                ),
                data: (clients) {
                  final filtered = _search.trim().isEmpty
                      ? clients
                      : clients
                      .where((c) =>
                  c.nomComplet
                      .toLowerCase()
                      .contains(_search.toLowerCase()) ||
                      c.telephone.contains(_search))
                      .toList();

                  if (filtered.isEmpty) {
                    return EmptyState(
                      icon: Icons.people_outline,
                      message: _search.isEmpty
                          ? 'Aucun client pour le moment'
                          : 'Aucun resultat pour "$_search"',
                      actionLabel: _search.isEmpty ? 'Ajouter un client' : null,
                      onAction: _search.isEmpty
                          ? () => _openForm(context, ref)
                          : null,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async =>
                        ref.read(clientsNotifierProvider.notifier).load(),
                    color: AppColors.accent,
                    backgroundColor: AppColors.bgCard,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: filtered.length + 1,
                      itemBuilder: (_, i) {
                        if (i == 0) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              '${filtered.length} client${filtered.length > 1 ? 's' : ''}',
                              style: AppTextStyles.labelSmall,
                            ),
                          );
                        }
                        final client = filtered[i - 1];
                        return _ClientRow(
                          client: client,
                          index: i - 1,
                          onEdit: () => _openForm(context, ref, client: client),
                          onDelete: () =>
                              _confirmDelete(context, ref, client),
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

  void _openForm(BuildContext context, WidgetRef ref,
      {ClientModel? client}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ClientForm(
        client: client,
        onSaved: () {
          ref.read(clientsNotifierProvider.notifier).load();
          Navigator.pop(context);
          AppToast.show(
            context,
            client != null ? 'Client modifie' : 'Client ajoute',
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, ClientModel client) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF10182A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text('Supprimer ${client.nomComplet} ?',
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
          .read(clientsNotifierProvider.notifier)
          .deactivate(client.id);
      if (mounted) {
        if (error != null) {
          AppToast.show(context, error, type: ToastType.error);
        } else {
          AppToast.show(context, 'Client supprime');
        }
      }
    }
  }
}

class _ClientRow extends StatelessWidget {
  final ClientModel client;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ClientRow({
    required this.client,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: AppGradients.avatarAt(index),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                AppFormatters.firstLetter(client.nomComplet),
                style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.nomComplet,
                  style: AppTextStyles.labelLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  client.telephone.isNotEmpty
                      ? client.telephone
                      : 'Pas de telephone',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),

          // Actions
          Row(
            children: [
              _ActionBtn(
                icon: Icons.edit_outlined,
                color: AppColors.accent,
                bg: AppColors.badgeAccentBg,
                onTap: onEdit,
              ),
              const SizedBox(width: 6),
              _ActionBtn(
                icon: Icons.delete_outline,
                color: AppColors.danger,
                bg: AppColors.badgeDangerBg,
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
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

class _ClientForm extends ConsumerStatefulWidget {
  final ClientModel? client;
  final VoidCallback onSaved;

  const _ClientForm({this.client, required this.onSaved});

  @override
  ConsumerState<_ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends ConsumerState<_ClientForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomCtrl;
  late final TextEditingController _telCtrl;
  late final TextEditingController _adrCtrl;
  bool _telValid = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.client?.nomComplet ?? '');
    _telCtrl = TextEditingController(text: widget.client?.telephone ?? '');
    _adrCtrl = TextEditingController(text: widget.client?.adresse ?? '');
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _telCtrl.dispose();
    _adrCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_telValid) return;

    setState(() => _isLoading = true);

    String? error;
    if (widget.client != null) {
      error = await ref.read(clientsNotifierProvider.notifier).update(
        id: widget.client!.id,
        nomComplet: _nomCtrl.text.trim(),
        telephone: _telCtrl.text.trim(),
        adresse: _adrCtrl.text.trim(),
      );
    } else {
      error = await ref.read(clientsNotifierProvider.notifier).create(
        nomComplet: _nomCtrl.text.trim(),
        telephone: _telCtrl.text.trim(),
        adresse: _adrCtrl.text.trim(),
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
              margin: const EdgeInsets.only(top: 6, bottom: 16),
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
                  widget.client != null ? 'Modifier client' : 'Nouveau client',
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

          const SizedBox(height: 18),

          Form(
            key: _formKey,
            child: Column(
              children: [
                // Nom
                _FormField(
                  label: 'Nom complet *',
                  child: TextFormField(
                    controller: _nomCtrl,
                    validator: AppValidators.requiredName,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      hintText: 'Ex: Maman Jeri',
                      prefixIcon: Icon(Icons.person_outline,
                          size: 16, color: AppColors.textFaint),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Telephone
                _FormField(
                  label: 'Telephone',
                  child: TextFormField(
                    controller: _telCtrl,
                    keyboardType: TextInputType.phone,
                    style: AppTextStyles.input,
                    onChanged: (v) {
                      setState(() {
                        _telValid = AppValidators.isValidPhone(v);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: '034 XX XXX XX',
                      prefixIcon: const Icon(Icons.phone_outlined,
                          size: 16, color: AppColors.textFaint),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _telCtrl.text.isNotEmpty && !_telValid
                              ? AppColors.danger
                              : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                if (!_telValid && _telCtrl.text.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Format: 034 / 033 / 032 / 038 (10 chiffres)',
                    style: AppTextStyles.inputHint
                        .copyWith(color: AppColors.danger),
                  ),
                ],

                const SizedBox(height: 14),

                // Adresse
                _FormField(
                  label: 'Adresse',
                  child: TextFormField(
                    controller: _adrCtrl,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      hintText: 'Ex: Analakely, Tana',
                      prefixIcon: Icon(Icons.location_on_outlined,
                          size: 16, color: AppColors.textFaint),
                    ),
                  ),
                ),

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
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final Widget child;

  const _FormField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.inputLabel),
        const SizedBox(height: 7),
        child,
      ],
    );
  }
}