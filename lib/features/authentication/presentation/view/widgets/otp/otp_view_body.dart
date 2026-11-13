import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/otp_cubit/otp_cubit.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/otp/otp_email_label.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/otp/otp_input_row.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/otp/otp_resend_section.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/shared/auth_gradient_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpViewBody extends StatefulWidget {
  const OtpViewBody({super.key, required this.email, this.initialOtp});

  final String email;
  final String? initialOtp;

  @override
  State<OtpViewBody> createState() => _OtpViewBodyState();
}

class _OtpViewBodyState extends State<OtpViewBody> {
  final _otpRowKey = GlobalKey<OtpInputRowState>();
  String _code = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialOtp != null && widget.initialOtp!.trim().length == 6) {
      _code = widget.initialOtp!.trim();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _otpRowKey.currentState?.setCode(widget.initialOtp!.trim());
      });
    }
  }

  void _onCompleted(String code) => setState(() => _code = code);

  void _submit() {
    if (_code.length < 6) return;
    context.read<OtpCubit>().verifyOtp(email: widget.email, code: _code);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpCubit, OtpState>(
      listenWhen: (_, state) => state is OtpFailure,
      listener: (_, __) {
        _otpRowKey.currentState?.clear();
        setState(() => _code = '');
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppSpacing.h32,
              AuthGradientTitle(
                text: AppLocalizations.of(context).enterOtpTitle,
                fontSize: 28,
                textAlign: TextAlign.center,
              ),
              AppSpacing.h12,
              OtpEmailLabel(email: widget.email),
              AppSpacing.h24,
              if (widget.initialOtp != null && widget.initialOtp!.trim().isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.mark_email_read_outlined,
                          color: AppColors.primary, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'رمز التحقق الخاص بك: ${widget.initialOtp!.trim()}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _otpRowKey.currentState?.setCode(widget.initialOtp!.trim());
                          setState(() => _code = widget.initialOtp!.trim());
                        },
                        child: const Text('تعبئة الرمز',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
              OtpInputRow(
                key: _otpRowKey,
                length: 6,
                onCompleted: _onCompleted,
              ),
              AppSpacing.h32,
              BlocBuilder<OtpCubit, OtpState>(
                builder: (context, state) {
                  final isLoading = state is OtpLoading;
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.large,
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(
                              AppLocalizations.of(context).verifyOtp,
                              style: AppTextStyles.buttonLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
              AppSpacing.h24,
              OtpResendSection(email: widget.email),
              AppSpacing.h32,
            ],
          ),
        ),
      ),
    );
  }
}
