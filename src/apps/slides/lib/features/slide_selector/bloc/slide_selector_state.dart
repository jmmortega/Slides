part of 'slide_selector_bloc.dart';

enum SlideSelectorStatus { initial, loading, success, failure }

class SlideSelectorState extends Equatable {
  const SlideSelectorState({
    this.status = SlideSelectorStatus.initial,
    this.jsonFiles = const [],
    this.selectedFile,
  });

  final SlideSelectorStatus status;
  final List<String> jsonFiles;
  final String? selectedFile;

  SlideSelectorState copyWith({
    SlideSelectorStatus? status,
    List<String>? jsonFiles,
    String? selectedFile,
  }) {
    return SlideSelectorState(
      status: status ?? this.status,
      jsonFiles: jsonFiles ?? this.jsonFiles,
      selectedFile: selectedFile ?? this.selectedFile,
    );
  }

  @override
  List<Object?> get props => [status, jsonFiles, selectedFile];
}
