import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slides/features/main_slide/main_slide.dart';
import 'package:slides/features/slide_selector/slide_selector.dart';

class SlideSelectorView extends StatelessWidget {
  const SlideSelectorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Presentation JSON')),
      body: BlocConsumer<SlideSelectorBloc, SlideSelectorState>(
        listener: (context, state) {
          if (state.selectedFile != null) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => MainSlidePage(assetPath: state.selectedFile),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == SlideSelectorStatus.loading ||
              state.status == SlideSelectorStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.jsonFiles.isEmpty) {
            return const Center(
              child: Text('No presentation JSON files found in assets.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.jsonFiles.length,
            itemBuilder: (context, index) {
              final filePath = state.jsonFiles[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.slideshow),
                  title: Text(filePath),
                  subtitle: const Text('Tap to open presentation'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    context.read<SlideSelectorBloc>().add(
                          SlideSelectorFileSelected(filePath),
                        );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
