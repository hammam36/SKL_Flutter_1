import 'package:flutter/material.dart';
import '../models/emotion.dart';

class EmotionSelector extends StatefulWidget {
  final double value; // 0..3 continuous
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;

  const EmotionSelector({
    Key? key,
    required this.value,
    required this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  State<EmotionSelector> createState() => _EmotionSelectorState();
}

class _EmotionSelectorState extends State<EmotionSelector> {
  void _updateFromDx(Offset local, double width) {
    final pad = 12.0;
    final x = (local.dx - pad).clamp(0.0, width - pad * 2);
    final val = (x / (width - pad * 2)) * 3.0;
    widget.onChanged(val);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final pad = 12.0;
        final trackHeight = 6.0;
        final thumbSize = 48.0;
        final usable = width - pad * 2;
        final left =
            pad + (widget.value.clamp(0.0, 3.0) / 3.0) * usable - thumbSize / 2;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (e) => _updateFromDx(e.localPosition, width),
          onPanUpdate: (e) => _updateFromDx(e.localPosition, width),
          onPanEnd: (e) => widget.onChangeEnd?.call(widget.value),
          onTapDown: (e) => _updateFromDx(e.localPosition, width),
          child: SizedBox(
            height: 80,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // track background
                Positioned(
                  left: pad,
                  right: pad,
                  height: trackHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(99),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),

                // progress fill (soft)
                Positioned(
                  left: pad,
                  height: trackHeight,
                  child: Container(
                    width: (widget.value.clamp(0.0, 3.0) / 3.0) * usable,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8FB0C9), Color(0xFFBCE5B5)],
                      ),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    height: trackHeight,
                  ),
                ),

                // ticks and labels
                for (int i = 0; i < 4; i++)
                  Positioned(
                    left: pad + (i / 3.0) * usable - 10,
                    top: 8,
                    child: Column(
                      children: [
                        Text(
                          Emotion.values[i].emoji,
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 2,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),

                // thumb
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  left: left,
                  child: Material(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Container(
                      width: thumbSize,
                      height: thumbSize,
                      padding: const EdgeInsets.all(6),
                      child: Center(
                        child: Text(
                          _thumbEmoji(),
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _thumbEmoji() {
    final pos = widget.value.clamp(0.0, 3.0);
    final rounded = (pos).round().clamp(0, 3);
    return Emotion.values[rounded].emoji;
  }
}
