part of 'slide_selector_bloc.dart';

abstract class SlideSelectorEvent extends Equatable {
  const SlideSelectorEvent();

  @override
  List<Object?> get props => [];
}

class SlideSelectorStarted extends SlideSelectorEvent {
  const SlideSelectorStarted();
}

class SlideSelectorFileSelected extends SlideSelectorEvent {
  const SlideSelectorFileSelected(this.filePath);

  final String filePath;

  @override
  List<Object?> get props => [filePath];
}
