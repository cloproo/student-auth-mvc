import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(LoginRequest request);

  Future<UserModel> register(RegisterRequest request);

  Future<String> sendPasswordResetCode(String identifier);

  Future<void> resetPassword(ResetPasswordRequest request);
}
