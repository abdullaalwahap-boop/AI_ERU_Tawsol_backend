import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/events/announcement_change_notifier.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/data/services/announcement_ws_service.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/announ_cubit/announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/home/app_bar/announ_app_bar.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/home/filter/announ_filter_row.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/home/list/announ_list.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/home/tabs/announ_tab_bar.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/states/announ_error_state.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/states/announ_loading_skeleton.dart';

class AnnounViewBody extends StatefulWidget {
  final AnnounRole role;

  const AnnounViewBody({super.key, required this.role});

  @override
  State<AnnounViewBody> createState() => _AnnounViewBodyState();
}

class _AnnounViewBodyState extends State<AnnounViewBody> {
  StreamSubscription<int>? _wsSub;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    getIt<AnnouncementChangeNotifier>().addListener(_onAnnouncementChanged);
    _connectWs();
    // Background polling fallback (every 30s) ensures immediate notification & announcement updates
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        context.read<AnnounCubit>().silentRefresh(widget.role);
      }
    });
  }

  void _connectWs() {
    final wsService = getIt<AnnouncementWsService>();
    wsService.ensureConnected();
    _wsSub = wsService.newAnnouncements.listen((_) {
      if (mounted) context.read<AnnounCubit>().silentRefresh(widget.role);
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _wsSub?.cancel();
    getIt<AnnouncementChangeNotifier>().removeListener(_onAnnouncementChanged);
    super.dispose();
  }

  void _onAnnouncementChanged() {
    final notifier = getIt<AnnouncementChangeNotifier>();
    final cubit = context.read<AnnounCubit>();
    if (notifier.replaced != null) {
      cubit.replaceAnnouncement(notifier.replaced!);
    } else if (notifier.deletedId != null) {
      cubit.localDelete(notifier.deletedId!);
    } else if (notifier.markedReadId != null) {
      cubit.localMarkRead(notifier.markedReadId!);
    } else if (notifier.added != null) {
      cubit.prependAnnouncement(notifier.added!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnounCubit, AnnounState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colorBackground,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnnounAppBar(role: widget.role),
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
        onRetry: () => context.read<AnnounCubit>().loadForRole(widget.role),
      );
    }

    if (state is AnnounLoaded) return _buildLoaded(context, state);

    return const SizedBox.shrink();
  }

  Widget _buildLoaded(BuildContext context, AnnounLoaded state) {
    final cubit = context.read<AnnounCubit>();
    final isDoctor = widget.role == AnnounRole.doctor;
    final isAdmin = widget.role == AnnounRole.admin;

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: context.colorSurface,
      displacement: 20,
      onRefresh: () => cubit.refresh(widget.role),
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
                padding:
                    EdgeInsets.only(top: isDoctor ? 12 : 14, bottom: 4),
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
