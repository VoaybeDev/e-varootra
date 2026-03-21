import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/services/auth_service.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_text.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _currentPage = 0;

  final _slides = const [
    _OnboardSlide(
      gradient: AppGradients.brand,
      title: 'Créez vos\nfactures',
      subtitle:
      'Enregistrez chaque vente a credit avec ses produits, quantites et prix en quelques secondes.',
      illustration: _InvoiceIllustration(),
    ),
    _OnboardSlide(
      gradient: AppGradients.orange,
      title: 'Suivez\nles dettes',
      subtitle:
      'Visualisez en un coup d\'oeil qui doit quoi. Enregistrez les paiements partiels ou complets.',
      illustration: _DebtIllustration(),
    ),
    _OnboardSlide(
      gradient: AppGradients.greenLight,
      title: 'Analysez\nvos donnees',
      subtitle:
      'Tableaux de bord, top clients, top produits et evolution mensuelle pour piloter votre activite.',
      illustration: _ChartIllustration(),
    ),
  ];

  Future<void> _finish() async {
    final authService = ref.read(authServiceProvider);
    await authService.markOnboardingDone();
    if (mounted) context.go(AppRoutes.auth);
  }

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _prev() {
    if (_currentPage > 0) {
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Lueur de fond
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.0,
                  colors: [
                    AppColors.accent.withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Bouton passer
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: GestureDetector(
              onTap: _finish,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bgCardHover,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  'Passer',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // Pages
          PageView.builder(
            controller: _pageCtrl,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) => _slides[i],
          ),

          // Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _OnboardFooter(
              currentPage: _currentPage,
              totalPages: _slides.length,
              onPrev: _currentPage > 0 ? _prev : null,
              onNext: _next,
              isLast: _currentPage == _slides.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardSlide extends StatelessWidget {
  final LinearGradient gradient;
  final String title;
  final String subtitle;
  final Widget illustration;

  const _OnboardSlide({
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        32,
        MediaQuery.of(context).padding.top + 60,
        32,
        200,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          SizedBox(
            width: 240,
            height: 240,
            child: illustration,
          ),

          const SizedBox(height: 36),

          // Titre
          GradientText(
            title,
            gradient: gradient,
            style: AppTextStyles.displayMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 14),

          // Sous-titre
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 15,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OnboardFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrev;
  final VoidCallback onNext;
  final bool isLast;

  const _OnboardFooter({
    required this.currentPage,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        28,
        20,
        28,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        children: [
          // Indicateurs
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (i) {
              final isActive = i == currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.accent
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          // Boutons
          Row(
            children: [
              // Bouton retour
              if (onPrev != null)
                GestureDetector(
                  onTap: onPrev,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.bgCardHover,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textMuted,
                      size: 18,
                    ),
                  ),
                ),

              if (onPrev != null) const SizedBox(width: 12),

              // Bouton suivant
              Expanded(
                child: GestureDetector(
                  onTap: onNext,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppGradients.brand,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.3),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLast ? 'Commencer' : 'Suivant',
                          style: AppTextStyles.button.copyWith(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isLast ? Icons.rocket_launch : Icons.arrow_forward,
                          color: Colors.white,
                          size: 16,
                        ),
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

// --- ILLUSTRATIONS ---

class _InvoiceIllustration extends StatelessWidget {
  const _InvoiceIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Carte principale
        Positioned(
          top: 20,
          left: 40,
          child: Container(
            width: 160,
            height: 200,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: AppGradients.brand,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                _Line(width: double.infinity, opacity: 0.2),
                const SizedBox(height: 8),
                _Line(width: 100, opacity: 0.15),
                const SizedBox(height: 8),
                _Line(width: 120, opacity: 0.1),
                const SizedBox(height: 10),
                Container(height: 1, color: Colors.white.withOpacity(0.1)),
                const SizedBox(height: 10),
                _Line(width: double.infinity, opacity: 0.2),
                const SizedBox(height: 8),
                _Line(width: 80, opacity: 0.15),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 14,
                    width: 80,
                    decoration: BoxDecoration(
                      gradient: AppGradients.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Badge check
        Positioned(
          right: 8,
          bottom: 28,
          child: _PulsingBadge(
            gradient: AppGradients.greenLight,
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
        ),

        // Badge flottant
        Positioned(
          top: 10,
          right: 14,
          child: _FloatingBadge(
            gradient: AppGradients.violet,
            child: const Icon(Icons.inventory_2, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }
}

class _DebtIllustration extends StatelessWidget {
  const _DebtIllustration();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ClientRow(
          initial: 'M',
          gradient: AppGradients.brand,
          barFill: 0.65,
          barGradient: AppGradients.rose,
          amount: '45k Ar',
          amountColor: AppColors.danger,
        ),
        const SizedBox(height: 10),
        _ClientRow(
          initial: 'J',
          gradient: AppGradients.orange,
          barFill: 0.30,
          barGradient: AppGradients.orange,
          amount: '22k Ar',
          amountColor: AppColors.warning,
        ),
        const SizedBox(height: 10),
        _ClientRow(
          initial: 'R',
          gradient: AppGradients.green,
          barFill: 1.0,
          barGradient: AppGradients.green,
          amount: 'Paye',
          amountColor: AppColors.success,
        ),
      ],
    );
  }
}

class _ClientRow extends StatelessWidget {
  final String initial;
  final LinearGradient gradient;
  final double barFill;
  final LinearGradient barGradient;
  final String amount;
  final Color amountColor;

  const _ClientRow({
    required this.initial,
    required this.gradient,
    required this.barFill,
    required this.barGradient,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 9,
                  width: double.infinity * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    height: 6,
                    color: Colors.white.withOpacity(0.08),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: barFill,
                      child: Container(
                        decoration: BoxDecoration(gradient: barGradient),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartIllustration extends StatelessWidget {
  const _ChartIllustration();

  final _heights = const [0.55, 0.80, 0.60, 0.95, 0.70];
  final _gradients = const [
    AppGradients.blue,
    AppGradients.violet,
    AppGradients.orange,
    AppGradients.brand,
    AppGradients.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Carte stat
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bgCardHover,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  '76%',
                  gradient: AppGradients.green,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Recouvrement',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Barres
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(5, (i) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  height: 160 * _heights[i],
                  decoration: BoxDecoration(
                    gradient: _gradients[i],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// --- COMPOSANTS UTILITAIRES ---

class _Line extends StatelessWidget {
  final double width;
  final double opacity;

  const _Line({required this.width, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _PulsingBadge extends StatefulWidget {
  final LinearGradient gradient;
  final Widget child;

  const _PulsingBadge({required this.gradient, required this.child});

  @override
  State<_PulsingBadge> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<_PulsingBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: widget.gradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}

class _FloatingBadge extends StatefulWidget {
  final LinearGradient gradient;
  final Widget child;

  const _FloatingBadge({required this.gradient, required this.child});

  @override
  State<_FloatingBadge> createState() => _FloatingBadgeState();
}

class _FloatingBadgeState extends State<_FloatingBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _y;
  late final Animation<double> _rot;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    _y = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _rot = Tween<double>(begin: -0.087, end: 0.087).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _y.value),
        child: Transform.rotate(
          angle: _rot.value,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: widget.gradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withOpacity(0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}