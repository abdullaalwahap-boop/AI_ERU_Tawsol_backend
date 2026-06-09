import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/attachments/add_announ_add_more_button.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/attachments/add_announ_file_card.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/attachments/add_announ_upload_zone.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/attachments/picker/add_announ_attach_picker_sheet.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/shared/section_header.dart';

class AddAnnounAttachmentSection extends StatelessWidget {
  final bool visible;
  final List<AddAnnounAttachmentItem> attachments;
  final void Function(AddAnnounAttachmentItem) onAdd;
  final void Function(String id) onRemove;

  const AddAnnounAttachmentSection({
    super.key,
    required this.visible,
    required this.attachments,
    required this.onAdd,
    required this.onRemove,
  });

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AddAnnounAttachPickerSheet(onPick: onAdd),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      alignment: Alignment.topCenter,
      child: visible ? _buildContent(context) : const SizedBox.shrink(),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: AppLocalizations.of(context).attachments),
        const SizedBox(height: 12),
        if (attachments.isEmpty)
          AddAnnounUploadZone(onTap: () => _showPicker(context))
        else ...[
          ...attachments.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AddAnnounFileCard(
                item: item,
                onRemove: () => onRemove(item.id),
              ),
            ),
          ),
          const SizedBox(height: 4),
          AddAnnounAddMoreButton(onTap: () => _showPicker(context)),
        ],
      ],
    );
  }
}
