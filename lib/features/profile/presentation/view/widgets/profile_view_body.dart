import 'package:ai_eru_tawasol/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/profile_error_view.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/profile_loaded_view.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/profile_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const ProfileLoadingView();
        }
        if (state is ProfileError) {
          return ProfileErrorView(
            message: state.message,
            onRetry: () => context.read<ProfileCubit>().load(),
          );
        }

        final user = switch (state) {
          ProfileLoaded s => s.user,
          ProfileUpdating s => s.user,
          ProfileUpdateSuccess s => s.user,
          _ => null,
        };

        if (user == null) return const ProfileLoadingView();
        return ProfileLoadedView(user: user);
      },
    );
  }
}
