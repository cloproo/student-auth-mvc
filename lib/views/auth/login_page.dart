import 'package:flutter/material.dart';

import '../../utils/app_messenger.dart';
import '../../controllers/auth_controller.dart';
import '../../models/login_request.dart';
import '../../utils/form_validators.dart';
import '../widgets/auth_page_shell.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required this.controller, super.key});

  final AuthController controller;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await widget.controller.login(
      LoginRequest(
        identifier: _identifierController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      ),
    );

    if (!mounted) return;
    if (success) {
      AppMessenger.success(
        'مرحبًا ${widget.controller.currentUser?.fullName ?? ''}، تم تسجيل الدخول بنجاح.',
      );
    } else {
      AppMessenger.error(widget.controller.errorMessage ?? 'تعذر تسجيل الدخول.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return AuthPageShell(
          title: 'تسجيل الدخول',
          subtitle: 'سجّل دخولك إلى حسابك الأكاديمي للمتابعة.',
          icon: Icons.lock_open_rounded,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthTextField(
                  controller: _identifierController,
                  label: 'المعرف الأكاديمي أو البريد',
                  hint: 'أدخل المعرف أو البريد الإلكتروني',
                  prefixIcon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidators.validateLoginIdentifier,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 17),
                AuthTextField(
                  controller: _passwordController,
                  label: 'كلمة المرور',
                  hint: 'أدخل كلمة المرور',
                  prefixIcon: Icons.key_rounded,
                  obscureText: _obscurePassword,
                  validator: FormValidators.validateLoginPassword,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    tooltip: _obscurePassword ? 'إظهار كلمة المرور' : 'إخفاء كلمة المرور',
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
                const SizedBox(height: 9),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) => setState(() {
                        _rememberMe = value ?? false;
                      }),
                      activeColor: const Color(0xFF176B87),
                      visualDensity: VisualDensity.compact,
                    ),
                    const Text(
                      'تذكرني',
                      style: TextStyle(color: Color(0xFF59677D), fontSize: 13),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ForgotPasswordPage(
                              controller: widget.controller,
                            ),
                          ),
                        );
                      },
                      child: const Text('نسيت كلمة المرور؟'),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                AuthPrimaryButton(
                  label: 'تسجيل الدخول',
                  isLoading: widget.controller.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 22),
                Row(
                  children: const [
                    Expanded(child: Divider(color: Color(0xFFE6EBF1))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'ليس لديك حساب؟',
                        style: TextStyle(color: Color(0xFF8490A2), fontSize: 12),
                      ),
                    ),
                    Expanded(child: Divider(color: Color(0xFFE6EBF1))),
                  ],
                ),
                const SizedBox(height: 13),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => RegisterPage(
                          controller: widget.controller,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add_alt_1_rounded, size: 19),
                  label: const Text('إنشاء حساب جديد'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(51),
                    foregroundColor: const Color(0xFF176B87),
                    side: const BorderSide(color: Color(0xFFB9D1DA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
