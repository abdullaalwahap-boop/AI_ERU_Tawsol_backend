import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/shared/section_header.dart';

class AddAnnounDeadlinePicker extends StatelessWidget {
  final bool visible;
  final DateTime? deadline;
  final void Function(DateTime) onPick;

  const AddAnnounDeadlinePicker({
    super.key,
    required this.visible,
    required this.deadline,
    required this.onPick,
  });

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
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.deadline),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _pickDeadline(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: deadline != null
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : context.colorInputBg,
              borderRadius: AppRadius.medium,
              border: Border.all(
                color: deadline != null
                    ? AppColors.primary.withValues(alpha: 0.4)
                    : context.colorDivider,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: AppRadius.small,
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                AppSpacing.w12,
                Expanded(
                  child: deadline == null
                      ? Text(
                          l10n.selectDeadline,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: context.colorTextHint),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDate(deadline!, context),
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.colorTextPrimary,
                              ),
                            ),
                            AppSpacing.h2,
                            Text(
                              _formatTime(deadline!, context),
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                ),
                if (deadline != null)
                  GestureDetector(
                    onTap: () => _pickDeadline(context),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 16,
                      color: context.colorTextHint,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static const _monthsEn = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _monthsAr = [
    '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];
  static const _weekdaysEn = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _weekdaysAr = ['', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];

  String _formatDate(DateTime dt, BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final day = isAr ? _weekdaysAr[dt.weekday] : _weekdaysEn[dt.weekday];
    final month = isAr ? _monthsAr[dt.month] : _monthsEn[dt.month];
    return '$day، ${dt.day} $month ${dt.year}';
  }

  String _formatTime(DateTime dt, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hour = dt.hour == 0
        ? 12
        : dt.hour > 12
            ? dt.hour - 12
            : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? l10n.am : l10n.pm;
    return '$hour:$minute $period';
  }

  Future<void> _pickDeadline(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = now.add(const Duration(minutes: 5));

    final initialDate = (deadline != null && deadline!.isAfter(firstDate))
        ? deadline!
        : firstDate;
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: now.add(const Duration(days: 365)),
      helpText: AppLocalizations.of(context).selectDeadlineDate,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: deadline != null
          ? TimeOfDay.fromDateTime(deadline!)
          : const TimeOfDay(hour: 23, minute: 59),
      helpText: AppLocalizations.of(context).selectDeadlineTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (time == null) return;

    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (combined.isAfter(DateTime.now())) {
      onPick(combined);
    }
  }
}
