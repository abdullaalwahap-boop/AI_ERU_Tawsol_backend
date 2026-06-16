import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/recipient_selected_chip.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/recipient_tile.dart';

class AddAnnounRecipientSearch extends StatefulWidget {
  final List<RecipientUser> recipients;
  final bool isLoading;
  final Set<int> selectedIds;
  final void Function(String query) onSearch;
  final void Function(int userId) onToggle;

  const AddAnnounRecipientSearch({
    super.key,
    required this.recipients,
    required this.isLoading,
    required this.selectedIds,
    required this.onSearch,
    required this.onToggle,
  });

  @override
  State<AddAnnounRecipientSearch> createState() =>
      _AddAnnounRecipientSearchState();
}

class _AddAnnounRecipientSearchState extends State<AddAnnounRecipientSearch> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _roleLabel(String typeCode, AppLocalizations l10n) =>
      switch (typeCode) {
        'DR' => l10n.doctor,
        'TA' => l10n.assistant,
        'STU' => l10n.student,
        _ => typeCode,
      };

  Color _roleColor(String typeCode) => switch (typeCode) {
        'DR' => const Color(0xff7C3AED),
        'TA' => const Color(0xff0284C7),
        _ => AppColors.primary,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: widget.onSearch,
          decoration: InputDecoration(
            hintText: l10n.searchUsers,
            hintStyle:
                AppTextStyles.bodySmall.copyWith(color: context.colorTextHint),
            prefixIcon: Icon(Icons.search_rounded,
                size: 20, color: context.colorTextHint),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close_rounded,
                        size: 18, color: context.colorTextHint),
                    onPressed: () {
                      _controller.clear();
                      widget.onSearch('');
                    },
                  )
                : null,
            filled: true,
            fillColor: context.colorInputBg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: BorderSide(color: context.colorDivider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: BorderSide(color: context.colorDivider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        if (widget.selectedIds.isNotEmpty) ...[
          AppSpacing.h10,
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.recipients
                .where((r) => widget.selectedIds.contains(r.userId))
                .map((r) => RecipientSelectedChip(
                      name: r.name,
                      color: _roleColor(r.typeCode),
                      onRemove: () => widget.onToggle(r.userId),
                    ))
                .toList(),
          ),
        ],
        AppSpacing.h10,
        if (widget.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (widget.recipients.isEmpty && _controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              l10n.noUsersFound,
              style: AppTextStyles.bodySmall
                  .copyWith(color: context.colorTextHint),
            ),
          )
        else
          ...widget.recipients.map((r) {
            final isSelected = widget.selectedIds.contains(r.userId);
            return RecipientTile(
              user: r,
              roleLabel: _roleLabel(r.typeCode, l10n),
              roleColor: _roleColor(r.typeCode),
              isSelected: isSelected,
              onTap: () => widget.onToggle(r.userId),
            );
          }),
      ],
    );
  }
}
