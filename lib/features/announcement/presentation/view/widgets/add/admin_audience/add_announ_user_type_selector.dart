import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/admin_user_type.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/user_type_card.dart';

class AddAnnounUserTypeSelector extends StatelessWidget {
  final AdminUserType? selected;
  final void Function(AdminUserType) onSelected;

  const AddAnnounUserTypeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final types = AdminUserType.values;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: types.take(3).map((type) {
            final isLast = type == types[2];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 10),
                child: UserTypeCard(
                  type: type,
                  isSelected: selected == type,
                  onTap: () => onSelected(type),
                ),
              ),
            );
          }).toList(),
        ),
        AppSpacing.h10,
        Row(
          children: types.skip(3).map((type) {
            final isLast = type == types.last;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 10),
                child: UserTypeCard(
                  type: type,
                  isSelected: selected == type,
                  onTap: () => onSelected(type),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
