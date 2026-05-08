import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Gradient? gradient;
  final Color? borderColor;
  final double blur;
  final List<BoxShadow>? shadows;

  const GlassCard({
    super.key, required this.child,
    this.padding, this.radius = 24, this.gradient,
    this.borderColor, this.blur = 20, this.shadows,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient ?? const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0x16FFFFFF), Color(0x06FFFFFF)],
          ),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor ?? C.border, width: 1),
          boxShadow: shadows ?? [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 32, offset: const Offset(0,8))],
        ),
        child: child,
      ),
    ),
  );
}

class GlassPill extends StatelessWidget {
  final String text;
  final Color? color;
  const GlassPill({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: (color ?? Colors.white).withOpacity(0.07),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: (color ?? Colors.white).withOpacity(0.18)),
    ),
    child: Text(text, style: TextStyle(fontSize: 11, color: color ?? C.muted, fontWeight: FontWeight.w500)),
  );
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, color: C.muted, fontSize: 12, letterSpacing: 0.12)),
        if (action != null) GestureDetector(onTap: onAction, child: Text(action!, style: const TextStyle(fontSize: 11, color: C.primary, fontWeight: FontWeight.w600))),
      ],
    ),
  );
}
