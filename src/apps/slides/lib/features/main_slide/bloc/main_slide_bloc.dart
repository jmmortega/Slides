import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:slides/features/main_slide/models/slide.dart';
import 'package:slides/features/main_slide/models/slide_design.dart';

part 'main_slide_event.dart';
part 'main_slide_state.dart';

class MainSlideBloc extends Bloc<MainSlideEvent, MainSlideState> {
  MainSlideBloc({
    this.assetPath,
    this.localSlides,
    this.localDesign,
    this.assetBundle,
    this.showNavigationControls = true,
  }) : super(MainSlideState(showNavigationControls: showNavigationControls)) {
    on<MainSlideStarted>(_onStarted);
    on<MainSlideIndexChanged>(_onIndexChanged);
  }

  final String? assetPath;
  final List<Slide>? localSlides;
  final SlideDesign? localDesign;
  final AssetBundle? assetBundle;
  final bool showNavigationControls;

  Future<void> _onStarted(
    MainSlideStarted event,
    Emitter<MainSlideState> emit,
  ) async {
    emit(state.copyWith(status: MainSlideStatus.loading));
    try {
      var slides = <Slide>[];
      var design = const SlideDesign();

      final eventLocalSlides = event.localSlides;
      final blocLocalSlides = localSlides;
      final eventLocalDesign = event.localDesign;
      final blocLocalDesign = localDesign;

      if (eventLocalDesign != null) {
        design = eventLocalDesign;
      } else if (blocLocalDesign != null) {
        design = blocLocalDesign;
      }

      if (eventLocalSlides != null && eventLocalSlides.isNotEmpty) {
        slides = eventLocalSlides;
      } else if (blocLocalSlides != null && blocLocalSlides.isNotEmpty) {
        slides = blocLocalSlides;
      } else {
        final path = event.assetPath ?? assetPath ?? 'assets/first_gdg.json';
        final bundle = assetBundle ?? rootBundle;
        final jsonString = await bundle.loadString(path);
        final decoded = json.decode(jsonString);

        if (decoded is Map<String, dynamic>) {
          if (decoded['design'] != null) {
            design = SlideDesign.fromJson(
              decoded['design'] as Map<String, dynamic>,
            );
          }
          final jsonList = decoded['slides'] as List<dynamic>? ?? [];
          slides = jsonList
              .map((e) => Slide.fromJson(e as Map<String, dynamic>))
              .toList();
        } else if (decoded is List<dynamic>) {
          slides = decoded
              .map((e) => Slide.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }

      if (slides.isEmpty) {
        slides = const [
          Slide(id: '1', title: 'Default Slide 1', content: 'Content 1'),
        ];
      }

      emit(
        state.copyWith(
          status: MainSlideStatus.success,
          slides: slides,
          currentIndex: 0,
          showNavigationControls: event.showNavigationControls,
          design: design,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: MainSlideStatus.failure));
    }
  }

  void _onIndexChanged(
    MainSlideIndexChanged event,
    Emitter<MainSlideState> emit,
  ) {
    if (event.index >= 0 && event.index < state.slides.length) {
      emit(state.copyWith(currentIndex: event.index));
    }
  }
}
