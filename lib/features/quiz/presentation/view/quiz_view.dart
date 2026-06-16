import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_args.dart';
import 'package:ai_eru_tawasol/features/quiz/data/repos/quiz_repo.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/manager/quiz_cubit/quiz_cubit.dart';
import 'package:ai_eru_tawasol/features/quiz/presentation/view/quiz_scaffold.dart';

class QuizView extends StatelessWidget {
  final QuizArgs args;

  const QuizView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizCubit(getIt<QuizRepo>())..generateQuiz(args.fileId),
      child: QuizScaffold(args: args),
    );
  }
}
