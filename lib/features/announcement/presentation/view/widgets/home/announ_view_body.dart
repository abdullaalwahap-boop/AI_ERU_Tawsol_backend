import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/announ_cubit/announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/home/app_bar/announ_app_bar.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/home/filter/announ_filter_row.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/home/list/announ_list.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/home/tabs/announ_tab_bar.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/states/announ_error_state.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/states/announ_loading_skeleton.dart';

class AnnounViewBody extends StatelessWidget {
  final AnnounRole role;

  const AnnounViewBody({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnounCubit, AnnounState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnnounAppBar(role: role),
              Expanded(child: _buildContent(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AnnounState state) {
    if (state is AnnounLoading) return const AnnounLoadingSkeleton();

    if (state is AnnounError) {
      return AnnounErrorState(
        message: state.message,
        onRetry: () => context.read<AnnounCubit>().loadForRole(role),
      );
    }

    if (state is AnnounLoaded) return _buildLoaded(context, state);

    return const SizedBox.shrink();
  }

  Widget _buildLoaded(BuildContext context, AnnounLoaded state) {
    final cubit = context.read<AnnounCubit>();
    final isDoctor = role == AnnounRole.doctor;
    final isAdmin = role == AnnounRole.admin;

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceLight,
      displacement: 20,
      onRefresh: () => cubit.refresh(role),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        slivers: [
          if (isDoctor)
            SliverToBoxAdapter(
              child: AnnounTabBar(
                selected: state.activeTab,
                onTabSelected: cubit.switchTab,
                mineCount: state.primary.length,
                adminCount: state.secondary.length,
              ),
            ),
          if (!isAdmin && !(isDoctor && state.activeTab == AnnounTab.admin))
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: isDoctor ? 12 : 14, bottom: 4),
                child: AnnounFilterRow(
                  activeFilter: state.activeFilter,
                  onFilterChanged: cubit.filterByType,
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: AnnounList(announcements: state.current),
          ),
        ],
      ),
    );
  }
}
