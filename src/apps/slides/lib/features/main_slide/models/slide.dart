import 'package:equatable/equatable.dart';

class Slide extends Equatable {
  const Slide({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
  });

  factory Slide.fromJson(Map<String, dynamic> json) {
    return Slide(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
    );
  }

  final String id;
  final String title;
  final String content;
  final String? imageUrl;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
      };

  @override
  List<Object?> get props => [id, title, content, imageUrl];
}
