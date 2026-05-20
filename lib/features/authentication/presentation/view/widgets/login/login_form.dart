import 'package:ai_eru_tawasol/core/services/local_storage_services.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/constants/auth_colors.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/helpers/auth_validators.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/manager/login_cubit/login_cubit.dart';
import 'package:ai_eru_tawasol/features/authentication/presentation/view/widgets/shared/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _storage = LocalStorageService();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final remembered = await _storage.getRememberMe();
    if (!remembered) return;
    final email = await _storage.getSavedEmail();
    if (!mounted) return;
    setState(() {
      _rememberMe = true;
      _emailCtrl.text = email;
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    if (_rememberMe) {
      await _storage.saveRememberMe(true);
      await _storage.saveEmail(_emailCtrl.text.trim());
    } else {
      await _storage.saveRememberMe(false);
      await _storage.clearSavedEmail();
    }
    if (!mounted) return;
    context.read<LoginCubit>().login(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            AuthTextField(
              controller: _emailCtrl,
              label: 'University Email',
              prefixIcon: Icons.alternate_email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: AuthValidators.email,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _passwordCtrl,
              label: 'Password',
              prefixIcon: Icons.lock_outline_rounded,
              obscurable: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: AuthValidators.password,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    onChanged: (v) => setState(() => _rememberMe = v ?? false),
                    activeColor: AuthColors.primary,
                    side: const BorderSide(color: Colors.white38, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Remember me',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push(AppRouter.kForgetPasswordView),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.plusJakartaSans(
                      color: AuthColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                final isLoading = state is LoginLoading;
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AuthColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            'Sign In',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
