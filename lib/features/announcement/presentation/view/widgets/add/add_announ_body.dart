import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/actions/add_announ_action_buttons.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/add_announ_text_field.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/attachments/add_announ_attachment_section.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/add_announ_admin_audience_selector.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/post_type/add_announ_post_type_selector.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/priority/add_announ_priority_selector.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/subject/add_announ_subject_selector.dart';

class AddAnnounBody extends StatefulWidget {
  final AnnounRole role;

  const AddAnnounBody({super.key, required this.role});

  @override
  State<AddAnnounBody> createState() => _AddAnnounBodyState();
}

class _AddAnnounBodyState extends State<AddAnnounBody> {
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddAnnounCubit, AddAnnounState>(
      builder: (context, state) {
        final cubit = context.read<AddAnnounCubit>();
        final isDoctor = widget.role == AnnounRole.doctor;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDoctor) ...[
                      AddAnnounPostTypeSelector(
                        selected: state.postType,
                        onSelected: cubit.selectPostType,
                      ),
                      const SizedBox(height: 24),
                    ],
                    AddAnnounTextField(
                      label: 'Title',
                      hint: 'Enter announcement title...',
                      controller: _titleController,
                      onChanged: cubit.setTitle,
                    ),
                    const SizedBox(height: 16),
                    AddAnnounTextField(
                      label: 'Details',
                      hint: 'Write your announcement content here...',
                      controller: _detailsController,
                      maxLines: 6,
                      onChanged: cubit.setDetails,
                    ),
                    const SizedBox(height: 24),
                    AddAnnounAttachmentSection(
                      visible: state.supportsAttachments,
                      attachments: state.attachments,
                      onAdd: cubit.addAttachment,
                      onRemove: cubit.removeAttachment,
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      child: state.supportsAttachments
                          ? const SizedBox(height: 24)
                          : const SizedBox.shrink(),
                    ),
                    if (isDoctor)
                      AddAnnounSubjectSelector(
                        subjects: cubit.audienceOptions,
                        selected: state.selectedOptions,
                        onSelect: cubit.toggleOption,
                      )
                    else
                      AddAnnounAdminAudienceSelector(
                        state: state,
                        onUserTypeSelected: cubit.setAdminUserType,
                        onDeptToggle: cubit.toggleDepartment,
                        onLevelToggle: cubit.toggleLevel,
                        departments: cubit.adminDepartments,
                        levels: cubit.adminLevels,
                      ),
                    if (isDoctor) ...[
                      const SizedBox(height: 24),
                      AddAnnounPrioritySelector(
                        selected: state.priority,
                        onSelected: cubit.setPriority,
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            AddAnnounActionButtons(
              canPost: state.canPost,
              isPosting: state.isPosting,
              onDiscard: () => Navigator.pop(context),
              onPost: cubit.post,
            ),
          ],
        );
      },
    );
  }
}
