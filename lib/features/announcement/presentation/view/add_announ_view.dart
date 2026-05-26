import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/features/announcement/data/datasources/assignment_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/announ_repo.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/add_announ_scaffold.dart';

class AddAnnounView extends StatelessWidget {
  final AnnounRole role;
  final Announcement? announcementToEdit;

  const AddAnnounView({
    super.key,
    required this.role,
    this.announcementToEdit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddAnnounCubit(
        role: role,
        repo: getIt<AnnounRepo>(),
        assignmentDs: getIt<AssignmentRemoteDatasource>(),
        announcementToEdit: announcementToEdit,
      ),
      child: AddAnnounScaffold(role: role),
    );
  }
}
