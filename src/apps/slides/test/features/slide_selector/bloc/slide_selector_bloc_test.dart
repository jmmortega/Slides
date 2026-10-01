import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slides/features/slide_selector/slide_selector.dart';

void main() {
  group('SlideSelectorBloc', () {
    test('initial state is SlideSelectorState', () {
      expect(
        SlideSelectorBloc().state,
        equals(const SlideSelectorState()),
      );
    });

    blocTest<SlideSelectorBloc, SlideSelectorState>(
      'emits success when SlideSelectorFileSelected is added',
      build: SlideSelectorBloc.new,
      act: (bloc) => bloc.add(const SlideSelectorFileSelected('assets/first_gdg.json')),
      expect: () => [
        const SlideSelectorState(selectedFile: 'assets/first_gdg.json'),
      ],
    );
  });
}
