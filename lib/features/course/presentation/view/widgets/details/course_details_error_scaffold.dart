import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/states/feature_error_state.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/manager/course_details_cubit/course_details_cubit.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/shared/white_back_button.dart';

class CourseDetailsErrorScaffold extends StatelessWidget {
  final Course course;
  final CourseRole role;
  final String message;

  const CourseDetailsErrorScaffold({
    super.key,
    required this.course,
    required this.role,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: course.accentColor,
        leading: const WhiteBackButton(),
        title: Text(
          course.name,
          style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
        ),
      ),
      body: FeatureErrorState(
        message: message,
        primaryColor: AppColors.primary,
        onRetry: () => context.read<CourseDetailsCubit>().refresh(role, course),
      ),
    );
  }
}
