import 'package:flutter/material.dart';
import '../models/frequency.dart';
import '../theme/app_theme.dart';

class FreqTile extends StatelessWidget {
  final Frequency freq;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback? onFav;
  final VoidCallback? onMix;

  const FreqTile({
    super.key, required this.freq, required this.isActive,
    required this.onTap, this.onFav, this.onMix,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isActive ? freq.color.withOpacity(0.12) : Colors.white.withOpacity(0.04),
        border: Border.all(color: isActive ? freq.color.withOpacity(0.45) : C.border),
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: freq.color.withOpacity(0.15),
            border: Border.all(color: freq.color.withOpacity(0.3)),
          ),
          child: Center(child: Text(freq.hzDisplay.split(' ')[0], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: freq.color))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(freq.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.text)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: freq.color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                child: Text(freq.categoryLabel, style: TextStyle(fontSize: 9, color: freq.color, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 3),
            Text(freq.description, style: Theme.of(context).textTheme.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        )),
        const SizedBox(width: 8),
        Row(mainAxisSize: MainAxisSize.min, children: [
          if (onMix != null) GestureDetector(
            onTap: onMix,
            child: Icon(
              freq.isInMix ? Icons.remove_circle_outline_rounded : Icons.add_circle_outline_rounded,
              size: 20, color: freq.isInMix ? C.red : C.primary.withOpacity(0.7),
            ),
          ),
          if (onFav != null) ...[
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onFav,
              child: Icon(
                freq.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: 20, color: freq.isFavorite ? C.secondary : C.faint,
              ),
            ),
          ],
        ]),
      ]),
    ),
  );
}
