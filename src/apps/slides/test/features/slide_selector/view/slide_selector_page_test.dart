import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:slides/features/slide_selector/slide_selector.dart';

import '../../../helpers/helpers.dart';

class MockSlideSelectorBloc
    extends MockBloc<SlideSelectorEvent, SlideSelectorState>
    implements SlideSelectorBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(const SlideSelectorStarted());
    registerFallbackValue(
      const SlideSelectorFileSelected('assets/first_gdg.json'),
    );
  });

  group('SlideSelectorPage', () {
    testWidgets('renders SlideSelectorView', (tester) async {
      await tester.pumpApp(const SlideSelectorPage());
      expect(find.byType(SlideSelectorView), findsOneWidget);
    });
  });

  group('SlideSelectorView', () {
    late SlideSelectorBloc slideSelectorBloc;

    setUp(() {
      slideSelectorBloc = MockSlideSelectorBloc();
    });

    testWidgets('renders CircularProgressIndicator when status is loading', (
      tester,
    ) async {
      when(() => slideSelectorBloc.state).thenReturn(
        const SlideSelectorState(status: SlideSelectorStatus.loading),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: slideSelectorBloc,
          child: const SlideSelectorView(),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders list of json files when status is success', (
      tester,
    ) async {
      when(() => slideSelectorBloc.state).thenReturn(
        const SlideSelectorState(
          status: SlideSelectorStatus.success,
          jsonFiles: ['assets/first_gdg.json'],
        ),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: slideSelectorBloc,
          child: const SlideSelectorView(),
        ),
      );
      expect(find.text('assets/first_gdg.json'), findsOneWidget);
    });

    testWidgets(
      'dispatches SlideSelectorFileSelected when list tile is tapped',
      (tester) async {
        when(() => slideSelectorBloc.state).thenReturn(
          const SlideSelectorState(
            status: SlideSelectorStatus.success,
            jsonFiles: ['assets/first_gdg.json'],
          ),
        );
        when(() => slideSelectorBloc.add(any())).thenReturn(null);

        await tester.pumpApp(
          BlocProvider.value(
            value: slideSelectorBloc,
            child: const SlideSelectorView(),
          ),
        );

        await tester.tap(find.text('assets/first_gdg.json'));
        verify(
          () => slideSelectorBloc.add(
            const SlideSelectorFileSelected('assets/first_gdg.json'),
          ),
        ).called(1);
      },
    );
  });
}
