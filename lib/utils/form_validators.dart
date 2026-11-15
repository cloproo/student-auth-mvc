/// Pure form-validation functions. These methods do not depend on Flutter UI.
class FormValidators {
  FormValidators._();

  static final RegExp _emailPattern =
      RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
  static final RegExp _loginIdPattern =
      RegExp(r'^[A-Za-z0-9][A-Za-z0-9._-]*$');
  static final RegExp _academicIdPattern = RegExp(r'^\d{9,10}$');
  static final RegExp _otpPattern = RegExp(r'^\d{6}$');
  static final RegExp _numberPattern = RegExp(r'\d');
  static final RegExp _uppercasePattern = RegExp(r'[A-Z]');

  static String? validateFullName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'يرجى إدخال الاسم الكامل.';
    if (name.length < 3) return 'يجب ألا يقل الاسم عن 3 أحرف.';
    return null;
  }

  static String? validateLoginIdentifier(String? value) {
    final identifier = value?.trim() ?? '';
    if (identifier.isEmpty) return 'يرجى إدخال المعرف الأكاديمي أو البريد.';
    if (identifier.length < 5) return 'يجب ألا يقل المعرف عن 5 خانات.';

    if (identifier.contains('@')) {
      return validateEmail(identifier);
    }
    if (!_loginIdPattern.hasMatch(identifier)) {
      return 'استخدم الحروف والأرقام والرموز (.-_) فقط.';
    }
    return null;
  }

  static String? validateAcademicId(String? value) {
    final id = value?.trim() ?? '';
    if (id.isEmpty) return 'يرجى إدخال الرقم الأكاديمي.';
    if (!_academicIdPattern.hasMatch(id)) {
      return 'الرقم الأكاديمي يجب أن يتكون من 9 إلى 10 أرقام.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'يرجى إدخال البريد الإلكتروني.';
    if (!_emailPattern.hasMatch(email)) {
      return 'يرجى إدخال بريد إلكتروني صحيح.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'يرجى إدخال كلمة المرور.';
    if (password.length < 8) return 'يجب أن تتكون كلمة المرور من 8 محارف على الأقل.';
    if (!_numberPattern.hasMatch(password)) {
      return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل.';
    }
    if (!_uppercasePattern.hasMatch(password)) {
      return 'يجب أن تحتوي كلمة المرور على حرف إنجليزي كبير واحد على الأقل.';
    }
    return null;
  }

  static String? validateLoginPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'يرجى إدخال كلمة المرور.';
    if (password.length < 6) return 'يجب ألا تقل كلمة المرور عن 6 محارف.';
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور.';
    }
    if (value != originalPassword) return 'كلمتا المرور غير متطابقتين.';
    return null;
  }

  static String? validateOtp(String? value) {
    final otp = value?.trim() ?? '';
    if (otp.isEmpty) return 'يرجى إدخال رمز التحقق.';
    if (!_otpPattern.hasMatch(otp)) {
      return 'رمز التحقق يجب أن يتكون من 6 أرقام.';
    }
    return null;
  }

  static String? validateTerms(bool? accepted) {
    if (accepted != true) return 'يجب الموافقة على اللوائح والشروط الأكاديمية.';
    return null;
  }
}
