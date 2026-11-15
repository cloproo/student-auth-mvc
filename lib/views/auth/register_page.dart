import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_messenger.dart';
import '../../controllers/auth_controller.dart';
import '../../models/register_request.dart';
import '../../utils/form_validators.dart';
import '../widgets/auth_page_shell.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({required this.controller, super.key});

  final AuthController controller;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _academicIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _academicIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await widget.controller.register(
      RegisterRequest(
        fullName: _nameController.text.trim(),
        academicId: _academicIdController.text.trim(),
        universityEmail: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );

    if (!mounted) return;
    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => LoginPage(controller: widget.controller),
        ),
        (route) => false,
      );
      AppMessenger.success('تم إنشاء الحساب. يمكنك تسجيل الدخول الآن.');
    } else {
      AppMessenger.error(widget.controller.errorMessage ?? 'تعذر إنشاء الحساب.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return AuthPageShell(
          title: 'إنشاء حساب جديد',
          subtitle: 'أدخل بياناتك الأكاديمية لإنشاء حسابك الطلابي.',
          icon: Icons.person_add_alt_1_rounded,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthTextField(
                  controller: _nameController,
                  label: 'الاسم الكامل',
                  hint: 'اكتب اسمك الكامل',
                  prefixIcon: Icons.badge_outlined,
                  validator: FormValidators.validateFullName,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 15),
                AuthTextField(
                  controller: _academicIdController,
                  label: 'الرقم الأكاديمي',
                  hint: '9 إلى 10 أرقام',
                  prefixIcon: Icons.numbers_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  validator: FormValidators.validateAcademicId,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 15),
                AuthTextField(
                  controller: _emailController,
                  label: 'البريد الجامعي',
                  hint: 'name@university.edu',
                  prefixIcon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidators.validateEmail,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 15),
                AuthTextField(
                  controller: _passwordController,
                  label: 'كلمة المرور',
                  hint: '8 محارف على الأقل مع رقم وحرف كبير',
                  prefixIcon: Icons.lock_outline_rounded,
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
                  label: 'تأكيد كلمة المرور',
                  hint: 'أعد كتابة كلمة المرور',
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
                const SizedBox(height: 12),
                FormField<bool>(
                  initialValue: false,
                  validator: FormValidators.validateTerms,
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CheckboxListTile(
                          value: field.value ?? false,
                          onChanged: field.didChange,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: const Color(0xFF176B87),
                          title: const Text(
                            'أوافق على اللوائح والشروط الأكاديمية.',
                            style: TextStyle(
                              color: Color(0xFF59677D),
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                        if (field.hasError)
                          Padding(
                            padding: const EdgeInsets.only(right: 12, bottom: 8),
                            child: Text(
                              field.errorText!,
                              style: const TextStyle(
                                color: Color(0xFFD64545),
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                AuthPrimaryButton(
                  label: 'إنشاء الحساب',
                  isLoading: widget.controller.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('لديك حساب بالفعل؟ تسجيل الدخول'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
