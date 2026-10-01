part of 'main_slide_bloc.dart';

enum MainSlideStatus { initial, loading, success, failure }

class MainSlideState extends Equatable {
  const MainSlideState({
    this.status = MainSlideStatus.initial,
    this.slides = const [],
    this.currentIndex = 0,
    this.showNavigationControls = true,
    this.design = const SlideDesign(),
  });

  final MainSlideStatus status;
  final List<Slide> slides;
  final int currentIndex;
  final bool showNavigationControls;
  final SlideDesign design;

  MainSlideState copyWith({
    MainSlideStatus? status,
    List<Slide>? slides,
    int? currentIndex,
    bool? showNavigationControls,
    SlideDesign? design,
  }) {
    return MainSlideState(
      status: status ?? this.status,
      slides: slides ?? this.slides,
      currentIndex: currentIndex ?? this.currentIndex,
      showNavigationControls:
          showNavigationControls ?? this.showNavigationControls,
      design: design ?? this.design,
    );
  }

  @override
  List<Object?> get props => [
        status,
        slides,
        currentIndex,
        showNavigationControls,
        design,
      ];
}
