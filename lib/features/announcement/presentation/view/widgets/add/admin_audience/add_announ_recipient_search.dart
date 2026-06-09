import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:flutter/material.dart';

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

  String _roleLabel(String typeCode, AppLocalizations l10n) => switch (typeCode) {
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
        // Search field
        TextField(
          controller: _controller,
          onChanged: widget.onSearch,
          decoration: InputDecoration(
            hintText: l10n.searchUsers,
            hintStyle: AppTextStyles.bodySmall
                .copyWith(color: context.colorTextHint),
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
              borderSide:
                  BorderSide(color: context.colorDivider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide:
                  BorderSide(color: context.colorDivider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),

        // Selected chips
        if (widget.selectedIds.isNotEmpty) ...[
          AppSpacing.h10,
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.recipients
                .where((r) => widget.selectedIds.contains(r.userId))
                .map((r) => _SelectedChip(
                      name: r.name,
                      color: _roleColor(r.typeCode),
                      onRemove: () => widget.onToggle(r.userId),
                    ))
                .toList(),
          ),
        ],

        // Results list
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
            return _RecipientTile(
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

class _SelectedChip extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback onRemove;

  const _SelectedChip({
    required this.name,
    required this.color,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close_rounded, size: 14, color: color),
          ),
        ],
      ),
    );
  }
}

class _RecipientTile extends StatelessWidget {
  final RecipientUser user;
  final String roleLabel;
  final Color roleColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _RecipientTile({
    required this.user,
    required this.roleLabel,
    required this.roleColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.06)
              : context.colorInputBg,
          borderRadius: AppRadius.medium,
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.4)
                : context.colorDivider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar initials
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: roleColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: roleColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            AppSpacing.w10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.typeCode == 'STU'
                        ? '${user.uniCode} · $roleLabel'
                            '${user.department != null ? ' · ${user.department}' : ''}'
                        : roleLabel,
                    style: AppTextStyles.overline.copyWith(
                      color: context.colorTextHint,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : context.colorDivider,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
