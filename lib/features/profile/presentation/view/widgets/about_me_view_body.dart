import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/core/utils/assets.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/additional_pages_app_bar.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/custom_about_me_header.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/custom_container_section.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AboutMeViewBody extends StatelessWidget {
  const AboutMeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AdditionalPagesAppBar(title: 'About Me'),
        const SizedBox(height: 30),
        CustomAboutMeHeader(
          image: Image.asset(AssetsData.logo, height: 130),
          title: 'About Me',
          paragraph:
              'We aim to provide the best experience and intelligent solutions that make your life easire.',
        ),
        const SizedBox(height: 30),
        CustomContainerSection(
          children: [
            CustomListTile(
              icon: Icon(
                Icons.safety_check_outlined,
                size: 36,
                color: AppColors.primary,
              ),
              title: 'Our Mission',
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xff9E9D97),
              ),
              onTap: () {
                GoRouter.of(context).push(AppRouter.kOurMissionView);
              },
            ),
            Divider(endIndent: 43, indent: 68.5, thickness: 0.5),
            CustomListTile(
              icon: Icon(
                Icons.contact_support_sharp,
                size: 36,
                color: AppColors.primary,
              ),
              title: 'Contact Us',
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xff9E9D97),
              ),
              onTap: () {
                GoRouter.of(context).push(AppRouter.kContactUsView);
              },
            ),
            Divider(endIndent: 43, indent: 68.5, thickness: 0.5),
            CustomListTile(
              icon: Icon(
                Icons.approval_outlined,
                size: 36,
                color: AppColors.primary,
              ),
              title: 'App Version',
              trailing: Text(
                '1.0.0+1',
                style: AppTextStyles.bodyLarge.copyWith(color: Color(0xff9E9D97)),
              ),
              onTap: () {
                GoRouter.of(context).push(AppRouter.kAppVersionView);
              },
            ),
            Divider(endIndent: 43, indent: 68.5, thickness: 0.5),
            CustomListTile(
              icon: Icon(
                Icons.reply_all_outlined,
                size: 36,
                color: AppColors.primary,
              ),
              title: 'Follow Us',
              trailing: Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AssetsData.facebook),
                  SvgPicture.asset(AssetsData.instagram, height: 32),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
