import 'package:flutter/foundation.dart';

import '../models/auth_exception.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

/// MVC controller: coordinates view actions and repository operations.
class AuthController extends ChangeNotifier {
  AuthController({required AuthRepository repository})
      : _repository = repository;

  final AuthRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  String? _lastSentResetCode;
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get lastSentResetCode => _lastSentResetCode;
  UserModel? get currentUser => _currentUser;

  void _beginRequest() {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _finishRequest() {
    _isLoading = false;
    notifyListeners();
  }

  String _readError(Object error) {
    if (error is AuthException) return error.message;
    return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
  }

  Future<bool> login(LoginRequest request) async {
    _beginRequest();
    try {
      _currentUser = await _repository.login(request);
      _successMessage = 'تم تسجيل الدخول بنجاح.';
      return true;
    } catch (error) {
      _errorMessage = _readError(error);
      return false;
    } finally {
      _finishRequest();
    }
  }

  Future<bool> register(RegisterRequest request) async {
    _beginRequest();
    try {
      _currentUser = await _repository.register(request);
      _successMessage = 'تم إنشاء الحساب بنجاح.';
      return true;
    } catch (error) {
      _errorMessage = _readError(error);
      return false;
    } finally {
      _finishRequest();
    }
  }

  Future<bool> sendPasswordResetCode(String identifier) async {
    _beginRequest();
    try {
      _lastSentResetCode =
          await _repository.sendPasswordResetCode(identifier);
      _successMessage = 'تم تجهيز رمز التحقق.';
      return true;
    } catch (error) {
      _lastSentResetCode = null;
      _errorMessage = _readError(error);
      return false;
    } finally {
      _finishRequest();
    }
  }

  Future<bool> resetPassword(ResetPasswordRequest request) async {
    _beginRequest();
    try {
      await _repository.resetPassword(request);
      _successMessage = 'تم تحديث كلمة المرور بنجاح.';
      _lastSentResetCode = null;
      return true;
    } catch (error) {
      _errorMessage = _readError(error);
      return false;
    } finally {
      _finishRequest();
    }
  }
}
