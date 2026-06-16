import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/contact_model.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/contact_cubit/contact_cubit.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/help/contact_us_drag_handle.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/help/contact_us_issue_type_selector.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/help/contact_us_send_button.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/sections/help/contact_us_sheet_field.dart';

class ContactUsSheet extends StatelessWidget {
  const ContactUsSheet({super.key, this.initialType = IssueType.general});

  final IssueType initialType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactCubit(getIt<ProfileRepo>()),
      child: _ContactUsSheetBody(initialType: initialType),
    );
  }
}

class _ContactUsSheetBody extends StatefulWidget {
  const _ContactUsSheetBody({required this.initialType});

  final IssueType initialType;

  @override
  State<_ContactUsSheetBody> createState() => _ContactUsSheetBodyState();
}

class _ContactUsSheetBodyState extends State<_ContactUsSheetBody> {
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late IssueType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<ContactCubit>().send(
          ContactRequest(
            issueType: _selectedType,
            subject: _subjectCtrl.text.trim(),
            message: _messageCtrl.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactCubit, ContactState>(
      listener: _onStateChange,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: context.colorSurface,
            borderRadius: AppRadius.bottomSheet,
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            AppSpacing.lg,
            AppSpacing.xxl,
            AppSpacing.xxxl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ContactUsDragHandle(),
                AppSpacing.h20,
                Text(
                  AppLocalizations.of(context).contactUs,
                  style: AppTextStyles.heading4
                      .copyWith(color: context.colorTextPrimary),
                ),
                AppSpacing.h4,
                Text(
                  AppLocalizations.of(context).contactUsSubtitle,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: context.colorTextSecondary),
                ),
                AppSpacing.h20,
                ContactUsIssueTypeSelector(
                  selected: _selectedType,
                  onChanged: (t) => setState(() => _selectedType = t),
                ),
                AppSpacing.h16,
                ContactUsSheetField(
                  controller: _subjectCtrl,
                  hint: AppLocalizations.of(context).subject,
                  maxLines: 1,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? AppLocalizations.of(context).required
                      : null,
                ),
                AppSpacing.h12,
                ContactUsSheetField(
                  controller: _messageCtrl,
                  hint: AppLocalizations.of(context).describeIssue,
                  maxLines: 4,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? AppLocalizations.of(context).required
                      : null,
                ),
                AppSpacing.h20,
                ContactUsSendButton(onPressed: () => _submit(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onStateChange(BuildContext context, ContactState state) {
    if (state is ContactSuccess) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).messageSentSuccess,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: AppRadius.large),
          margin: AppSpacing.pagePadding,
        ),
      );
    } else if (state is ContactFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.message,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: AppRadius.large),
          margin: AppSpacing.pagePadding,
        ),
      );
    }
  }
}
