import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:slides/features/main_slide/main_slide.dart';

class MainSlideView extends StatefulWidget {
  const MainSlideView({super.key});

  @override
  State<MainSlideView> createState() => _MainSlideViewState();
}

class _MainSlideViewState extends State<MainSlideView> {
  late final PageController _pageController;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullscreen
          ? null
          : AppBar(
              title: BlocBuilder<MainSlideBloc, MainSlideState>(
                builder: (context, state) {
                  if (state.slides.isEmpty) {
                    return const Text('Slides');
                  }
                  return Text(state.slides[state.currentIndex].title);
                },
              ),
            ),
      body: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            final state = context.read<MainSlideBloc>().state;
            if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
                event.logicalKey == LogicalKeyboardKey.arrowDown) {
              if (state.currentIndex < state.slides.length - 1) {
                context.read<MainSlideBloc>().add(
                      MainSlideIndexChanged(state.currentIndex + 1),
                    );
              }
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
                event.logicalKey == LogicalKeyboardKey.arrowUp) {
              if (state.currentIndex > 0) {
                context.read<MainSlideBloc>().add(
                      MainSlideIndexChanged(state.currentIndex - 1),
                    );
              }
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.keyQ) {
              setState(() {
                _isFullscreen = !_isFullscreen;
                FullScreen.setFullScreen(_isFullscreen);
              });
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.escape) {
              if (_isFullscreen) {
                setState(() {
                  _isFullscreen = false;
                  FullScreen.setFullScreen(false);
                });
              } else {
                unawaited(SystemNavigator.pop());
              }
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: BlocConsumer<MainSlideBloc, MainSlideState>(
          listener: (context, state) {
            if (state.status == MainSlideStatus.success &&
                _pageController.hasClients) {
              if (_pageController.page?.round() != state.currentIndex) {
                _pageController.animateToPage(
                  state.currentIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }
          },
          builder: (context, state) {
            if (state.status == MainSlideStatus.loading ||
                state.status == MainSlideStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == MainSlideStatus.failure ||
                state.slides.isEmpty) {
              return const Center(child: Text('Failed to load slides.'));
            }

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: state.slides.length,
                    onPageChanged: (index) {
                      if (index != state.currentIndex) {
                        context.read<MainSlideBloc>().add(
                              MainSlideIndexChanged(index),
                            );
                      }
                    },
                    itemBuilder: (context, index) {
                      return _SlideItemView(
                        slide: state.slides[index],
                        design: state.design,
                      );
                    },
                  ),
                ),
                if (!_isFullscreen && state.showNavigationControls)
                  _SlideNavigationControls(
                    currentIndex: state.currentIndex,
                    totalSlides: state.slides.length,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SlideItemView extends StatelessWidget {
  const _SlideItemView({
    required this.slide,
    required this.design,
  });

  final Slide slide;
  final SlideDesign design;

  Widget _buildMarkdownImage(MarkdownImageConfig config) {
    final path = config.uri.toString();
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: config.width,
        height: config.height,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      );
    }
    return Image.asset(
      path,
      width: config.width,
      height: config.height,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = slide.imageUrl;
    final baseFontSize = (theme.textTheme.bodyLarge?.fontSize ?? 16.0) + 2.0;
    final backgroundColor = design.parsedBackgroundColor ?? Colors.black87;

    final markdownStyleSheet = MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: (theme.textTheme.bodyLarge ?? const TextStyle()).copyWith(
        color: Colors.white,
        fontSize: baseFontSize,
      ),
      h1: (theme.textTheme.headlineLarge ?? const TextStyle()).copyWith(
        color: Colors.white,
      ),
      h2: (theme.textTheme.headlineMedium ?? const TextStyle()).copyWith(
        color: Colors.white,
      ),
      h3: (theme.textTheme.headlineSmall ?? const TextStyle()).copyWith(
        color: Colors.white,
      ),
      h4: (theme.textTheme.titleLarge ?? const TextStyle()).copyWith(
        color: Colors.white,
      ),
      h5: (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
        color: Colors.white,
      ),
      h6: (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
        color: Colors.white,
      ),
      listBullet: TextStyle(
        color: Colors.white,
        fontSize: baseFontSize,
      ),
      strong: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      em: const TextStyle(
        color: Colors.white,
        fontStyle: FontStyle.italic,
      ),
      code: const TextStyle(
        color: Colors.white,
        backgroundColor: Colors.black45,
      ),
    );

    Widget contentWidget;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      contentWidget = Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl.startsWith('http'))
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            )
          else
            Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          Container(
            color: Colors.black.withValues(alpha: 0.4),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slide.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: MarkdownBody(
                          data: slide.content,
                          sizedImageBuilder: _buildMarkdownImage,
                          styleSheet: markdownStyleSheet,
                          selectable: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      contentWidget = ColoredBox(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                slide.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: MarkdownBody(
                        data: slide.content,
                        sizedImageBuilder: _buildMarkdownImage,
                        styleSheet: markdownStyleSheet,
                        selectable: true,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        contentWidget,
        if (design.logos.isNotEmpty)
          Positioned(
            right: 16,
            bottom: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: design.logos.map((logoUrl) {
                return Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: logoUrl.startsWith('http')
                        ? Image.network(
                            logoUrl,
                            height: 36,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          )
                        : Image.asset(
                            logoUrl,
                            height: 36,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _SlideNavigationControls extends StatelessWidget {
  const _SlideNavigationControls({
    required this.currentIndex,
    required this.totalSlides,
  });

  final int currentIndex;
  final int totalSlides;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: currentIndex > 0
                ? () {
                    context.read<MainSlideBloc>().add(
                          MainSlideIndexChanged(currentIndex - 1),
                        );
                  }
                : null,
            child: const Text('Previous'),
          ),
          Text('Slide ${currentIndex + 1} of $totalSlides'),
          ElevatedButton(
            onPressed: currentIndex < totalSlides - 1
                ? () {
                    context.read<MainSlideBloc>().add(
                          MainSlideIndexChanged(currentIndex + 1),
                        );
                  }
                : null,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
