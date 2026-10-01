import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SlideDesign extends Equatable {
  const SlideDesign({
    this.logos = const [],
    this.backgroundColor,
  });

  factory SlideDesign.fromJson(Map<String, dynamic> json) {
    return SlideDesign(
      logos: (json['logos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      backgroundColor: json['backgroundColor'] as String?,
    );
  }

  final List<String> logos;
  final String? backgroundColor;

  Color? get parsedBackgroundColor {
    final hexString = backgroundColor;
    if (hexString == null || hexString.isEmpty) return null;
    var hex = hexString.replaceAll('#', '').replaceAll('0x', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    final val = int.tryParse(hex, radix: 16);
    if (val != null) {
      return Color(val);
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        'logos': logos,
        'backgroundColor': backgroundColor,
      };

  @override
  List<Object?> get props => [logos, backgroundColor];
}
