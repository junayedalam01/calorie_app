import 'dart:math';
import 'package:flutter/material.dart';

class CalorieRing extends StatelessWidget {
  final int consumed;
  final int goal;

  const CalorieRing({super.key, required this.consumed, required this.goal});

  @override
  Widget build(BuildContext context) {
    final pct = (consumed / goal).clamp(0.0, 1.0);
    final over = consumed > goal;

    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(130, 130),
            painter: _RingPainter(pct, over),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                consumed.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700),
              ),
              const Text('kcal',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 2),
              Text(
                over
                    ? '+${consumed - goal} over'
                    : '${goal - consumed} left',
                style: TextStyle(
                    color: over ? Colors.red.shade200 : Colors.white60,
                    fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final bool over;
  _RingPainter(this.progress, this.over);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 9.0;

    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = over ? Colors.red.shade300 : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
