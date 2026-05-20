import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
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
  const OtpViewBody({super.key, required this.email});

  final String email;

  @override
  State<OtpViewBody> createState() => _OtpViewBodyState();
}

class _OtpViewBodyState extends State<OtpViewBody> {
  final _otpRowKey = GlobalKey<OtpInputRowState>();
  String _code = '';

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
              const AuthGradientTitle(
                text: 'Enter OTP',
                fontSize: 28,
                textAlign: TextAlign.center,
              ),
              AppSpacing.h12,
              OtpEmailLabel(email: widget.email),
              AppSpacing.h36,
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
                              'Verify OTP',
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
