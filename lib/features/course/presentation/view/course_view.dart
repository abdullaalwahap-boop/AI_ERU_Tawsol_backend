import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/data/repos/course_repo.dart';
import 'package:ai_eru_tawasol/features/course/presentation/manager/courses_cubit/courses_cubit.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/home/course_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseView extends StatelessWidget {
  final CourseRole role;

  const CourseView({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoursesCubit(getIt<CourseRepo>())..loadForRole(role),
      child: CourseViewBody(role: role),
    );
  }
}
