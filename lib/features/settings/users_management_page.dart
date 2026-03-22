import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/models/user_model.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_text.dart';
import '../auth/auth_provider.dart';

class UsersManagementPage extends ConsumerWidget {
  const UsersManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null || !currentUser.estAdmin) {
      return const Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Center(child: Text('Acces non autorise')),
      );
    }

    final tabCount = currentUser.estSuperuser ? 4 : 3;

    return DefaultTabController(
      length: tabCount,
      child: Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                      child: GradientText('Gestion utilisateurs',
                          gradient: AppGradients.brand,
                          style: AppTextStyles.headlineLarge),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Legende couleurs roles
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _RoleLegend(
                        color: AppColors.accent,
                        label: 'Superutilisateur'),
                    const SizedBox(width: 8),
                    _RoleLegend(
                        color: AppColors.warning, label: 'Admin'),
                    const SizedBox(width: 8),
                    _RoleLegend(
                        color: AppColors.success,
                        label: 'Utilisateur'),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Onglets
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.bgCardHover,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      gradient: AppGradients.brand,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelStyle: AppTextStyles.labelSmall,
                    unselectedLabelStyle: AppTextStyles.labelSmall,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textMuted,
                    tabs: [
                      const Tab(text: 'Attente'),
                      const Tab(text: 'Actifs'),
                      const Tab(text: 'Bannis'),
                      if (currentUser.estSuperuser)
                        const Tab(text: 'Admin'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: TabBarView(
                  children: [
                    _PendingTab(),
                    _ActiveTab(),
                    _BannedTab(),
                    if (currentUser.estSuperuser) _CreateAdminTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _RoleLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 8,
            height: 8,
            decoration:
            BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label,
            style: AppTextStyles.caption.copyWith(fontSize: 9)),
      ],
    );
  }
}

