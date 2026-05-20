import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_nav_tile.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_section_card.dart';
import 'package:flutter/material.dart';

class ProfileHelpSection extends StatelessWidget {
  const ProfileHelpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileSectionCard(
          title: 'FAQ',
          titleIcon: Icons.quiz_outlined,
          children: const [
            _FaqTile(
              question: 'How do I reset my password?',
              answer:
                  'Go to Account → Change Password. You\'ll need your current password. If you\'ve forgotten it, use Forgot Password on the login screen.',
            ),
            _FaqTile(
              question: 'How are announcements filtered?',
              answer:
                  'Announcements are filtered by your role, level, and enrolled courses. Use the filter chips on the home screen to narrow down by type.',
            ),
            _FaqTile(
              question: 'Can I submit assignments here?',
              answer:
                  'Yes — open the relevant course, navigate to the assignment card, and tap Submit. Accepted formats: PDF, Word, ZIP.',
            ),
            _FaqTile(
              question: 'Who can see my messages?',
              answer:
                  'Direct messages are private between you and the recipient. Group channels are visible to all enrolled members of that course.',
            ),
          ],
        ),
        ProfileSectionCard(
          title: 'Support',
          titleIcon: Icons.headset_mic_outlined,
          children: [
            ProfileNavTile(
              icon: Icons.mail_outline_rounded,
              iconColor: AppColors.accent,
              iconBg: AppColors.accentLight.withValues(alpha: 0.13),
              title: 'Contact Us',
              subtitle: 'support@eru.edu.eg',
              onTap: () => _launchEmail(context),
            ),
            ProfileNavTile(
              icon: Icons.flag_outlined,
              iconColor: AppColors.error,
              iconBg: AppColors.errorLight,
              title: 'Report an Issue',
              subtitle: 'Something broken? Tell us',
              onTap: () => _showReportSheet(context),
            ),
          ],
        ),
      ],
    );
  }

  void _launchEmail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening email client…',
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        margin: AppSpacing.pagePadding,
      ),
    );
  }

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _ReportSheet(),
    );
  }
}

// ─── FAQ Tile ─────────────────────────────────────────────────────────────────

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl;
  late final Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _rotate = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.large,
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: AppRadius.medium,
                    ),
                    child: Icon(
                      Icons.help_outline_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  AppSpacing.w12,
                  Expanded(
                    child: Text(
                      widget.question,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  AppSpacing.w8,
                  RotationTransition(
                    turns: _rotate,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm + 38 + AppSpacing.md,
              0,
              AppSpacing.sm,
              AppSpacing.md,
            ),
            child: Text(
              widget.answer,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.dividerLight,
          indent: AppSpacing.lg + 38 + AppSpacing.md,
        ),
      ],
    );
  }
}

// ─── Report Sheet ─────────────────────────────────────────────────────────────

class _ReportSheet extends StatefulWidget {
  const _ReportSheet();

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  final _ctrl = TextEditingController();
  _ReportCategory _category = _ReportCategory.bug;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.bottomSheet,
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, AppSpacing.xxxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dividerLight,
                  borderRadius: AppRadius.circular,
                ),
              ),
            ),
            AppSpacing.h20,
            Text(
              'Report an Issue',
              style: AppTextStyles.heading4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.h4,
            Text(
              'Help us improve ERU Tawasol',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.h20,
            Text(
              'Category',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.h8,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _ReportCategory.values.map((cat) {
                  final sel = cat == _category;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () => setState(() => _category = cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs + 1,
                        ),
                        decoration: BoxDecoration(
                          color: sel
                              ? AppColors.primary
                              : AppColors.inputBgLight,
                          borderRadius: AppRadius.circular,
                          border: sel
                              ? null
                              : Border.all(color: AppColors.borderLight),
                        ),
                        child: Text(
                          cat.label,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: sel
                                ? AppColors.textOnPrimary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            AppSpacing.h16,
            TextField(
              controller: _ctrl,
              maxLines: 4,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Describe the issue in detail…',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textHint,
                ),
                filled: true,
                fillColor: AppColors.inputBgLight,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.large,
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(AppSpacing.lg),
              ),
            ),
            AppSpacing.h20,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Report submitted. Thank you!',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.large,
                      ),
                      margin: AppSpacing.pagePadding,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.large,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  elevation: 0,
                ),
                child: Text(
                  'Submit Report',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ReportCategory {
  bug('Bug'),
  suggestion('Suggestion'),
  content('Content'),
  other('Other');

  final String label;
  const _ReportCategory(this.label);
}
