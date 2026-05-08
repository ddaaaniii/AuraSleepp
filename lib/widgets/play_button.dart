import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;
  final double size;
  const PlayButton({super.key, required this.isPlaying, required this.onTap, this.size = 80});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: isPlaying
              ? [Colors.white.withOpacity(0.30), C.primary.withOpacity(0.22), C.cyan.withOpacity(0.08)]
              : [Colors.white.withOpacity(0.22), C.secondary.withOpacity(0.14), C.primary.withOpacity(0.05)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.24), width: 1),
        boxShadow: [
          BoxShadow(color: (isPlaying ? C.cyan : C.primary).withOpacity(0.32), blurRadius: 36),
          BoxShadow(color: Colors.black.withOpacity(0.28), blurRadius: 16, offset: const Offset(0,6)),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                key: ValueKey(isPlaying), size: size * 0.5, color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
