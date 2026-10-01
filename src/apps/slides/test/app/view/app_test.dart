// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:slides/app/app.dart';
import 'package:slides/features/slide_selector/slide_selector.dart';

void main() {
  group('App', () {
    testWidgets('renders SlideSelectorPage', (tester) async {
      await tester.pumpWidget(App());
      expect(find.byType(SlideSelectorPage), findsOneWidget);
    });
  });
}
