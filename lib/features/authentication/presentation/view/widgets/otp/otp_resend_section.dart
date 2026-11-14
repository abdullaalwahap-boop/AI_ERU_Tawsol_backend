import 'dart:async';

import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/otp_cubit/otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpResendSection extends StatefulWidget {
  const OtpResendSection({super.key, required this.email});

  final String email;

  @override
  State<OtpResendSection> createState() => _OtpResendSectionState();
}

class _OtpResendSectionState extends State<OtpResendSection> {
  int _seconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_seconds <= 0) {
        _timer?.cancel();
        return;
      }
      if (mounted) setState(() => _seconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = AppLocalizations.of(context);
    return BlocListener<OtpCubit, OtpState>(
      listenWhen: (_, state) => state is OtpInitial,
      listener: (_, __) => _startTimer(),
      child: _seconds > 0
          ? Text(
              isAr ? 'إعادة الإرسال خلال $_seconds ثانية' : 'Resend code in ${_seconds}s',
              textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white38,
                letterSpacing: 0.0,
              ),
            )
          : TextButton(
              onPressed: () =>
                  context.read<OtpCubit>().resendOtp(email: widget.email),
              child: Text(
                l10n.resendOtp,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.accent,
                  letterSpacing: 0.0,
                ),
              ),
            ),
    );
  }
}
