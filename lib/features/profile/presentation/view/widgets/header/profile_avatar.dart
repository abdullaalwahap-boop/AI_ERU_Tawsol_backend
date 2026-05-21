import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/header/profile_initials_view.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double size;

  const ProfileAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.size = 88,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 8,
      height: size + 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.accentLight, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.5),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceLight,
          ),
          child: ClipOval(
            child: avatarUrl != null
                ? Image.network(
                    avatarUrl!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        ProfileInitialsView(name: name, size: size),
                  )
                : ProfileInitialsView(name: name, size: size),
          ),
        ),
      ),
    );
  }
}
