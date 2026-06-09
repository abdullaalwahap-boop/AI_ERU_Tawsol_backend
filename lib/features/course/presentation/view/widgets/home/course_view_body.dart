import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/states/feature_error_state.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/manager/courses_cubit/courses_cubit.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/home/courses_app_bar.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/home/courses_list.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/states/courses_loading_skeleton.dart';

class CourseViewBody extends StatelessWidget {
  final CourseRole role;

  const CourseViewBody({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesCubit, CoursesState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colorBackground,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoursesAppBar(role: role),
              Expanded(child: _buildContent(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, CoursesState state) {
    if (state is CoursesLoading) return const CoursesLoadingSkeleton();

    if (state is CoursesError) {
      return FeatureErrorState(
        message: state.message,
        primaryColor: AppColors.primary,
        onRetry: () => context.read<CoursesCubit>().loadForRole(role),
      );
    }

    if (state is CoursesLoaded) {
      return RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: context.colorSurface,
        displacement: 20,
        onRefresh: () => context.read<CoursesCubit>().refresh(role),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          child: CoursesList(courses: state.courses, role: role),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
