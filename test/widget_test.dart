import 'package:flutter_test/flutter_test.dart';
import 'package:student_auth_mvc/app.dart';

void main() {
  testWidgets('application opens on the student login screen', (tester) async {
    await tester.pumpWidget(const StudentAuthApp());

    expect(find.text('بوابة الطالب'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsWidgets);
    expect(find.text('إنشاء حساب جديد'), findsOneWidget);
  });
}
