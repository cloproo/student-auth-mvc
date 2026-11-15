class UserModel {
  const UserModel({
    required this.fullName,
    required this.academicId,
    required this.universityEmail,
    required this.createdAt,
  });

  final String fullName;
  final String academicId;
  final String universityEmail;
  final DateTime createdAt;
}
