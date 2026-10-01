import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'slide_selector_event.dart';
part 'slide_selector_state.dart';

class SlideSelectorBloc extends Bloc<SlideSelectorEvent, SlideSelectorState> {
  SlideSelectorBloc() : super(const SlideSelectorState()) {
    on<SlideSelectorStarted>(_onStarted);
    on<SlideSelectorFileSelected>(_onFileSelected);
  }

  Future<void> _onStarted(
    SlideSelectorStarted event,
    Emitter<SlideSelectorState> emit,
  ) async {
    emit(state.copyWith(status: SlideSelectorStatus.loading));
    try {
      final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final assets = assetManifest.listAssets();
      final jsonFiles = assets
          .where((path) => path.endsWith('.json'))
          .toList();

      if (jsonFiles.isEmpty) {
        jsonFiles.add('assets/first_gdg.json');
      }

      emit(
        state.copyWith(
          status: SlideSelectorStatus.success,
          jsonFiles: jsonFiles,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: SlideSelectorStatus.success,
          jsonFiles: ['assets/first_gdg.json'],
        ),
      );
    }
  }

  void _onFileSelected(
    SlideSelectorFileSelected event,
    Emitter<SlideSelectorState> emit,
  ) {
    emit(state.copyWith(selectedFile: event.filePath));
  }
}
