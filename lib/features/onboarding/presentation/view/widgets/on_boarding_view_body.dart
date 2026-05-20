import 'package:ai_eru_tawasol/core/services/local_storage_services.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/onboarding/data/model/on_boarding_data.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/on_boarding_background.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/on_boarding_button.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/on_boarding_item.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/on_boarding_page_indicator.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/skip_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == onBoardingList.length - 1;

  void _goToLogin() async {
    await LocalStorageService().saveHasSeenOnboarding(true);
    if (!mounted) return;
    context.go(AppRouter.kLoginView);
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 480),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const OnBoardingBackground(),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 60),
                    OnBoardingPageIndicator(
                      count: onBoardingList.length,
                      current: _currentPage,
                    ),
                    SkipButton(
                      isLastPage: _isLastPage,
                      onSkip: _goToLogin,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: onBoardingList.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (ctx, i) => OnBoardingItem(
                    key: ValueKey(i),
                    model: onBoardingList[i],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              OnBoardingButton(
                isLastPage: _isLastPage,
                onPressed: _isLastPage ? _goToLogin : _nextPage,
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom + 36,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
