class LoginRequest {
  const LoginRequest({
    required this.identifier,
    required this.password,
    required this.rememberMe,
  });

  final String identifier;
  final String password;
  final bool rememberMe;
}
