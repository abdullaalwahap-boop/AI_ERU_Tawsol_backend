import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

class NewChatSheetHandle extends StatelessWidget {
  const NewChatSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: context.colorDivider,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
