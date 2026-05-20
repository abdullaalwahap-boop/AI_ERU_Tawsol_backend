import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/additional_pages_app_bar.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/custom_container_section.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsViewBody extends StatelessWidget {
  const ContactUsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AdditionalPagesAppBar(title: 'Contact Us'),
        AppSpacing.h32,
        Text(
          "We'd love to hear from you",
          style: AppTextStyles.heading4.copyWith(fontWeight: FontWeight.w600),
        ),
        AppSpacing.h32,
        const CustomContainerSection(
          children: [
            CustomListTile(
              icon: FaIcon(
                FontAwesomeIcons.solidEnvelope,
                color: AppColors.primary,
                size: 32,
              ),
              title: 'Email',
              subtitle: 'support@aiconnect.com',
            ),
            AppSpacing.h10,
            CustomListTile(
              icon: FaIcon(
                FontAwesomeIcons.phone,
                color: AppColors.primary,
                size: 32,
              ),
              title: 'Phone',
              subtitle: '+20 101111002',
            ),
            AppSpacing.h10,
            CustomListTile(
              icon: FaIcon(
                FontAwesomeIcons.locationDot,
                color: AppColors.primary,
                size: 32,
              ),
              title: 'Address',
              subtitle: '123 Smart City, Cairo,Egypt',
            ),
            AppSpacing.h10,
            CustomListTile(
              icon: FaIcon(
                FontAwesomeIcons.clock,
                color: AppColors.primary,
                size: 32,
              ),
              title: 'Working Hours',
              subtitle: 'Sat - Thu: 9:00 AM - 6:00 PM',
            ),
          ],
        ),
        AppSpacing.h40,
        Placeholder(fallbackHeight: 210),
      ],
    );
  }
}
