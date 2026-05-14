import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ilac_getir/main.dart';

void main() {
  testWidgets('Dvita app starts with splash screen', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());

    expect(find.text('Dvita'), findsOneWidget);
  });
}
