import 'package:flutter/material.dart';

/// Emotion states (exactly 4)
enum Emotion { bad, ugh, ok, good }

extension EmotionProps on Emotion {
  int get index {
    switch (this) {
      case Emotion.bad:
        return 0;
      case Emotion.ugh:
        return 1;
      case Emotion.ok:
        return 2;
      case Emotion.good:
        return 3;
    }
  }

  String get label {
    switch (this) {
      case Emotion.bad:
        return 'Bad';
      case Emotion.ugh:
        return 'Ugh';
      case Emotion.ok:
        return 'Ok';
      case Emotion.good:
        return 'Good';
    }
  }

  String get emoji {
    switch (this) {
      case Emotion.bad:
        return '😠';
      case Emotion.ugh:
        return '😕';
      case Emotion.ok:
        return '😐';
      case Emotion.good:
        return '🙂';
    }
  }
}

class EmotionScheme {
  // Discrete color stops for each emotion
  static const List<Color> startColors = [
    Color(0xFF3B3A98), // bad - deep muted
    Color(0xFF6E6C9A), // ugh
    Color(0xFF8FB0C9), // ok
    Color(0xFFBCE5B5), // good
  ];

  static const List<Color> endColors = [
    Color(0xFF7B2CBF),
    Color(0xFF9EA3D8),
    Color(0xFFCDE7F7),
    Color(0xFFFFF1B6),
  ];

  static const List<Color> strokeColors = [
    Color(0xFF352E6C),
    Color(0xFF51507A),
    Color(0xFF5D7B8F),
    Color(0xFF6AA84F),
  ];

  /// Interpolate color between emotion indices using position [pos] in 0..3
  static Color lerpStart(double pos) {
    final clamped = pos.clamp(0.0, 3.0);
    final i = clamped.floor();
    final t = clamped - i;
    if (i >= startColors.length - 1) return startColors.last;
    return Color.lerp(startColors[i], startColors[i + 1], t)!;
  }

  static Color lerpEnd(double pos) {
    final clamped = pos.clamp(0.0, 3.0);
    final i = clamped.floor();
    final t = clamped - i;
    if (i >= endColors.length - 1) return endColors.last;
    return Color.lerp(endColors[i], endColors[i + 1], t)!;
  }

  static Color lerpStroke(double pos) {
    final clamped = pos.clamp(0.0, 3.0);
    final i = clamped.floor();
    final t = clamped - i;
    if (i >= strokeColors.length - 1) return strokeColors.last;
    return Color.lerp(strokeColors[i], strokeColors[i + 1], t)!;
  }
}
