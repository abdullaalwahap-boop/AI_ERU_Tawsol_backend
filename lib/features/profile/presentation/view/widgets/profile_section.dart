import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          backgroundColor: Color(0xffE4E5E5),
          radius: 70,
          backgroundImage: NetworkImage(
            'https://i.ytimg.com/vi/lRdXqvpuVMk/hq720.jpg',
          ),
        ),
        AppSpacing.h10,
        Text('Ziad Tamer', style: AppTextStyles.heading2),
        AppSpacing.h5,
        Text(
          '225040@eru.edu.eg',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.h5,
        Text(
          'Student ID: 225040',
          style: AppTextStyles.heading4.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
