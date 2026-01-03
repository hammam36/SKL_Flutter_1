import 'package:flutter/material.dart';
import '../models/emotion.dart';
import '../widgets/emoji_face.dart';
import '../widgets/emotion_selector.dart';

class EmojiFeedbackScreen extends StatefulWidget {
  const EmojiFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<EmojiFeedbackScreen> createState() => _EmojiFeedbackScreenState();
}

class _EmojiFeedbackScreenState extends State<EmojiFeedbackScreen> {
  double _pos = 2.0; // start at 'ok'

  void _onChanged(double v) => setState(() => _pos = v);

  @override
  Widget build(BuildContext context) {
    final bgStart = EmotionScheme.lerpStart(_pos);
    final bgEnd = EmotionScheme.lerpEnd(_pos);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgStart, bgEnd],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'How are you feeling?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Card with face
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        EmojiFace(position: _pos, size: 220),

                        const SizedBox(height: 18),

                        // label
                        Text(
                          _currentLabel(),
                          style: TextStyle(
                            fontSize: 16,
                            color: EmotionScheme.lerpStroke(_pos),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // selector
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: EmotionSelector(
                            value: _pos,
                            onChanged: _onChanged,
                            onChangeEnd: (v) {},
                          ),
                        ),

                        const SizedBox(height: 6),
                        Text(
                          'Slide to adjust • subtle, instant feedback',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // small footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '0',
                        style: TextStyle(color: Colors.white.withOpacity(0.85)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: _pos / 3.0,
                          color: Colors.white.withOpacity(0.92),
                          backgroundColor: Colors.white.withOpacity(0.2),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '3',
                        style: TextStyle(color: Colors.white.withOpacity(0.85)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _currentLabel() {
    final pos = _pos.clamp(0.0, 3.0);
    final rounded = pos.round().clamp(0, 3);
    final e = Emotion.values[rounded];
    return '${e.emoji} ${e.label}';
  }
}
