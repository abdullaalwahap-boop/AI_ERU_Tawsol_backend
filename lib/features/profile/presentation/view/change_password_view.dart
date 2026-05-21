import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo_impl.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/change_password_cubit/change_password_cubit.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/change_password/change_password_app_bar.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/change_password/change_password_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(ProfileRepoImpl()),
      child: const Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: ChangePasswordAppBar(),
        body: ChangePasswordBody(),
      ),
    );
  }
}
