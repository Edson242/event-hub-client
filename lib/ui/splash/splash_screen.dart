import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'package:myapp/ui/_core/app_colors.dart';
import 'package:myapp/ui/onbording/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clickController;

  // 1. Variável de estado para controlar a animação de saída
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    _clickController = AnimationController(vsync: this);

    // O timer agora chama a função que dispara a animação de saída
    Timer(const Duration(seconds: 4), _triggerExitAnimation);
  }

  @override
  void dispose() {
    _clickController.dispose();
    super.dispose();
  }

  // 2. Nova função que apenas dispara a animação
  void _triggerExitAnimation() {
    if (!mounted) return;
    // Evita que a animação seja disparada múltiplas vezes
    if (_isExiting) return;

    setState(() {
      _isExiting = true;
    });
  }

  // 3. A navegação agora acontece APENAS no onComplete da animação de saída
  void _navigateToOnboarding() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        // Usamos PageRouteBuilder para uma transição sem fade padrão
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        // Ao tocar na tela, dispara a animação de saída
        onTap: _triggerExitAnimation,
        child: Center(
          child: GestureDetector(
            onTap: () {
              // Dispara a animação de "chacoalhar" ao clicar no logo
              _clickController.forward(from: 0.0);
            },
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/banners/banner_logo.png', height: 60),
                    const SizedBox(height: 8),
                    Text(
                      'Single Thread',
                      style: TextStyle(color: AppColors.lightBackgroundColor),
                    ),
                  ],
                )
                // Animação de clique (controlada)
                .animate(controller: _clickController)
                .shake(hz: 4, duration: 500.ms)
                // Animação de entrada (automática)
                .animate(onPlay: (controller) => controller.forward())
                .fade(duration: 800.ms)
                .slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 800.ms,
                  curve: Curves.easeOut,
                )
                // 4. Animação de SAÍDA (controlada pelo estado _isExiting)
                .animate(
                  target: _isExiting ? 1.0 : 0.0,
                  onComplete: (controller) {
                    // A mágica acontece aqui! Navega só quando a animação termina.
                    if (_isExiting) {
                      _navigateToOnboarding();
                    }
                  },
                )
                .fade(end: 0, duration: 600.ms) // Desaparece
                .scale(
                  end: const Offset(0.8, 0.8),
                  duration: 600.ms,
                ), // E diminui
          ),
        ),
      ),
    );
  }
}
