import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_nav_tile.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/common/profile_section_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileAttendanceSection extends StatelessWidget {
  const ProfileAttendanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: ProfileSectionCard(
        child: Column(
          children: [
            ProfileNavTile(
              icon: Icons.qr_code_scanner_rounded,
              iconColor: const Color(0xFF6366F1),
              iconBg: const Color(0xFF6366F1).withOpacity(0.12),
              title: 'تسجيل الحضور الذكي (QR Code)',
              subtitle: 'مسح كود المحاضرة وتسجيل حضورك فوراً',
              onTap: () => context.push(AppRouter.kAttendanceScannerView),
            ),
            const Divider(height: 1, indent: 48),
            ProfileNavTile(
              icon: Icons.fact_check_rounded,
              iconColor: const Color(0xFF10B981),
              iconBg: const Color(0xFF10B981).withOpacity(0.12),
              title: 'سجل الحضور والغياب',
              subtitle: 'عرض إحصائيات ونسب الحضور لجميع المقررات',
              onTap: () => context.push(AppRouter.kAttendanceSummaryView),
            ),
          ],
        ),
      ),
    );
  }
}
