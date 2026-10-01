part of 'main_slide_bloc.dart';

abstract class MainSlideEvent extends Equatable {
  const MainSlideEvent();

  @override
  List<Object?> get props => [];
}

class MainSlideStarted extends MainSlideEvent {
  const MainSlideStarted({
    this.assetPath,
    this.localSlides,
    this.localDesign,
    this.showNavigationControls = true,
  });

  final String? assetPath;
  final List<Slide>? localSlides;
  final SlideDesign? localDesign;
  final bool showNavigationControls;

  @override
  List<Object?> get props => [
        assetPath,
        localSlides,
        localDesign,
        showNavigationControls,
      ];
}

class MainSlideIndexChanged extends MainSlideEvent {
  const MainSlideIndexChanged(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}
