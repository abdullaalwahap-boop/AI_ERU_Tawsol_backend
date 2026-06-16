import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/change_password/password_requirement_row.dart';

class PasswordRequirementItem extends StatelessWidget {
  final String label;
  final bool met;

  const PasswordRequirementItem({
    super.key,
    required this.label,
    required this.met,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: PasswordRequirementRow(key: ValueKey(met), label: label, met: met),
    );
  }
}
