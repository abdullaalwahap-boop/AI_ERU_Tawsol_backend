import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/otp_cubit/otp_cubit.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/otp/otp_listener.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/shared/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(getIt<AuthRepo>()),
      child: AuthScaffold(
        body: OtpListener(email: email),
      ),
    );
  }
}
