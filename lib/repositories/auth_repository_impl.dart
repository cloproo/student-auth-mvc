import '../models/auth_exception.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// In-memory repository that simulates remote authentication requests.
/// Replace this implementation with an API-backed repository in production.
class AuthRepositoryImpl implements AuthRepository {
  static const String demoOtp = '123456';
  static const Duration _networkDelay = Duration(milliseconds: 650);

  final Map<String, UserModel> _usersByAcademicId = {};
  final Map<String, UserModel> _usersByEmail = {};
  final Map<String, String> _passwordsByAcademicId = {};
  final Map<String, String> _resetCodesByAcademicId = {};

  Future<void> _simulateNetwork() => Future<void>.delayed(_networkDelay);

  String _normalize(String value) => value.trim().toLowerCase();

  UserModel? _findUser(String identifier) {
    final normalized = _normalize(identifier);
    if (normalized.contains('@')) {
      return _usersByEmail[normalized];
    }
    return _usersByAcademicId[normalized];
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    await _simulateNetwork();

    final academicId = _normalize(request.academicId);
    final email = _normalize(request.universityEmail);

    if (_usersByAcademicId.containsKey(academicId)) {
      throw const AuthException('هذا الرقم الأكاديمي مسجل مسبقًا.');
    }
    if (_usersByEmail.containsKey(email)) {
      throw const AuthException('هذا البريد الإلكتروني مسجل مسبقًا.');
    }

    final user = UserModel(
      fullName: request.fullName.trim(),
      academicId: academicId,
      universityEmail: email,
      createdAt: DateTime.now(),
    );

    _usersByAcademicId[academicId] = user;
    _usersByEmail[email] = user;
    _passwordsByAcademicId[academicId] = request.password;
    return user;
  }

  @override
  Future<UserModel> login(LoginRequest request) async {
    await _simulateNetwork();

    final user = _findUser(request.identifier);
    if (user == null ||
        _passwordsByAcademicId[user.academicId] != request.password) {
      throw const AuthException('المعرف أو كلمة المرور غير صحيحة.');
    }

    // Remember-me is received by the repository as required. Persistent
    // storage is intentionally omitted because external packages are banned.
    return user;
  }

  @override
  Future<String> sendPasswordResetCode(String identifier) async {
    await _simulateNetwork();

    final user = _findUser(identifier);
    if (user == null) {
      throw const AuthException('لم نعثر على حساب مطابق لهذه البيانات.');
    }

    _resetCodesByAcademicId[user.academicId] = demoOtp;
    return demoOtp;
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await _simulateNetwork();

    final user = _findUser(request.identifier);
    if (user == null) {
      throw const AuthException('الحساب المطلوب غير موجود.');
    }

    final savedCode = _resetCodesByAcademicId[user.academicId];
    if (savedCode == null || savedCode != request.otp) {
      throw const AuthException('رمز التحقق غير صحيح أو منتهي الصلاحية.');
    }

    _passwordsByAcademicId[user.academicId] = request.newPassword;
    _resetCodesByAcademicId.remove(user.academicId);
  }
}
