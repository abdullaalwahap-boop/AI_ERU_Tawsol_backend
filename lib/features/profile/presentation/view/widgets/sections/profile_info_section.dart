import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_section_card.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/info/info_edit_name_dialog.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/info/info_password_tile.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/info/info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileInfoSection extends StatefulWidget {
  final ProfileUser user;

  const ProfileInfoSection({super.key, required this.user});

  @override
  State<ProfileInfoSection> createState() => _ProfileInfoSectionState();
}

class _ProfileInfoSectionState extends State<ProfileInfoSection> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'Account',
      titleIcon: Icons.person_rounded,
      children: [
        ProfileInfoTile(
          label: 'Full Name',
          value: widget.user.name,
          icon: Icons.badge_outlined,
          iconColor: AppColors.accent,
          iconBg: AppColors.accentLight.withValues(alpha: 0.13),
          onTap: () => _showEditDialog(context),
        ),
        _divider(),
        ProfileInfoTile(
          label: 'Email Address',
          value: widget.user.email,
          icon: Icons.alternate_email_rounded,
          iconColor: AppColors.contentGreen,
          iconBg: AppColors.contentGreenLight,
        ),
        _divider(),
        ProfileInfoTile(
          label: 'University ID',
          value: widget.user.id,
          icon: Icons.numbers_rounded,
          iconColor: AppColors.contentAmber,
          iconBg: AppColors.contentAmberLight,
        ),
        _divider(),
        ProfilePasswordTile(
          showPassword: _showPassword,
          onToggle: () => setState(() => _showPassword = !_showPassword),
          onChangePassword: () => context.push(AppRouter.kChangePasswordView),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    final ctrl = TextEditingController(text: widget.user.name);
    final cubit = context.read<ProfileCubit>();
    showDialog(
      context: context,
      builder: (_) => ProfileEditNameDialog(
        controller: ctrl,
        onSave: (name) {
          cubit.updateName(name);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _divider() => Divider(
        height: 1,
        thickness: 1,
        color: AppColors.dividerLight,
        indent: AppSpacing.lg + 38 + AppSpacing.md,
      );
}
