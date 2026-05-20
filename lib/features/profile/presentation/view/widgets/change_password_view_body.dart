import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/additional_pages_app_bar.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/custom_password_section.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/password_requirements_list.dart';
import 'package:flutter/material.dart';

class ChangePasswordViewBody extends StatefulWidget {
  const ChangePasswordViewBody({super.key});

  @override
  State<ChangePasswordViewBody> createState() => _ChangePasswordViewBodyState();
}

class _ChangePasswordViewBodyState extends State<ChangePasswordViewBody> {
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  bool hasMinLength = false;
  bool hasNumber = false;
  bool hasUpperCase = false;

  bool isMatch = false;

  void onPasswordChanged(String value) {
    setState(() {
      hasMinLength = value.length >= 8;
      hasNumber = value.contains(RegExp(r'\d'));
      hasUpperCase = value.contains(RegExp(r'[A-Z]'));
    });
  }

  void checkPasswordsMatch() {
    setState(() {
      isMatch = newController.text == confirmController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdditionalPagesAppBar(title: 'Change Password'),
          AppSpacing.h40,
          CustomPasswordSection(title: 'Current Password'),
          SizedBox(height: 30),
          CustomPasswordSection(
            title: 'New Password',
            controller: newController,
            onChanged: (value) {
              onPasswordChanged(value);
              checkPasswordsMatch();
            },
          ),
          SizedBox(height: 30),
          CustomPasswordSection(
            title: 'Confirm New Password',
            controller: confirmController,
            onChanged: (value) {
              checkPasswordsMatch();
            },
          ),
          SizedBox(height: 30),
          PasswordRequirementsList(
            isMatch: isMatch,
            hasMinLength: hasMinLength,
            hasNumber: hasNumber,
            hasUpperCase: hasUpperCase,
          ),
          SizedBox(height: 60),
          // SizedBox(
          //   width: double.infinity,
          //   child: CustomButton(text: 'Update Password', onPressed: () {}),
          // ),
        ],
      ),
    );
  }
}
