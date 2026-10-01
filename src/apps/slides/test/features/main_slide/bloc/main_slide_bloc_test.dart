import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slides/features/main_slide/main_slide.dart';

void main() {
  group('MainSlideBloc', () {
    const testSlides = [
      Slide(id: '1', title: 'Slide 1', content: 'Content 1'),
      Slide(id: '2', title: 'Slide 2', content: 'Content 2'),
    ];

    test('initial state is MainSlideState', () {
      expect(
        MainSlideBloc().state,
        equals(const MainSlideState()),
      );
    });

    blocTest<MainSlideBloc, MainSlideState>(
      'emits [loading, success] when MainSlideStarted '
      'is added with localSlides',
      build: () => MainSlideBloc(localSlides: testSlides),
      act: (bloc) => bloc.add(const MainSlideStarted()),
      expect: () => [
        const MainSlideState(status: MainSlideStatus.loading),
        const MainSlideState(
          status: MainSlideStatus.success,
          slides: testSlides,
        ),
      ],
    );

    blocTest<MainSlideBloc, MainSlideState>(
      'updates currentIndex when MainSlideIndexChanged is added',
      build: () => MainSlideBloc(localSlides: testSlides),
      seed: () => const MainSlideState(
        status: MainSlideStatus.success,
        slides: testSlides,
      ),
      act: (bloc) => bloc.add(const MainSlideIndexChanged(1)),
      expect: () => [
        const MainSlideState(
          status: MainSlideStatus.success,
          slides: testSlides,
          currentIndex: 1,
        ),
      ],
    );
  });
}
