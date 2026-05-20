import 'package:ai_eru_tawasol/core/services/local_storage_services.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/splash/presentation/view/widgets/splash_app_name.dart';
import 'package:ai_eru_tawasol/features/splash/presentation/view/widgets/splash_background.dart';
import 'package:ai_eru_tawasol/features/splash/presentation/view/widgets/splash_loader.dart';
import 'package:ai_eru_tawasol/features/splash/presentation/view/widgets/splash_logo_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bgOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _nameSlide;
  late Animation<double> _nameOpacity;
  late Animation<double> _loaderOpacity;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _controller.forward();
    _navigate();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _bgOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.55, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.45, curve: Curves.easeOut),
      ),
    );

    _nameSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    _nameOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.68, curve: Curves.easeOut),
      ),
    );

    _loaderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.72, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  void _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2600));

    final storage = LocalStorageService();
    final isLoggedIn = await storage.getIsLoggedIn();
    final hasSeenOnboarding = await storage.getHasSeenOnboarding();

    if (!mounted) return;

    if (isLoggedIn) {
      context.go(AppRouter.kHomeView);
    } else if (hasSeenOnboarding) {
      context.go(AppRouter.kLoginView);
    } else {
      context.go(AppRouter.kOnBoardingView);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          fit: StackFit.expand,
          children: [
            FadeTransition(
              opacity: _bgOpacity,
              child: const SplashBackground(),
            ),
            Column(
              children: [
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: _logoOpacity,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: const SplashLogoIcon(),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _nameOpacity,
                  child: SlideTransition(
                    position: _nameSlide,
                    child: const SplashAppName(),
                  ),
                ),
                const Spacer(flex: 3),
                FadeTransition(
                  opacity: _loaderOpacity,
                  child: const SplashLoader(),
                ),
                const SizedBox(height: 56),
              ],
            ),
          ],
        );
      },
    );
  }
}
