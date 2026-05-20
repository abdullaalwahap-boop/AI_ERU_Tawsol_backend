import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 58,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
              side: BorderSide(
                color: Color.fromARGB(255, 158, 18, 8),
                width: 2,
              ),
            ),
          ),
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                size: 24,
                color: Color.fromARGB(255, 158, 18, 8),
              ),
              Text(
                'Log Out',
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 22,
                  color: Color.fromARGB(255, 158, 18, 8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
