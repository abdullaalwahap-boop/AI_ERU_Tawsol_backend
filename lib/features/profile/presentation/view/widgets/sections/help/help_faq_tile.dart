import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class HelpFaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const HelpFaqTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<HelpFaqTile> createState() => _HelpFaqTileState();
}

class _HelpFaqTileState extends State<HelpFaqTile>
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
                      style: AppTextStyles.titleSmall
                          .copyWith(color: AppColors.textPrimary),
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
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
