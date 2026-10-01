import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slides/features/main_slide/main_slide.dart';

class MainSlidePage extends StatelessWidget {
  const MainSlidePage({
    super.key,
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainSlideBloc(
        assetPath: assetPath,
        localSlides: localSlides,
        localDesign: localDesign,
        showNavigationControls: showNavigationControls,
      )..add(
          MainSlideStarted(
            assetPath: assetPath,
            localSlides: localSlides,
            localDesign: localDesign,
            showNavigationControls: showNavigationControls,
          ),
        ),
      child: const MainSlideView(),
    );
  }
}
