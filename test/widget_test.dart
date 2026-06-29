import 'package:flutter_test/flutter_test.dart';

import 'package:finwise/main.dart';

void main() {
  testWidgets('Dashboard renders balance and breakdown', (WidgetTester tester) async {
    await tester.pumpWidget(const FinWiseApp());

    expect(find.text('Total balance'), findsOneWidget);
    expect(find.text('Spending breakdown'), findsOneWidget);
  });
}
