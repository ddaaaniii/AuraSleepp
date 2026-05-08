import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WaveVisualizer extends StatefulWidget {
  final bool playing;
  final double height;
  final Color baseColor;
  const WaveVisualizer({super.key, required this.playing, this.height = 100, this.baseColor = C.primary});

  @override
  State<WaveVisualizer> createState() => _WaveVisualizerState();
}

class _WaveVisualizerState extends State<WaveVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800))..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => CustomPaint(
      painter: _WavePainter(_ctrl.value, widget.playing, widget.baseColor),
      size: Size(double.infinity, widget.height),
    ),
  );
}

class _WavePainter extends CustomPainter {
  final double t;
  final bool playing;
  final Color baseColor;
  _WavePainter(this.t, this.playing, this.baseColor);

  @override
  void paint(Canvas canvas, Size size) {
    final layers = [
      {'alpha': 0.95, 'amp': 1.0, 'freq': 1.0, 'speed': 1.0, 'w': 2.2, 'color': baseColor},
      {'alpha': 0.6,  'amp': 0.65, 'freq': 1.6, 'speed': 0.72,'w': 1.6, 'color': C.secondary},
      {'alpha': 0.38, 'amp': 0.42, 'freq': 2.2, 'speed': 1.35,'w': 1.2, 'color': C.cyan},
    ];
    for (final l in layers) {
      final amp = playing
          ? size.height * 0.24 * (l['amp'] as double)
          : size.height * 0.07 * (l['amp'] as double);
      final path = Path();
      for (double x = 0; x <= size.width; x += 2.5) {
        final y = size.height / 2
            + amp * sin((x / size.width * 2 * pi * (l['freq'] as double)) + t * 2 * pi * (l['speed'] as double))
            + amp * 0.35 * sin((x / size.width * 3.8 * pi) + t * 2 * pi * 0.4);
        x == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      final c = (l['color'] as Color).withOpacity(l['alpha'] as double);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = l['w'] as double
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, playing ? 3.5 : 1.5)
        ..shader = LinearGradient(colors: [c.withOpacity(0.08), c, c.withOpacity(0.08)])
            .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_WavePainter o) => o.t != t || o.playing != playing;
}
