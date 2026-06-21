import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/announ_cubit/announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/home/tabs/announ_tab_item.dart';

class AnnounTabBar extends StatelessWidget {
  final AnnounTab selected;
  final void Function(AnnounTab) onTabSelected;
  final int mineCount;
  final int adminCount;

  const AnnounTabBar({
    super.key,
    required this.selected,
    required this.onTabSelected,
    required this.mineCount,
    required this.adminCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colorInputBg,
        borderRadius: AppRadius.xlarge,
      ),
      child: Row(
        children: [
          AnnounTabItem(
            label: AppLocalizations.of(context).myAnnouncements,
            icon: Icons.person_rounded,
            count: mineCount,
            isSelected: selected == AnnounTab.mine,
            onTap: () => onTabSelected(AnnounTab.mine),
          ),
          AnnounTabItem(
            label: AppLocalizations.of(context).others,
            icon: Icons.admin_panel_settings_rounded,
            count: adminCount,
            isSelected: selected == AnnounTab.admin,
            onTap: () => onTabSelected(AnnounTab.admin),
          ),
        ],
      ),
    );
  }
}
