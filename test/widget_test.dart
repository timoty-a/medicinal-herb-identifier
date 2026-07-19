import 'package:flutter_test/flutter_test.dart';

import 'package:medicinal_herb_identifier/main.dart';

void main() {
  testWidgets('HerbAI home screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MedicinalHerbApp());

    expect(find.text('HerbAI'), findsOneWidget);
    expect(find.text('Identify Plants'), findsOneWidget);
  });
}
