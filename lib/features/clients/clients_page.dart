import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/formatters.dart';
import '../../app/utils/validators.dart';
import '../../core/models/client_model.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_text.dart';
import '../../core/widgets/search_field.dart';
import 'clients_provider.dart';

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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: SearchField(
                placeholder: 'Rechercher un client...',
                onChanged: (v) => setState(() => _search = v),
              ),
            ),
            const SizedBox(height: 12),
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
                      c.telephone.contains(_search) ||
                      (c.cin ?? '').contains(_search))
                      .toList();

                  if (filtered.isEmpty) {
                    return EmptyState(
                      icon: Icons.people_outline,
                      message: _search.isEmpty
                          ? 'Aucun client pour le moment'
                          : 'Aucun resultat pour "$_search"',
                      actionLabel:
                      _search.isEmpty ? 'Ajouter un client' : null,
                      onAction:
                      _search.isEmpty ? () => _openForm(context, ref) : null,
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
                        return _ClientCard(
                          client: client,
                          index: i - 1,
                          onEdit: () =>
                              _openForm(context, ref, client: client),
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
}

// ═══════════════════════════════
// CARTE CLIENT
// ═══════════════════════════════
class _ClientCard extends StatelessWidget {
  final ClientModel client;
  final int index;
  final VoidCallback onEdit;

  const _ClientCard({
    required this.client,
    required this.index,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar ou photo profil
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: client.photo == null
                  ? AppGradients.avatarAt(index)
                  : null,
              shape: BoxShape.circle,
              image: client.photo != null
                  ? DecorationImage(
                image: FileImage(File(client.photo!)),
                fit: BoxFit.cover,
              )
                  : null,
              border: Border.all(
                color: client.estVerifie
                    ? AppColors.success
                    : AppColors.border,
                width: 2,
              ),
            ),
            child: client.photo == null
                ? Center(
              child: Text(
                AppFormatters.firstLetter(client.nomComplet),
                style: AppTextStyles.titleMedium
                    .copyWith(color: Colors.white, fontSize: 18),
              ),
            )
                : null,
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
                if (client.adresse.isNotEmpty)
                  Text(
                    client.adresse,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textFaint),
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 5),
                // Badge CIN
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: client.estVerifie
                            ? AppColors.badgeSuccessBg
                            : AppColors.badgeDangerBg,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: client.estVerifie
                              ? AppColors.badgeSuccessBorder
                              : AppColors.badgeDangerBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            client.estVerifie
                                ? Icons.verified_outlined
                                : Icons.warning_amber_outlined,
                            size: 10,
                            color: client.estVerifie
                                ? AppColors.success
                                : AppColors.danger,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            client.estVerifie
                                ? 'CIN verifie'
                                : 'CIN manquant',
                            style: AppTextStyles.badge.copyWith(
                              color: client.estVerifie
                                  ? AppColors.success
                                  : AppColors.danger,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (client.cin != null && client.cin!.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Text(
                        client.cin!,
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textFaint),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Bouton modifier seulement - pas de suppression
          GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.badgeAccentBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.badgeAccentBorder),
              ),
              child: const Icon(Icons.edit_outlined,
                  size: 16, color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════
// FORMULAIRE CLIENT COMPLET
// ═══════════════════════════════
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
  late final TextEditingController _cinCtrl;

  String? _photoCinPath;
  String? _photoPath;
  bool _telValid = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nomCtrl =
        TextEditingController(text: widget.client?.nomComplet ?? '');
    _telCtrl =
        TextEditingController(text: widget.client?.telephone ?? '');
    _adrCtrl =
        TextEditingController(text: widget.client?.adresse ?? '');
    _cinCtrl = TextEditingController(text: widget.client?.cin ?? '');
    _photoCinPath = widget.client?.photoCin;
    _photoPath = widget.client?.photo;
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _telCtrl.dispose();
    _adrCtrl.dispose();
    _cinCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhotoCin() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      setState(() => _photoCinPath = result.files.single.path!);
    }
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      setState(() => _photoPath = result.files.single.path!);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_telValid) return;

    final cin = _cinCtrl.text.trim();
    if (cin.isNotEmpty && cin.length != 12) {
      AppToast.show(
          context, 'Le CIN doit avoir exactement 12 chiffres',
          type: ToastType.error);
      return;
    }
    if (cin.isNotEmpty && !RegExp(r'^\d+$').hasMatch(cin)) {
      AppToast.show(context, 'Le CIN ne doit contenir que des chiffres',
          type: ToastType.error);
      return;
    }

    setState(() => _isLoading = true);

    String? error;
    if (widget.client != null) {
      error = await ref.read(clientsNotifierProvider.notifier).update(
        id: widget.client!.id,
        nomComplet: _nomCtrl.text.trim(),
        telephone: _telCtrl.text.trim(),
        adresse: _adrCtrl.text.trim(),
        cin: cin.isNotEmpty ? cin : null,
        photoCin: _photoCinPath,
        photo: _photoPath,
      );
    } else {
      error = await ref.read(clientsNotifierProvider.notifier).create(
        nomComplet: _nomCtrl.text.trim(),
        telephone: _telCtrl.text.trim(),
        adresse: _adrCtrl.text.trim(),
        cin: cin.isNotEmpty ? cin : null,
        photoCin: _photoCinPath,
        photo: _photoPath,
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
    final cinComplet = _cinCtrl.text.trim().length == 12;
    final estVerifie = cinComplet && _photoCinPath != null;

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
        initialChildSize: 0.94,
        minChildSize: 0.5,
        maxChildSize: 0.97,
        expand: false,
        builder: (_, ctrl) => Column(
          children: [
            // Pull + titre
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
                          widget.client != null
                              ? 'Modifier client'
                              : 'Nouveau client',
                          gradient: AppGradients.brand,
                          style: AppTextStyles.headlineMedium,
                        ),
                      ),
                      // Badge non supprimable
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.badgeWarningBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.badgeWarningBorder),
                        ),
                        child: Text(
                          'Non supprimable',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.warning),
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

            Expanded(
              child: SingleChildScrollView(
                controller: ctrl,
                padding: EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── PHOTO PROFIL ───
                      Center(
                        child: GestureDetector(
                          onTap: _pickPhoto,
                          child: Stack(
                            children: [
                              Container(
                                width: 86,
                                height: 86,
                                decoration: BoxDecoration(
                                  gradient: _photoPath == null
                                      ? AppGradients.brand
                                      : null,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.border, width: 2),
                                  image: _photoPath != null
                                      ? DecorationImage(
                                    image:
                                    FileImage(File(_photoPath!)),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: _photoPath == null
                                    ? const Icon(Icons.person_outline,
                                    color: Colors.white, size: 38)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.bgDeep, width: 2),
                                  ),
                                  child: const Icon(Icons.camera_alt,
                                      size: 13, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text('Photo profil (optionnelle)',
                            style: AppTextStyles.caption),
                      ),

                      const SizedBox(height: 20),

                      // ─── NOM ───
                      _Label('Nom complet *'),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _nomCtrl,
                        validator: AppValidators.requiredName,
                        style: AppTextStyles.input,
                        decoration: const InputDecoration(
                          hintText: 'Ex: Jean Rakoto',
                          prefixIcon: Icon(Icons.person_outline,
                              size: 16, color: AppColors.textFaint),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ─── TELEPHONE ───
                      _Label('Telephone'),
                      const SizedBox(height: 7),
                      TextFormField(
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
                      if (!_telValid && _telCtrl.text.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Format: 034 / 033 / 032 / 038 (10 chiffres)',
                          style: AppTextStyles.inputHint
                              .copyWith(color: AppColors.danger),
                        ),
                      ],

                      const SizedBox(height: 14),

                      // ─── ADRESSE ───
                      _Label('Adresse'),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _adrCtrl,
                        style: AppTextStyles.input,
                        decoration: const InputDecoration(
                          hintText: 'Ex: Analakely, Tana',
                          prefixIcon: Icon(Icons.location_on_outlined,
                              size: 16, color: AppColors.textFaint),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ─── SEPARATEUR CIN ───
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.badgeAccentBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.badgeAccentBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline,
                                size: 14, color: AppColors.accent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'CIN + Photo CIN requis pour enregistrer des dettes',
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: AppColors.accent),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ─── CIN ───
                      _Label('Numero CIN (12 chiffres exactement)'),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _cinCtrl,
                        keyboardType: TextInputType.number,
                        maxLength: 12,
                        style: AppTextStyles.input,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: '123456789012',
                          counterText:
                          '${_cinCtrl.text.trim().length}/12 chiffres',
                          counterStyle: AppTextStyles.caption.copyWith(
                            color: _cinCtrl.text.trim().length == 12
                                ? AppColors.success
                                : AppColors.textFaint,
                          ),
                          prefixIcon: const Icon(
                              Icons.credit_card_outlined,
                              size: 16,
                              color: AppColors.textFaint),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _cinCtrl.text.trim().isNotEmpty &&
                                  _cinCtrl.text.trim().length != 12
                                  ? AppColors.danger
                                  : _cinCtrl.text.trim().length == 12
                                  ? AppColors.success
                                  : AppColors.border,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _cinCtrl.text.trim().length == 12
                                  ? AppColors.success
                                  : AppColors.accent,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v != null &&
                              v.trim().isNotEmpty &&
                              v.trim().length != 12) {
                            return 'Le CIN doit avoir exactement 12 chiffres';
                          }
                          if (v != null &&
                              v.trim().isNotEmpty &&
                              !RegExp(r'^\d+$').hasMatch(v.trim())) {
                            return 'Le CIN ne doit contenir que des chiffres';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // ─── PHOTO CIN ───
                      _Label('Photo du CIN'),
                      const SizedBox(height: 7),
                      GestureDetector(
                        onTap: _pickPhotoCin,
                        child: Container(
                          width: double.infinity,
                          height: _photoCinPath != null ? 200 : 110,
                          decoration: BoxDecoration(
                            color: AppColors.bgCardHover,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _photoCinPath != null
                                  ? AppColors.success
                                  : AppColors.border,
                              width: 1.5,
                            ),
                          ),
                          child: _photoCinPath != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  File(_photoCinPath!),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.bgDeep
                                          .withValues(alpha: 0.85),
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.edit_outlined,
                                            size: 12,
                                            color:
                                            AppColors.textMuted),
                                        SizedBox(width: 4),
                                        Text('Changer',
                                            style: TextStyle(
                                                color: AppColors
                                                    .textMuted,
                                                fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ),
                                // Badge vert si photo presente
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                            Icons
                                                .check_circle_outline,
                                            size: 10,
                                            color: Colors.white),
                                        SizedBox(width: 4),
                                        Text('Photo ajoutee',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight:
                                                FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: AppColors.textFaint,
                                  size: 36),
                              const SizedBox(height: 8),
                              Text(
                                'Appuyer pour ajouter la photo du CIN',
                                style: AppTextStyles.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Requis pour enregistrer des dettes',
                                style: AppTextStyles.caption
                                    .copyWith(
                                    color: AppColors.danger),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Statut verification
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: estVerifie
                              ? AppColors.badgeSuccessBg
                              : AppColors.badgeDangerBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: estVerifie
                                ? AppColors.badgeSuccessBorder
                                : AppColors.badgeDangerBorder,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              estVerifie
                                  ? Icons.verified_outlined
                                  : Icons.warning_amber_outlined,
                              size: 14,
                              color: estVerifie
                                  ? AppColors.success
                                  : AppColors.danger,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                estVerifie
                                    ? 'Client verifie - peut enregistrer des dettes'
                                    : 'CIN (12 chiffres) + Photo CIN manquants',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: estVerifie
                                      ? AppColors.success
                                      : AppColors.danger,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

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

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: AppTextStyles.inputLabel);
  }
}