import 'package:ai_eru_tawasol/core/shared/models/content_display_item.dart';
import 'package:ai_eru_tawasol/core/shared/views/content_details/content_details_view.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/add_announ_view.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/forget_password_view.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/login_view.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/otp_view.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/reset_password_view.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/course_details_view.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/home_view.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/on_boarding_view.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/change_password_cubit/change_password_mode.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/change_password_view.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/profile_view.dart';

import 'package:ai_eru_tawasol/features/splash/presentation/view/splash_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const kLoginView = '/loginView';
  static const kOnBoardingView = '/onBoardingView';
  static const kForgetPasswordView = '/forgetPasswordView';
  static const kHomeView = '/homeView';
  static const kProfileView = '/profileView';
  static const kChangePasswordView = '/changePasswordView';
  static const kThemeModeView = '/themeModeView';
  static const kLanguageView = '/languageView';
  static const kAboutMeView = '/aboutMeView';
  static const kOurMissionView = '/ourMissionView';
  static const kContactUsView = '/contactUsView';
  static const kAppVersionView = '/appVersionView';
  static const kOtpView = '/otpView';
  static const kResetPasswordView = '/resetPasswordView';
  static const kAddAnnouncementView = '/addAnnouncementView';
  static const kCourseDetailsView = '/courseDetailsView';
  static const kContentDetailsView = '/contentDetailsView';
  static const kFirstLoginChangePasswordView = '/firstLoginChangePasswordView';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => SplashView()),
      GoRoute(
        path: kOnBoardingView,
        builder: (context, state) => OnBoardingView(),
      ),
      GoRoute(
        path: kLoginView,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: kForgetPasswordView,
        builder: (context, state) => const ForgetPasswordView(),
      ),
      GoRoute(
        path: kOtpView,
        builder: (context, state) => OtpView(email: state.extra as String),
      ),
      GoRoute(
        path: kResetPasswordView,
        builder: (context, state) =>
            ResetPasswordView(email: state.extra as String),
      ),
      GoRoute(path: kHomeView, builder: (context, state) => HomeView()),
      GoRoute(path: kProfileView, builder: (context, state) => const ProfileView()),
      GoRoute(
        path: kChangePasswordView,
        builder: (context, state) => const ChangePasswordView(),
      ),
      GoRoute(
        path: kAddAnnouncementView,
        builder: (context, state) =>
            AddAnnounView(role: state.extra as AnnounRole),
      ),
      GoRoute(
        path: kCourseDetailsView,
        builder: (context, state) =>
            CourseDetailsView(args: state.extra as CourseDetailsArgs),
      ),
      GoRoute(
        path: kContentDetailsView,
        builder: (context, state) =>
            ContentDetailsView(item: state.extra as ContentDisplayItem),
      ),
      GoRoute(
        path: kFirstLoginChangePasswordView,
        builder: (context, state) => ChangePasswordView(
          mode: ChangePasswordMode.firstLogin,
          userId: state.extra as int?,
        ),
      ),
    ],
  );
}
