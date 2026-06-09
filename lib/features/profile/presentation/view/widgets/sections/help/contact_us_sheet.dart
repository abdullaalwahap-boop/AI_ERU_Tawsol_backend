import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/contact_model.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/manager/contact_cubit/contact_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                _DragHandle(),
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
                _IssueTypeSelector(
                  selected: _selectedType,
                  onChanged: (t) => setState(() => _selectedType = t),
                ),
                AppSpacing.h16,
                _SheetField(
                  controller: _subjectCtrl,
                  hint: AppLocalizations.of(context).subject,
                  maxLines: 1,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? AppLocalizations.of(context).required
                      : null,
                ),
                AppSpacing.h12,
                _SheetField(
                  controller: _messageCtrl,
                  hint: AppLocalizations.of(context).describeIssue,
                  maxLines: 4,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? AppLocalizations.of(context).required
                      : null,
                ),
                AppSpacing.h20,
                _SendButton(onPressed: () => _submit(context)),
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

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _DragHandle extends StatelessWidget {
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

class _IssueTypeSelector extends StatelessWidget {
  const _IssueTypeSelector({
    required this.selected,
    required this.onChanged,
  });

  final IssueType selected;
  final ValueChanged<IssueType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).category,
          style:
              AppTextStyles.labelMedium.copyWith(color: context.colorTextSecondary),
        ),
        AppSpacing.h8,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: IssueType.values.map((type) {
              final isSelected = type == selected;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () => onChanged(type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs + 1,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : context.colorInputBg,
                      borderRadius: AppRadius.circular,
                      border: isSelected
                          ? null
                          : Border.all(color: context.colorBorder),
                    ),
                    child: Text(
                      type.label,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? AppColors.textOnPrimary
                            : context.colorTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.controller,
    required this.hint,
    required this.maxLines,
    required this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: AppTextStyles.bodyMedium.copyWith(color: context.colorTextPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            AppTextStyles.bodyMedium.copyWith(color: context.colorTextHint),
        filled: true,
        fillColor: context.colorInputBg,
        border: OutlineInputBorder(
          borderRadius: AppRadius.large,
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.large,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.large,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.lg),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactCubit, ContactState>(
      builder: (context, state) {
        final isLoading = state is ContactLoading;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
              foregroundColor: AppColors.textOnPrimary,
              shape:
                  RoundedRectangleBorder(borderRadius: AppRadius.large),
              padding:
                  const EdgeInsets.symmetric(vertical: AppSpacing.md),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    AppLocalizations.of(context).sendMessage,
                    style: AppTextStyles.buttonMedium
                        .copyWith(color: AppColors.textOnPrimary),
                  ),
          ),
        );
      },
    );
  }
}
