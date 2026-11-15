import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_messenger.dart';
import '../../controllers/auth_controller.dart';
import '../../models/reset_password_request.dart';
import '../../utils/form_validators.dart';
import '../widgets/auth_page_shell.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import 'login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    required this.controller,
    required this.identifier,
    super.key,
  });

  final AuthController controller;
  final String identifier;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await widget.controller.resetPassword(
      ResetPasswordRequest(
        identifier: widget.identifier,
        otp: _otpController.text.trim(),
        newPassword: _passwordController.text,
      ),
    );

    if (!mounted) return;
    if (!success) {
      AppMessenger.error(
        widget.controller.errorMessage ?? 'تعذر تحديث كلمة المرور.',
      );
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF198754),
            size: 42,
          ),
          title: const Text('تم تحديث كلمة المرور'),
          content: const Text(
            'أصبحت كلمة المرور الجديدة فعّالة. يمكنك الآن تسجيل الدخول إلى حسابك.',
            textAlign: TextAlign.center,
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('الانتقال إلى تسجيل الدخول'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => LoginPage(controller: widget.controller),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return AuthPageShell(
          title: 'تعيين كلمة مرور جديدة',
          subtitle: 'أدخل رمز التحقق ثم اختر كلمة مرور جديدة لحسابك.',
          icon: Icons.password_rounded,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F7FA),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    'الحساب: ${widget.identifier}',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 17),
                AuthTextField(
                  controller: _otpController,
                  label: 'رمز التحقق (OTP)',
                  hint: 'أدخل الرمز المكوّن من 6 أرقام',
                  prefixIcon: Icons.pin_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  maxLength: 6,
                  validator: FormValidators.validateOtp,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 15),
                AuthTextField(
                  controller: _passwordController,
                  label: 'كلمة المرور الجديدة',
                  hint: '8 محارف على الأقل مع رقم وحرف كبير',
                  prefixIcon: Icons.lock_reset_rounded,
                  obscureText: _obscurePassword,
                  validator: FormValidators.validatePassword,
                  textInputAction: TextInputAction.next,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      _obscurePassword = !_obscurePassword;
                    }),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                AuthTextField(
                  controller: _confirmPasswordController,
                  label: 'تأكيد كلمة المرور الجديدة',
                  hint: 'أعد كتابة كلمة المرور الجديدة',
                  prefixIcon: Icons.verified_user_outlined,
                  obscureText: _obscureConfirmPassword,
                  validator: (value) => FormValidators.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    }),
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                AuthPrimaryButton(
                  label: 'تحديث كلمة المرور',
                  isLoading: widget.controller.isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
