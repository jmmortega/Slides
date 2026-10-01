import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slides/features/slide_selector/slide_selector.dart';

class SlideSelectorPage extends StatelessWidget {
  const SlideSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SlideSelectorBloc()..add(const SlideSelectorStarted()),
      child: const SlideSelectorView(),
    );
  }
}
