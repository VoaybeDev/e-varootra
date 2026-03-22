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

    return DefaultTabController(
      length: currentUser.estSuperuser ? 3 : 2,
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
                      child: GradientText(
                        'Gestion utilisateurs',
                        gradient: AppGradients.brand,
                        style: AppTextStyles.headlineLarge,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

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
                      const Tab(text: 'En attente'),
                      const Tab(text: 'Actifs'),
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
                    // En attente
                    _PendingUsersTab(),

                    // Utilisateurs actifs
                    _ActiveUsersTab(),

                    // Creer admin (superuser seulement)
                    if (currentUser.estSuperuser)
                      _CreateAdminTab(),
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

class _PendingUsersTab extends ConsumerWidget {
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
          itemBuilder: (_, i) => _PendingUserCard(
            user: users[i],
            onApprove: () async {
              await ref.read(authProvider.notifier).approveUser(users[i].id);
              ref.invalidate(pendingUsersProvider);
              ref.invalidate(approvedUsersProvider);
              if (context.mounted) {
                AppToast.show(context, '${users[i].nomComplet} approuve');
              }
            },
            onReject: () async {
              await ref.read(authProvider.notifier).rejectUser(users[i].id);
              ref.invalidate(pendingUsersProvider);
              if (context.mounted) {
                AppToast.show(context, '${users[i].nomComplet} rejete',
                    type: ToastType.error);
              }
            },
          ),
        );
      },
    );
  }
}

class _PendingUserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _PendingUserCard({
    required this.user,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.badgeWarningBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: AppGradients.orange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    user.initiale,
                    style: AppTextStyles.titleMedium
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.nomComplet,
                        style: AppTextStyles.labelLarge),
                    Text('@${user.pseudo}',
                        style: AppTextStyles.bodySmall),
                    Text(
                      'Inscrit le ${user.dateCreation.day}/${user.dateCreation.month}/${user.dateCreation.year}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.badgeWarningBg,
                  borderRadius: BorderRadius.circular(100),
                  border:
                  Border.all(color: AppColors.badgeWarningBorder),
                ),
                child: Text(
                  'En attente',
                  style: AppTextStyles.badge
                      .copyWith(color: AppColors.warning),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onReject,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.badgeDangerBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.badgeDangerBorder),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close,
                            size: 14, color: AppColors.danger),
                        SizedBox(width: 6),
                        Text('Rejeter',
                            style: TextStyle(
                                color: AppColors.danger,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: onApprove,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: AppGradients.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check,
                            size: 14, color: Colors.white),
                        SizedBox(width: 6),
                        Text('Approuver',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveUsersTab extends ConsumerWidget {
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
          Color roleColor;
          LinearGradient roleGrad;

          switch (u.role) {
            case UserRole.superuser:
              roleColor = AppColors.accent;
              roleGrad = AppGradients.brand;
              break;
            case UserRole.admin:
              roleColor = AppColors.warning;
              roleGrad = AppGradients.orange;
              break;
            default:
              roleColor = AppColors.success;
              roleGrad = AppGradients.green;
          }

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
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: roleGrad,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      u.initiale,
                      style: AppTextStyles.titleMedium
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(u.nomComplet,
                              style: AppTextStyles.labelLarge),
                          if (u.id == currentUser?.id) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.badgeAccentBg,
                                borderRadius:
                                BorderRadius.circular(100),
                              ),
                              child: Text(
                                'Moi',
                                style: AppTextStyles.badge.copyWith(
                                    color: AppColors.accent,
                                    fontSize: 8),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text('@${u.pseudo}',
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: roleColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: roleColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    u.roleLabel,
                    style: AppTextStyles.badge
                        .copyWith(color: roleColor),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CreateAdminTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreateAdminTab> createState() =>
      _CreateAdminTabState();
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
            // Info
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
                      'Seul le superutilisateur peut creer un compte administrateur. Les admins peuvent gerer les utilisateurs et faire le suivi.',
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
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Requis'
                  : null,
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
              validator: (v) => v == null || v.trim().length < 3
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