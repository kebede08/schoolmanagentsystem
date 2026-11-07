import 'package:flutter_test/flutter_test.dart';
import 'package:school_management/main.dart';

void main() {
  testWidgets('App smoke test loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const EduPulseSchoolApp());
    expect(find.text('EduPulse SMS'), findsWidgets);
  });
}
