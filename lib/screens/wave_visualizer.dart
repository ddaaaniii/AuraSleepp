import 'dart:math' as math;
import 'package:flutter/material.dart';

class WaveVisualizer extends StatefulWidget {
  final bool playing;
  final double height;
  final Color baseColor;

  const WaveVisualizer({
    super.key,
    required this.playing,
    required this.height,
    required this.baseColor,
  });

  @override
  State<WaveVisualizer> createState() => _WaveVisualizerState();
}

class _WaveVisualizerState extends State<WaveVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return SizedBox(
          height: widget.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(28, (i) {
              final phase = (i / 28.0 + _ctrl.value) * math.pi * 2 + i * 0.4;
              final wave = (math.sin(phase) + 1.0) / 2.0;
              final h = widget.playing
                  ? widget.height * 0.2 + widget.height * 0.7 * wave
                  : widget.height * 0.12;
              return Container(
                width: 4,
                height: h.clamp(4.0, widget.height),
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  color: widget.baseColor
                      .withOpacity(widget.playing ? 0.8 : 0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
