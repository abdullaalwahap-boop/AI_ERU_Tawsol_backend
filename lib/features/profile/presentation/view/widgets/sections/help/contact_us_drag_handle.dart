import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

class ContactUsDragHandle extends StatelessWidget {
  const ContactUsDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: context.colorDivider,
          borderRadius: AppRadius.circular,
        ),
      ),
    );
  }
}
