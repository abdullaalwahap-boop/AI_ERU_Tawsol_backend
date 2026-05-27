import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/announ_repo.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/announ_cubit/announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/home/announ_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnounView extends StatelessWidget {
  final AnnounRole role;

  const AnnounView({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionCubit>().state;
    final userId = session is SessionAuthenticated ? session.userId : 0;
    return BlocProvider(
      create: (_) =>
          AnnounCubit(getIt<AnnounRepo>())..loadForRole(role, userId: userId),
      child: AnnounViewBody(role: role),
    );
  }
}
