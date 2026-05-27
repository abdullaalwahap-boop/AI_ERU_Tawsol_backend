import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/events/announcement_change_notifier.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/features/announcement/data/services/announcement_ws_service.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/manager/course_details_cubit/course_details_cubit.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/details/course_details_error_scaffold.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/details/course_details_loaded_scaffold.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/details/course_details_loading_scaffold.dart';

class CourseDetailsBody extends StatefulWidget {
  final CourseRole role;
  final Course course;

  const CourseDetailsBody({
    super.key,
    required this.role,
    required this.course,
  });

  @override
  State<CourseDetailsBody> createState() => _CourseDetailsBodyState();
}

class _CourseDetailsBodyState extends State<CourseDetailsBody> {
  StreamSubscription<int>? _wsSub;

  @override
  void initState() {
    super.initState();
    _connectWs();
    getIt<AnnouncementChangeNotifier>().addListener(_onAnnouncementChanged);
  }

  void _connectWs() {
    final wsService = getIt<AnnouncementWsService>();
    wsService.ensureConnected();
    _wsSub = wsService.newAnnouncements.listen((_) {
      if (mounted) {
        context
            .read<CourseDetailsCubit>()
            .silentRefresh(widget.role, widget.course);
      }
    });
  }

  void _onAnnouncementChanged() {
    if (!mounted) return;
    final notifier = getIt<AnnouncementChangeNotifier>();
    final cubit = context.read<CourseDetailsCubit>();
    if (notifier.deletedId != null) {
      cubit.removeContent(notifier.deletedId!);
    } else if (notifier.replaced != null) {
      cubit.updateAnnouncementContent(notifier.replaced!);
    }
  }

  @override
  void dispose() {
    _wsSub?.cancel();
    getIt<AnnouncementChangeNotifier>().removeListener(_onAnnouncementChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
      builder: (context, state) {
        if (state is CourseDetailsLoading) {
          return CourseDetailsLoadingScaffold(course: widget.course);
        }
        if (state is CourseDetailsError) {
          return CourseDetailsErrorScaffold(
            course: widget.course,
            role: widget.role,
            message: state.message,
          );
        }
        if (state is CourseDetailsLoaded) {
          return CourseDetailsLoadedScaffold(
            role: widget.role,
            course: widget.course,
            state: state,
          );
        }
        return CourseDetailsLoadingScaffold(course: widget.course);
      },
    );
  }
}
