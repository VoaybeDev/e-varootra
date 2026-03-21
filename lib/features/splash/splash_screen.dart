import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/constants.dart';
import '../../core/services/auth_service.dart';
import '../../core/widgets/gradient_text.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _tagCtrl;
  late final AnimationController _dotsCtrl;
  late final AnimationController _orb1Ctrl;
  late final AnimationController _orb2Ctrl;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _tagOpacity;
  late final Animation<double> _dotsOpacity;
  late final Animation<double> _orb1Y;
  late final Animation<double> _orb2Y;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _tagCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _dotsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _orb1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat(reverse: true);
    _orb2Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut),
    );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _tagOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _tagCtrl, curve: Curves.easeOut),
    );
    _dotsOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _dotsCtrl, curve: Curves.easeOut),
    );
    _orb1Y = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _orb1Ctrl, curve: Curves.easeInOut),
    );
    _orb2Y = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _orb2Ctrl, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _tagCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _dotsCtrl.forward();

    // Attendre fin splash puis naviguer
    await Future.delayed(const Duration(milliseconds: 1600));
    if (mounted) _navigateNext();
  }

  Future<void> _navigateNext() async {
    final authService = ref.read(authServiceProvider);
    final onboardingDone = await authService.isOnboardingDone();
    final userId = await authService.getSavedUserId();

    if (!mounted) return;

    if (!onboardingDone) {
      context.go(AppRoutes.onboarding);
    } else if (userId != null) {
      // Session existante - restaurer
      final user = await authService.getUserById(userId);
      if (user != null && mounted) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.auth);
      }
    } else {
      context.go(AppRoutes.auth);
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _tagCtrl.dispose();
    _dotsCtrl.dispose();
    _orb1Ctrl.dispose();
    _orb2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Fond gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.splashBg,
            ),
          ),

          // Orbe 1 - haut droite
          AnimatedBuilder(
            animation: _orb1Y,
            builder: (_, __) => Positioned(
              top: -60 + _orb1Y.value,
              right: -40,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withOpacity(0.08),
                ),
                child: BackdropFilter(
                  filter: _blurFilter(60),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),

          // Orbe 2 - bas gauche
          AnimatedBuilder(
            animation: _orb2Y,
            builder: (_, __) => Positioned(
              bottom: -30 + _orb2Y.value,
              left: -30,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.purple.withOpacity(0.10),
                ),
                child: BackdropFilter(
                  filter: _blurFilter(60),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),

          // Contenu central
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo E
                AnimatedBuilder(
                  animation: _logoCtrl,
                  builder: (_, __) => Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          gradient: AppGradients.brand,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.4),
                              blurRadius: 60,
                              offset: const Offset(0, 20),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              blurRadius: 0,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'E',
                            style: AppTextStyles.displayLarge.copyWith(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Brand name
                AnimatedBuilder(
                  animation: _textCtrl,
                  builder: (_, __) => Opacity(
                    opacity: _textOpacity.value,
                    child: SlideTransition(
                      position: _textSlide,
                      child: GradientText(
                        AppConstants.appName,
                        gradient: AppGradients.brand,
                        style: AppTextStyles.displayLarge,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                AnimatedBuilder(
                  animation: _tagCtrl,
                  builder: (_, __) => Opacity(
                    opacity: _tagOpacity.value,
                    child: Text(
                      AppConstants.appTagline,
                      style: AppTextStyles.bodySmall.copyWith(
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Dots animes
                AnimatedBuilder(
                  animation: _dotsCtrl,
                  builder: (_, __) => Opacity(
                    opacity: _dotsOpacity.value,
                    child: const _AnimatedDots(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageFilter _blurFilter(double sigma) {
    return ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);
  }
}

class _AnimatedDots extends StatefulWidget {
  const _AnimatedDots();

  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with TickerProviderStateMixin {
  late final List<AnimationController> _ctrls;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(
      3,
          (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400),
      )..repeat(reverse: true),
    );

    _anims = _ctrls.map((c) => Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: c, curve: Curves.easeInOut),
    )).toList();

    // Delais decales
    for (int i = 0; i < _ctrls.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _ctrls[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _anims[i],
          builder: (_, __) {
            final v = _anims[i].value;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(
                  Colors.white.withOpacity(0.2),
                  AppColors.accent,
                  v,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// Import manquant
import 'dart:ui' show ImageFilter;