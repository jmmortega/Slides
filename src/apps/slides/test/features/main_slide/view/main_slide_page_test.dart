import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:slides/features/main_slide/main_slide.dart';

import '../../../helpers/helpers.dart';

class MockMainSlideBloc extends MockBloc<MainSlideEvent, MainSlideState>
    implements MainSlideBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(const MainSlideStarted());
    registerFallbackValue(const MainSlideIndexChanged(0));
  });

  group('MainSlidePage', () {
    testWidgets('renders MainSlideView', (tester) async {
      await tester.pumpApp(
        const MainSlidePage(
          localSlides: [
            Slide(id: '1', title: 'Test Title', content: 'Test Content'),
          ],
        ),
      );
      expect(find.byType(MainSlideView), findsOneWidget);
    });
  });

  group('MainSlideView', () {
    late MainSlideBloc mainSlideBloc;
    const testSlides = [
      Slide(id: '1', title: 'Slide 1', content: 'Content 1'),
      Slide(id: '2', title: 'Slide 2', content: 'Content 2'),
    ];

    setUp(() {
      mainSlideBloc = MockMainSlideBloc();
    });

    testWidgets(
      'renders CircularProgressIndicator when status is loading',
      (tester) async {
        when(() => mainSlideBloc.state).thenReturn(
          const MainSlideState(status: MainSlideStatus.loading),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: mainSlideBloc,
            child: const MainSlideView(),
          ),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'renders slides and PageView when status is success',
      (tester) async {
        when(() => mainSlideBloc.state).thenReturn(
          const MainSlideState(
            status: MainSlideStatus.success,
            slides: testSlides,
          ),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: mainSlideBloc,
            child: const MainSlideView(),
          ),
        );
        expect(find.byType(PageView), findsOneWidget);
        expect(find.text('Slide 1'), findsWidgets);
        expect(find.text('Content 1'), findsWidgets);
      },
    );

    testWidgets(
      'renders background image when slide has imageUrl',
      (tester) async {
        const slideWithImage = Slide(
          id: '1',
          title: 'Image Slide',
          content: 'Content with image',
          imageUrl: 'assets/slide_bg.png',
        );
        when(() => mainSlideBloc.state).thenReturn(
          const MainSlideState(
            status: MainSlideStatus.success,
            slides: [slideWithImage],
          ),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: mainSlideBloc,
            child: const MainSlideView(),
          ),
        );
        expect(find.byType(Image), findsOneWidget);
        expect(find.text('Image Slide'), findsWidgets);
      },
    );

    testWidgets(
      'calls MainSlideIndexChanged when Next button is pressed',
      (tester) async {
        when(() => mainSlideBloc.state).thenReturn(
          const MainSlideState(
            status: MainSlideStatus.success,
            slides: testSlides,
          ),
        );
        when(() => mainSlideBloc.add(any())).thenReturn(null);

        await tester.pumpApp(
          BlocProvider.value(
            value: mainSlideBloc,
            child: const MainSlideView(),
          ),
        );

        await tester.tap(find.text('Next'));
        verify(
          () => mainSlideBloc.add(const MainSlideIndexChanged(1)),
        ).called(1);
      },
    );
  });
}