// ═══════════════════════════════
// TAB EN ATTENTE
// ═══════════════════════════════
class _PendingTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingUsersProvider);

    return pendingAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent)),
      error: (e, _) => Center(child: Text('Erreur: $e')),
      data: (users) {
        if (users.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline,
                    color: AppColors.success, size: 48),
                SizedBox(height: 12),
                Text('Aucun compte en attente',
                    style: TextStyle(color: AppColors.textMuted)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: users.length,
          itemBuilder: (_, i) => _UserCard(
            user: users[i],
            actions: [
              _CardAction(
                label: 'Rejeter',
                icon: Icons.close,
                color: AppColors.danger,
                bgColor: AppColors.badgeDangerBg,
                onTap: () async {
                  await ref
                      .read(authProvider.notifier)
                      .rejectUser(users[i].id);
                  ref.invalidate(pendingUsersProvider);
                  if (context.mounted) {
                    AppToast.show(context, 'Utilisateur rejete',
                        type: ToastType.error);
                  }
                },
              ),
              _CardAction(
                label: 'Approuver',
                icon: Icons.check,
                color: Colors.white,
                bgColor: null,
                gradient: AppGradients.green,
                onTap: () async {
                  await ref
                      .read(authProvider.notifier)
                      .approveUser(users[i].id);
                  ref.invalidate(pendingUsersProvider);
                  ref.invalidate(approvedUsersProvider);
                  if (context.mounted) {
                    AppToast.show(
                        context, '${users[i].nomComplet} approuve');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════
// TAB ACTIFS
// ═══════════════════════════════
class _ActiveTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(approvedUsersProvider);
    final currentUser = ref.watch(currentUserProvider);

    return usersAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent)),
      error: (e, _) => Center(child: Text('Erreur: $e')),
      data: (users) => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: users.length,
        itemBuilder: (_, i) {
          final u = users[i];
          final isMe = u.id == currentUser?.id;

          // Determiner si on peut bannir/supprimer cet utilisateur
          final canAct = !isMe &&
              (currentUser!.estSuperuser ||
                  (currentUser.estAdmin && u.estUtilisateur));

          return _UserCard(
            user: u,
            showSelf: isMe,
            actions: canAct
                ? [
              // Superuser peut supprimer admin
              if (currentUser.estSuperuser || u.estUtilisateur)
                _CardAction(
                  label: 'Bannir',
                  icon: Icons.block,
                  color: AppColors.warning,
                  bgColor: AppColors.badgeWarningBg,
                  onTap: () async {
                    final confirm = await _showConfirm(
                      context,
                      'Bannir ${u.nomComplet} ?',
                      'Cet utilisateur ne pourra plus se connecter. Il peut demander la reactivation.',
                    );
                    if (confirm == true) {
                      await ref
                          .read(authProvider.notifier)
                          .banUser(u.id);
                      ref.invalidate(approvedUsersProvider);
                      ref.invalidate(bannedUsersProvider);
                      if (context.mounted) {
                        AppToast.show(context,
                            '${u.nomComplet} est maintenant banni');
                      }
                    }
                  },
                ),
              _CardAction(
                label: 'Supprimer',
                icon: Icons.delete_outline,
                color: AppColors.danger,
                bgColor: AppColors.badgeDangerBg,
                onTap: () async {
                  final confirm = await _showConfirm(
                    context,
                    'Supprimer ${u.nomComplet} ?',
                    'Cette action est irreversible. Le compte sera definitvement supprime.',
                  );
                  if (confirm == true) {
                    await ref
                        .read(authProvider.notifier)
                        .permanentlyDeleteUser(u.id);
                    ref.invalidate(approvedUsersProvider);
                    if (context.mounted) {
                      AppToast.show(
                          context, '${u.nomComplet} supprime',
                          type: ToastType.error);
                    }
                  }
                },
              ),
            ]
                : [],
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════
// TAB BANNIS
// ═══════════════════════════════
class _BannedTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannedAsync = ref.watch(bannedUsersProvider);

    return bannedAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent)),
      error: (e, _) => Center(child: Text('Erreur: $e')),
      data: (users) {
        if (users.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_outlined,
                    color: AppColors.success, size: 48),
                SizedBox(height: 12),
                Text('Aucun compte banni',
                    style: TextStyle(color: AppColors.textMuted)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: users.length,
          itemBuilder: (_, i) => _UserCard(
            user: users[i],
            isBanned: true,
            actions: [
              _CardAction(
                label: 'Debannir',
                icon: Icons.lock_open_outlined,
                color: Colors.white,
                bgColor: null,
                gradient: AppGradients.green,
                onTap: () async {
                  await ref
                      .read(authProvider.notifier)
                      .unbanUser(users[i].id);
                  ref.invalidate(bannedUsersProvider);
                  ref.invalidate(approvedUsersProvider);
                  if (context.mounted) {
                    AppToast.show(
                        context, '${users[i].nomComplet} debannis');
                  }
                },
              ),
              _CardAction(
                label: 'Supprimer',
                icon: Icons.delete_forever_outlined,
                color: AppColors.danger,
                bgColor: AppColors.badgeDangerBg,
                onTap: () async {
                  final confirm = await _showConfirm(
                    context,
                    'Supprimer definitivement ${users[i].nomComplet} ?',
                    'Cette action est irreversible.',
                  );
                  if (confirm == true) {
                    await ref
                        .read(authProvider.notifier)
                        .permanentlyDeleteUser(users[i].id);
                    ref.invalidate(bannedUsersProvider);
                    if (context.mounted) {
                      AppToast.show(
                          context, '${users[i].nomComplet} supprime',
                          type: ToastType.error);
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════
// TAB CREER ADMIN (superuser only)
// ═══════════════════════════════
class _CreateAdminTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreateAdminTab> createState() => _CreateAdminTabState();
}

class _CreateAdminTabState extends ConsumerState<_CreateAdminTab> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _pseudoCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  bool _isLoading = false;
  bool _pwdVisible = false;

  @override
  void dispose() {
    _nomCtrl.dispose();
    _pseudoCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final ok = await ref.read(authProvider.notifier).createAdmin(
      nomComplet: _nomCtrl.text.trim(),
      pseudo: _pseudoCtrl.text.trim(),
      password: _pwdCtrl.text,
    );
    setState(() => _isLoading = false);
    if (ok && mounted) {
      _nomCtrl.clear();
      _pseudoCtrl.clear();
      _pwdCtrl.clear();
      ref.invalidate(approvedUsersProvider);
      AppToast.show(context, 'Compte admin cree avec succes');
    } else if (mounted) {
      AppToast.show(context, 'Erreur lors de la creation',
          type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.badgeAccentBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.badgeAccentBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.admin_panel_settings_outlined,
                      color: AppColors.accent, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Seul le superutilisateur peut creer un compte administrateur. Les admins peuvent gerer les utilisateurs.',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.accent),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text('NOM COMPLET *', style: AppTextStyles.inputLabel),
            const SizedBox(height: 7),
            TextFormField(
              controller: _nomCtrl,
              style: AppTextStyles.input,
              validator: (v) =>
              v == null || v.trim().isEmpty ? 'Requis' : null,
              decoration: const InputDecoration(
                hintText: 'Nom du nouvel admin',
                prefixIcon: Icon(Icons.person_outline,
                    size: 16, color: AppColors.textFaint),
              ),
            ),

            const SizedBox(height: 14),

            Text('PSEUDO *', style: AppTextStyles.inputLabel),
            const SizedBox(height: 7),
            TextFormField(
              controller: _pseudoCtrl,
              style: AppTextStyles.input,
              validator: (v) =>
              v == null || v.trim().length < 3
                  ? 'Min 3 caracteres'
                  : null,
              decoration: const InputDecoration(
                hintText: 'Pseudo unique',
                prefixIcon: Icon(Icons.alternate_email,
                    size: 16, color: AppColors.textFaint),
              ),
            ),

            const SizedBox(height: 14),

            Text('MOT DE PASSE *', style: AppTextStyles.inputLabel),
            const SizedBox(height: 7),
            TextFormField(
              controller: _pwdCtrl,
              obscureText: !_pwdVisible,
              style: AppTextStyles.input,
              validator: (v) =>
              v == null || v.length < 4 ? 'Min 4 caracteres' : null,
              decoration: InputDecoration(
                hintText: 'Mot de passe',
                prefixIcon: const Icon(Icons.lock_outline,
                    size: 16, color: AppColors.textFaint),
                suffixIcon: IconButton(
                  icon: Icon(
                    _pwdVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textFaint,
                    size: 16,
                  ),
                  onPressed: () =>
                      setState(() => _pwdVisible = !_pwdVisible),
                ),
              ),
            ),

            const SizedBox(height: 24),

            GradientButton(
              label: 'Creer le compte admin',
              icon: Icons.admin_panel_settings_outlined,
              gradient: AppGradients.orange,
              onPressed: _isLoading ? null : _create,
              fullWidth: true,
              size: GradientButtonSize.large,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════
// CARTE UTILISATEUR GENERIQUE
// ═══════════════════════════════
class _UserCard extends StatelessWidget {
  final UserModel user;
  final List<_CardAction> actions;
  final bool showSelf;
  final bool isBanned;

  const _UserCard({
    required this.user,
    this.actions = const [],
    this.showSelf = false,
    this.isBanned = false,
  });

  Color get _roleColor {
    switch (user.role) {
      case UserRole.superuser:
        return AppColors.accent;
      case UserRole.admin:
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  LinearGradient get _roleGradient {
    switch (user.role) {
      case UserRole.superuser:
        return AppGradients.brand;
      case UserRole.admin:
        return AppGradients.orange;
      default:
        return AppGradients.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isBanned
              ? AppColors.badgeDangerBorder
              : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: _roleGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(user.initiale,
                      style: AppTextStyles.titleMedium
                          .copyWith(color: Colors.white)),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(user.nomComplet,
                              style: AppTextStyles.labelLarge,
                              overflow: TextOverflow.ellipsis),
                        ),
                        if (showSelf)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.badgeAccentBg,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text('Moi',
                                style: AppTextStyles.badge.copyWith(
                                    color: AppColors.accent,
                                    fontSize: 8)),
                          ),
                      ],
                    ),
                    Text('@${user.pseudo}',
                        style: AppTextStyles.bodySmall),
                    if (isBanned && user.dateBan != null)
                      Text(
                        'Banni le ${user.dateBan!.day}/${user.dateBan!.month}/${user.dateBan!.year}',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.danger),
                      ),
                  ],
                ),
              ),

              // Badge role
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _roleColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: _roleColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  isBanned ? 'Banni' : user.roleLabel,
                  style: AppTextStyles.badge.copyWith(
                    color: isBanned ? AppColors.danger : _roleColor,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),

          if (actions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: actions.map((a) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: a == actions.last ? 0 : 8),
                    child: GestureDetector(
                      onTap: a.onTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8),
                        decoration: BoxDecoration(
                          gradient: a.gradient,
                          color: a.gradient == null
                              ? a.bgColor
                              : null,
                          borderRadius: BorderRadius.circular(10),
                          border: a.gradient == null
                              ? Border.all(
                              color: a.color.withValues(alpha: 0.3))
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(a.icon, size: 13, color: a.color),
                            const SizedBox(width: 5),
                            Text(a.label,
                                style: TextStyle(
                                    color: a.color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _CardAction {
  final String label;
  final IconData icon;
  final Color color;
  final Color? bgColor;
  final LinearGradient? gradient;
  final VoidCallback onTap;

  const _CardAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.gradient,
    required this.onTap,
  });
}

Future<bool?> _showConfirm(
    BuildContext context, String title, String message) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF10182A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
      title: Text(title, style: AppTextStyles.headlineSmall),
      content: Text(message, style: AppTextStyles.bodySmall),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Annuler',
              style: TextStyle(color: AppColors.textMuted)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Confirmer',
              style: TextStyle(
                  color: AppColors.danger, fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );
}