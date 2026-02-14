import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiPainter extends CustomPainter {
  final Animation<double> animation;
  final List<_Particle> _particles = [];
  final Random _rnd = Random();

  ConfettiPainter({required this.animation}) : super(repaint: animation) {
    for (int i = 0; i < 50; i++) {
      _particles.add(_Particle(_rnd));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in _particles) {
      p.update(size.height);
      final paint = Paint()..color = p.color;
      canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Particle {
  late double x;
  late double y;
  late double size;
  late double speed;
  late Color color;
  final Random rnd;

  _Particle(this.rnd) {
    reset(true);
  }

  void reset(bool randomY) {
    x = rnd.nextDouble() * 400; 
    y = randomY ? rnd.nextDouble() * 800 : -10;
    size = rnd.nextDouble() * 5 + 3;
    speed = rnd.nextDouble() * 2 + 2;
    color = [Colors.red, Colors.pink, Colors.purple, Colors.orange, Colors.blue][rnd.nextInt(5)];
  }

  void update(double height) {
    y += speed;
    if (y > height) reset(false);
  }
}
