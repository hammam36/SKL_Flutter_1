import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/emotion.dart';

class EmojiFace extends StatelessWidget {
  final double position; // 0..3 continuous
  final double size;
  final Duration duration;

  const EmojiFace({
    Key? key,
    required this.position,
    this.size = 220,
    this.duration = const Duration(milliseconds: 250),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stroke = EmotionScheme.lerpStroke(position);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: position, end: position),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return CustomPaint(
          size: Size.square(size),
          painter: _FacePainter(value, stroke),
        );
      },
    );
  }
}

class _FacePainter extends CustomPainter {
  final double pos; // 0..3
  final Color stroke;
  _FacePainter(this.pos, this.stroke);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // subtle face background
    paint.shader = RadialGradient(
      colors: [Colors.white, Colors.grey.shade100],
      center: const Alignment(-0.3, -0.3),
      radius: 0.9,
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius * 0.98, paint);

    // outline
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.025
      ..color = stroke.withOpacity(0.95)
      ..isAntiAlias = true;
    canvas.drawCircle(center, radius * 0.98, outline);

    // parameters derived from pos
    final t = (pos / 3.0).clamp(0.0, 1.0);

    // Eyes: position them relative to center
    final eyeOffsetY = ui.lerpDouble(
      -size.height * 0.08,
      -size.height * 0.14,
      t,
    )!;
    final eyeOffsetX = size.width * 0.18;
    final eyeWidth = size.width * 0.14;
    final eyeHeight = ui.lerpDouble(
      eyeWidth * 0.45,
      eyeWidth * 0.14,
      t,
    )!; // open when good

    final eyePaint = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // draw left eye
    final leftEyeCenter = Offset(
      center.dx - eyeOffsetX,
      center.dy + eyeOffsetY,
    );
    _drawEye(canvas, leftEyeCenter, eyeWidth, eyeHeight, eyePaint, t);

    // draw right eye
    final rightEyeCenter = Offset(
      center.dx + eyeOffsetX,
      center.dy + eyeOffsetY,
    );
    _drawEye(canvas, rightEyeCenter, eyeWidth, eyeHeight, eyePaint, t);

    // mouth
    final mouthWidth = size.width * 0.5;
    final mouthY = center.dy + size.height * 0.12;

    // mouth curvature from -0.4 (frown) to 0.35 (smile)
    final mouthCurve = ui.lerpDouble(-0.4, 0.35, t)!;

    final p1 = Offset(center.dx - mouthWidth / 2, mouthY);
    final p2 = Offset(center.dx + mouthWidth / 2, mouthY);
    final cp = Offset(center.dx, mouthY + mouthWidth * mouthCurve);

    final mouthPaint = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.035
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final mouthPath = Path()..moveTo(p1.dx, p1.dy);
    mouthPath.quadraticBezierTo(cp.dx, cp.dy, p2.dx, p2.dy);
    canvas.drawPath(mouthPath, mouthPaint);

    // subtle blush for good moods
    if (t > 0.55) {
      final blushPaint = Paint()
        ..color = Colors.pink.withOpacity((t - 0.55) * 0.6);
      canvas.drawCircle(
        Offset(center.dx - eyeOffsetX, center.dy + size.height * 0.03),
        size.width * 0.05,
        blushPaint,
      );
      canvas.drawCircle(
        Offset(center.dx + eyeOffsetX, center.dy + size.height * 0.03),
        size.width * 0.05,
        blushPaint,
      );
    }
  }

  void _drawEye(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint paint,
    double t,
  ) {
    // t=0 -> angry/narrow line (slanted eyebrows), t=1 -> smiling open eyes
    final path = Path();

    final left = Offset(center.dx - w / 2, center.dy);
    final right = Offset(center.dx + w / 2, center.dy);

    // control point for arc
    final cpY = center.dy + h * (1 - 2 * t); // negative for uplift
    final cp = Offset(center.dx, cpY);
    path.moveTo(left.dx, left.dy);
    path.quadraticBezierTo(cp.dx, cp.dy, right.dx, right.dy);

    canvas.drawPath(path, paint);

    // eyebrows for low t (bad/ugh)
    if (t < 0.35) {
      final browPaint = Paint()
        ..color = paint.color.withOpacity(0.9)
        ..strokeWidth = paint.strokeWidth * 0.7
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final browY = center.dy - h * 1.6;
      final angle = ui.lerpDouble(0.28, 0.05, t)!;

      canvas.drawLine(
        Offset(center.dx - w / 1.2, browY - w * angle),
        Offset(center.dx + w / 1.2, browY + w * angle),
        browPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FacePainter oldDelegate) {
    return oldDelegate.pos != pos || oldDelegate.stroke != stroke;
  }
}
