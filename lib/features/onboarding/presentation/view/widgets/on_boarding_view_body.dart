import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/services/local_storage_services.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/onboarding/data/model/on_boarding_data.dart';
import 'package:ai_eru_tawasol/features/onboarding/data/model/on_boarding_model.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/illustrations/on_boarding_illus_1.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/illustrations/on_boarding_illus_2.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/illustrations/on_boarding_illus_3.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/illustrations/on_boarding_illus_4.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/illustrations/on_boarding_illus_5.dart';
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

  List<OnBoardingModel> _buildList(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      OnBoardingModel(illustration: const OnBoardingIllus1(), title: l10n.onboarding1Title, subtitle: l10n.onboarding1Subtitle),
      OnBoardingModel(illustration: const OnBoardingIllus2(), title: l10n.onboarding2Title, subtitle: l10n.onboarding2Subtitle),
      OnBoardingModel(illustration: const OnBoardingIllus3(), title: l10n.onboarding3Title, subtitle: l10n.onboarding3Subtitle),
      OnBoardingModel(illustration: const OnBoardingIllus4(), title: l10n.onboarding4Title, subtitle: l10n.onboarding4Subtitle),
      OnBoardingModel(illustration: const OnBoardingIllus5(), title: l10n.onboarding5Title, subtitle: l10n.onboarding5Subtitle),
    ];
  }

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
                    ), // count is always 5 — locale-independent
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
                    model: _buildList(context)[i],
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
