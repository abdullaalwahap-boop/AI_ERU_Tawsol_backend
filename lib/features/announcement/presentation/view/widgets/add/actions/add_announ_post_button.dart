import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';

class AddAnnounPostButton extends StatelessWidget {
  final bool canPost;
  final bool isPosting;
  final VoidCallback onTap;

  const AddAnnounPostButton({
    super.key,
    required this.canPost,
    required this.isPosting,
    required this.onTap,
  });

  bool get _isActive => canPost && !isPosting;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: _isActive
              ? const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: _isActive ? null : AppColors.dividerLight,
          borderRadius: AppRadius.large,
          boxShadow: _isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.large,
            onTap: _isActive ? onTap : null,
            child: Center(child: _buildContent()),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isPosting) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.send_rounded,
          size: 17,
          color: canPost ? Colors.white : AppColors.textHint,
        ),
        const SizedBox(width: 7),
        Text(
          'Post Announcement',
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: canPost ? Colors.white : AppColors.textHint,
          ),
        ),
      ],
    );
  }
}
