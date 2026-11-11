import 'package:ai_eru_tawasol/features/onboarding/data/model/on_boarding_model.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/illustrations/on_boarding_illus_1.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/illustrations/on_boarding_illus_2.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/illustrations/on_boarding_illus_3.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/illustrations/on_boarding_illus_4.dart';
import 'package:ai_eru_tawasol/features/onboarding/presentation/view/widgets/illustrations/on_boarding_illus_5.dart';

final List<OnBoardingModel> onBoardingList = [
  const OnBoardingModel(
    illustration: OnBoardingIllus1(),
    title: 'Smart School\nPlatform',
    subtitle:
        'Experience modern tech education reimagined\nwith AI-powered tools built for WE School Suez.',
  ),
  const OnBoardingModel(
    illustration: OnBoardingIllus2(),
    title: 'Instant Academic\nAnnouncements',
    subtitle:
        'Stay informed with real-time updates\nfrom your professors and departments.',
  ),
  const OnBoardingModel(
    illustration: OnBoardingIllus3(),
    title: 'Courses &\nMaterials',
    subtitle:
        'Access lectures, assignments and\ncourse content — all in one place.',
  ),
  const OnBoardingModel(
    illustration: OnBoardingIllus4(),
    title: 'Direct Faculty\nCommunication',
    subtitle:
        'Chat directly with professors and TAs.\nGet answers when you need them.',
  ),
  const OnBoardingModel(
    illustration: OnBoardingIllus5(),
    title: 'Your Platform\nAwaits',
    subtitle:
        'Sign in with your school credentials\nand begin your smart learning journey.',
  ),
];
