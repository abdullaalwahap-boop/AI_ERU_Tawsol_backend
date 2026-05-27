import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/add_announ_app_bar.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/add_announ_body.dart';

class AddAnnounScaffold extends StatelessWidget {
  final AnnounRole role;

  const AddAnnounScaffold({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocListener<AddAnnounCubit, AddAnnounState>(
        listenWhen: (prev, curr) => curr.isPosted && !prev.isPosted,
        listener: _onPosted,
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AddAnnounAppBar(role: role),
          body: AddAnnounBody(role: role),
        ),
      ),
    );
  }

  void _onPosted(BuildContext context, AddAnnounState state) {
    final label = state.postType == AnnouncementType.assignment
        ? 'Assignment created successfully!'
        : 'Announcement posted successfully!';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            AppSpacing.w8,
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xff059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 3),
      ),
    );
    if (state.postType == AnnouncementType.assignment) {
      context.pop(true);
    } else {
      context.pop(state.postedAnnouncement);
    }
  }
}
