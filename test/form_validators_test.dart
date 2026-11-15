import 'package:flutter_test/flutter_test.dart';
import 'package:student_auth_mvc/utils/form_validators.dart';

void main() {
  group('FormValidators', () {
    test('accepts a valid academic login identifier', () {
      expect(FormValidators.validateLoginIdentifier('202312345'), isNull);
    });

    test('rejects a short login identifier', () {
      expect(FormValidators.validateLoginIdentifier('123'), isNotNull);
    });

    test('accepts a valid email address', () {
      expect(FormValidators.validateEmail('student@university.edu'), isNull);
    });

    test('rejects an invalid email address', () {
      expect(FormValidators.validateEmail('student@university'), isNotNull);
    });

    test('accepts academic IDs containing 9 or 10 digits', () {
      expect(FormValidators.validateAcademicId('123456789'), isNull);
      expect(FormValidators.validateAcademicId('1234567890'), isNull);
    });

    test('rejects academic IDs with non-digit characters', () {
      expect(FormValidators.validateAcademicId('12345A789'), isNotNull);
    });

    test('enforces password length, number, and uppercase letter', () {
      expect(FormValidators.validatePassword('Student123'), isNull);
      expect(FormValidators.validatePassword('student123'), isNotNull);
      expect(FormValidators.validatePassword('Studentabc'), isNotNull);
      expect(FormValidators.validatePassword('St1'), isNotNull);
    });

    test('requires exact password confirmation', () {
      expect(
        FormValidators.validateConfirmPassword('Student123', 'Student123'),
        isNull,
      );
      expect(
        FormValidators.validateConfirmPassword('student123', 'Student123'),
        isNotNull,
      );
    });

    test('accepts exactly six numeric OTP digits', () {
      expect(FormValidators.validateOtp('123456'), isNull);
      expect(FormValidators.validateOtp('12345'), isNotNull);
      expect(FormValidators.validateOtp('12A456'), isNotNull);
    });

    test('requires academic terms acceptance', () {
      expect(FormValidators.validateTerms(true), isNull);
      expect(FormValidators.validateTerms(false), isNotNull);
      expect(FormValidators.validateTerms(null), isNotNull);
    });
  });
}
