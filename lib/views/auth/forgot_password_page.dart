import 'package:flutter/material.dart';

import '../../utils/app_messenger.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import '../widgets/auth_page_shell.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({required this.controller, super.key});

  final AuthController controller;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final identifier = _identifierController.text.trim();
    final success =
        await widget.controller.sendPasswordResetCode(identifier);

    if (!mounted) return;
    if (success) {
      final code = widget.controller.lastSentResetCode ?? '123456';
      AppMessenger.success('تم إرسال رمز التحقق التجريبي: $code');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ResetPasswordPage(
            controller: widget.controller,
            identifier: identifier,
          ),
        ),
      );
    } else {
      AppMessenger.error(
        widget.controller.errorMessage ?? 'تعذر إرسال رمز التحقق.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return AuthPageShell(
          title: 'استعادة كلمة المرور',
          subtitle: 'لا تقلق، سنساعدك على استعادة الوصول إلى حسابك.',
          icon: Icons.mark_email_read_outlined,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4F7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD7E9EF)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF176B87),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'أدخل بريدك الجامعي أو رقمك الأكاديمي. سنرسل إليك رمز تحقق لإكمال إعادة تعيين كلمة المرور.',
                          style: TextStyle(
                            color: Color(0xFF385B6B),
                            fontSize: 12,
                            height: 1.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                AuthTextField(
                  controller: _identifierController,
                  label: 'البريد أو الرقم الأكاديمي',
                  hint: 'أدخل البريد أو الرقم الأكاديمي',
                  prefixIcon: Icons.person_search_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidators.validateLoginIdentifier,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 22),
                AuthPrimaryButton(
                  label: 'إرسال رمز التحقق',
                  isLoading: widget.controller.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text('العودة إلى تسجيل الدخول'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
