import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/data/repos/course_repo.dart';
import 'package:ai_eru_tawasol/features/course/presentation/manager/course_details_cubit/course_details_cubit.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/details/course_details_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseDetailsView extends StatelessWidget {
  final CourseDetailsArgs args;

  const CourseDetailsView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CourseDetailsCubit(getIt<CourseRepo>())
        ..loadForRole(args.role, args.course),
      child: CourseDetailsBody(role: args.role, course: args.course),
    );
  }
}
