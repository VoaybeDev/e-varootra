import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/validators.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_text.dart';
import '../auth/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  final _loginPseudoCtrl = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  final _regNomCtrl = TextEditingController();
  final _regPseudoCtrl = TextEditingController();
  final _regPasswordCtrl = TextEditingController();
  final _regFormKey = GlobalKey<FormState>();

  bool _loginPasswordVisible = false;
  bool _regPasswordVisible = false;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() {
      setState(() => _successMessage = null);
      ref.read(authProvider.notifier).clearError();
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _loginPseudoCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _regNomCtrl.dispose();
    _regPseudoCtrl.dispose();
    _regPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_loginFormKey.currentState!.validate()) return;
    final ok = await ref.read(authProvider.notifier).login(
      _loginPseudoCtrl.text.trim(),
      _loginPasswordCtrl.text,
    );
    if (ok && mounted) context.go(AppRoutes.home);
  }

  Future<void> _register() async {
    if (!_regFormKey.currentState!.validate()) return;
    final ok = await ref.read(authProvider.notifier).register(
      nomComplet: _regNomCtrl.text.trim(),
      pseudo: _regPseudoCtrl.text.trim(),
      password: _regPasswordCtrl.text,
    );
    if (ok && mounted) {
      setState(() {
        _successMessage =
        'Compte cree ! En attente d\'approbation par un administrateur.';
      });
      _tabCtrl.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          Container(
              decoration:
              const BoxDecoration(gradient: AppGradients.authBg)),
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Logo
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppGradients.brand,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.35),
                          blurRadius: 36,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'E',
                        style: AppTextStyles.headlineLarge
                            .copyWith(color: Colors.white, fontSize: 26),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  GradientText(
                    'E-VAROOTRA',
                    gradient: AppGradients.brand,
                    style: AppTextStyles.displayLarge
                        .copyWith(fontSize: 26),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Gestion des ventes & dettes',
                    style: AppTextStyles.bodySmall,
                  ),

                  const SizedBox(height: 32),

                  // Message en attente d'approbation
                  if (authState.isPending)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.badgeWarningBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.badgeWarningBorder),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.hourglass_empty_outlined,
                              color: AppColors.warning, size: 32),
                          const SizedBox(height: 10),
                          Text(
                            'Compte en attente',
                            style: AppTextStyles.headlineSmall.copyWith(
                                color: AppColors.warning),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Votre compte a ete cree avec succes. Un administrateur doit approuver votre acces avant que vous puissiez vous connecter.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.warning,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                  // Carte auth
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 60,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Message succes inscription
                        if (_successMessage != null)
                          Container(
                            margin: const EdgeInsets.fromLTRB(
                                20, 20, 20, 0),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.badgeWarningBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.badgeWarningBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                    Icons.hourglass_empty_outlined,
                                    color: AppColors.warning,
                                    size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _successMessage!,
                                    style: AppTextStyles.bodySmall
                                        .copyWith(
                                        color: AppColors.warning),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Message erreur
                        if (authState.error != null && !authState.isPending)
                          Container(
                            margin: const EdgeInsets.fromLTRB(
                                20, 20, 20, 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 11),
                            decoration: BoxDecoration(
                              color: AppColors.badgeDangerBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.badgeDangerBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.cancel_outlined,
                                    color: AppColors.danger, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    authState.error!,
                                    style: AppTextStyles.bodySmall
                                        .copyWith(
                                        color: AppColors.danger),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Onglets
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              20, 20, 20, 0),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.bgCardHover,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TabBar(
                              controller: _tabCtrl,
                              indicator: BoxDecoration(
                                gradient: AppGradients.brand,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              labelStyle: AppTextStyles.labelLarge,
                              unselectedLabelStyle:
                              AppTextStyles.labelMedium,
                              labelColor: Colors.white,
                              unselectedLabelColor: AppColors.textMuted,
                              tabs: const [
                                Tab(text: 'Connexion'),
                                Tab(text: 'Inscription'),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 340,
                          child: TabBarView(
                            controller: _tabCtrl,
                            children: [
                              _LoginForm(
                                formKey: _loginFormKey,
                                pseudoCtrl: _loginPseudoCtrl,
                                passwordCtrl: _loginPasswordCtrl,
                                passwordVisible: _loginPasswordVisible,
                                onTogglePassword: () => setState(() =>
                                _loginPasswordVisible =
                                !_loginPasswordVisible),
                                onSubmit: _login,
                                isLoading: authState.isLoading,
                              ),
                              _RegisterForm(
                                formKey: _regFormKey,
                                nomCtrl: _regNomCtrl,
                                pseudoCtrl: _regPseudoCtrl,
                                passwordCtrl: _regPasswordCtrl,
                                passwordVisible: _regPasswordVisible,
                                onTogglePassword: () => setState(() =>
                                _regPasswordVisible =
                                !_regPasswordVisible),
                                onSubmit: _register,
                                isLoading: authState.isLoading,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Note inscription
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            size: 14, color: AppColors.textFaint),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Les nouveaux comptes necesitent l\'approbation d\'un administrateur avant d\'etre actives.',
                            style: AppTextStyles.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController pseudoCtrl;
  final TextEditingController passwordCtrl;
  final bool passwordVisible;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;
  final bool isLoading;

  const _LoginForm({
    required this.formKey,
    required this.pseudoCtrl,
    required this.passwordCtrl,
    required this.passwordVisible,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _AuthField(
              label: 'Pseudo',
              icon: Icons.person_outline,
              controller: pseudoCtrl,
              validator: AppValidators.pseudo,
              placeholder: 'Votre pseudo',
            ),
            const SizedBox(height: 14),
            _AuthField(
              label: 'Mot de passe',
              icon: Icons.lock_outline,
              controller: passwordCtrl,
              validator: AppValidators.password,
              placeholder: '- - - - - - - -',
              obscureText: !passwordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  passwordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textFaint,
                  size: 18,
                ),
                onPressed: onTogglePassword,
              ),
            ),
            const SizedBox(height: 14),
            GradientButton(
              label: 'Se connecter',
              icon: Icons.login,
              onPressed: isLoading ? null : onSubmit,
              fullWidth: true,
              size: GradientButtonSize.large,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nomCtrl;
  final TextEditingController pseudoCtrl;
  final TextEditingController passwordCtrl;
  final bool passwordVisible;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;
  final bool isLoading;

  const _RegisterForm({
    required this.formKey,
    required this.nomCtrl,
    required this.pseudoCtrl,
    required this.passwordCtrl,
    required this.passwordVisible,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _AuthField(
              label: 'Nom complet',
              icon: Icons.badge_outlined,
              controller: nomCtrl,
              validator: AppValidators.requiredName,
              placeholder: 'Votre nom',
            ),
            const SizedBox(height: 10),
            _AuthField(
              label: 'Pseudo',
              icon: Icons.person_outline,
              controller: pseudoCtrl,
              validator: AppValidators.pseudo,
              placeholder: 'Choisissez un pseudo',
            ),
            const SizedBox(height: 10),
            _AuthField(
              label: 'Mot de passe',
              icon: Icons.lock_outline,
              controller: passwordCtrl,
              validator: AppValidators.password,
              placeholder: 'Min. 4 caracteres',
              obscureText: !passwordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  passwordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textFaint,
                  size: 18,
                ),
                onPressed: onTogglePassword,
              ),
            ),
            const SizedBox(height: 14),
            GradientButton(
              label: 'Creer mon compte',
              icon: Icons.person_add_outlined,
              onPressed: isLoading ? null : onSubmit,
              fullWidth: true,
              size: GradientButtonSize.large,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String placeholder;
  final bool obscureText;
  final Widget? suffixIcon;

  const _AuthField({
    required this.label,
    required this.icon,
    required this.controller,
    this.validator,
    required this.placeholder,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.inputLabel,
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: AppTextStyles.input,
          decoration: InputDecoration(
            hintText: placeholder,
            prefixIcon: Icon(icon, size: 16, color: AppColors.textFaint),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}