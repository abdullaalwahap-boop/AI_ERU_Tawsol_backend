import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/admin_user_type.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/audience_summary_banner.dart';

class AddAnnounAdminAudienceSummary extends StatelessWidget {
  final AdminUserType? userType;
  final Set<String> selectedDepartments;
  final Set<String> selectedLevels;

  const AddAnnounAdminAudienceSummary({
    super.key,
    required this.userType,
    required this.selectedDepartments,
    required this.selectedLevels,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1,
          child: child,
        ),
      ),
      child: userType == null
          ? const SizedBox.shrink()
          : AudienceSummaryBanner(
              key: ValueKey(
                '${userType!.name}'
                '-${selectedDepartments.join()}'
                '-${selectedLevels.join()}',
              ),
              userType: userType!,
              selectedDepartments: selectedDepartments,
              selectedLevels: selectedLevels,
            ),
    );
  }
}
