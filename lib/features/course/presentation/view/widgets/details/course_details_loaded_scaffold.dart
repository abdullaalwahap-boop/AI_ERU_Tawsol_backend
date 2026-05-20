import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/shared/extensions/course_content_display_ext.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/filter/feature_filter_row.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/extensions/content_type_ui_ext.dart';
import 'package:ai_eru_tawasol/features/course/presentation/manager/course_details_cubit/course_details_cubit.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/details/content_card/course_content_card.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/details/course_banner.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/states/feature_empty_state.dart';

class CourseDetailsLoadedScaffold extends StatelessWidget {
  final CourseRole role;
  final Course course;
  final CourseDetailsLoaded state;

  const CourseDetailsLoadedScaffold({
    super.key,
    required this.role,
    required this.course,
    required this.state,
  });

  List<FilterItem<ContentType>> _filterItems() {
    return [
      const FilterItem<ContentType>(
        label: 'All',
        icon: Icons.apps_rounded,
        color: AppColors.primary,
        value: null,
      ),
      ...ContentType.values.map(
        (t) => FilterItem<ContentType>(
          label: t.label,
          icon: t.icon,
          color: t.color,
          value: t,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CourseDetailsCubit>();
    final items = state.filteredContent;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surfaceLight,
        displacement: 20,
        onRefresh: () => cubit.refresh(role, course),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          slivers: [
            CourseBanner(course: course),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 4),
                child: FeatureFilterRow<ContentType>(
                  items: _filterItems(),
                  activeValue: state.activeFilter,
                  onChanged: cubit.filterContent,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: items.isEmpty
                  ? const FeatureEmptyState(
                      icon: Icons.inbox_outlined,
                      title: 'No Content Yet',
                      description:
                          'Nothing has been posted for this course yet.\nCheck back later for updates.',
                      accentColor: AppColors.primary,
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 6, bottom: 24),
                      itemCount: items.length,
                      itemBuilder: (context, i) => CourseContentCard(
                        content: items[i],
                        index: i,
                        onTap: () => context.push(
                          AppRouter.kContentDetailsView,
                          extra: items[i].toDisplayItem(state.course),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
