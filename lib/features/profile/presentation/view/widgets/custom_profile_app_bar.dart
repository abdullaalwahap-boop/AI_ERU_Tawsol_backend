import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomProfileAppBar extends StatelessWidget {
  const CustomProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Text('Profile', style: AppTextStyles.display),
          // Spacer(),
          // IconButton(
          //   onPressed: () {},
          //   icon: const FaIcon(FontAwesomeIcons.bell, size: 32),
          // ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.language_rounded, size: 36),
          // ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const FaIcon(FontAwesomeIcons.solidSun, size: 32),
          // ),
        ],
      ),
    );
  }
}
