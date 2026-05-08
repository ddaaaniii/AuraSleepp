import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/sleep_provider.dart';
import '../models/frequency.dart';
import '../widgets/glass_card.dart';
import '../widgets/freq_tile.dart';
import '../theme/app_theme.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const _tabs = [
    ('🎵 Todas', FreqCategory.all),
    ('🌙 Sueño', FreqCategory.sleep),
    ('🌀 Theta',  FreqCategory.theta),
    ('🌊 Alpha',  FreqCategory.alpha),
    ('⚡ Beta',   FreqCategory.beta),
    ('🔥 Gamma',  FreqCategory.gamma),
    ('✨ Especiales', FreqCategory.special),
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SleepProvider>();
    return Column(children: [
      // Filter tabs
      SizedBox(
        height: 44,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _tabs.length,
          itemBuilder: (_, i) {
            final (label, cat) = _tabs[i];
            final active = p.libraryFilter == cat;
            return GestureDetector(
              onTap: () => p.setFilter(cat),
              child: AnimatedContainer(
                duration: 180.ms,
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: active ? C.primary.withOpacity(0.18) : Colors.white.withOpacity(0.05),
                  border: Border.all(color: active ? C.primary.withOpacity(0.5) : C.border),
                ),
                child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? C.primary : C.muted)),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 12),
      // List
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: p.filteredFrequencies.length,
          itemBuilder: (_, i) => FreqTile(
            freq: p.filteredFrequencies[i],
            isActive: p.activeFreq?.id == p.filteredFrequencies[i].id,
            onTap: () => p.selectFrequency(p.filteredFrequencies[i]),
            onFav: () => p.toggleFavorite(p.filteredFrequencies[i]),
            onMix: () {
              final f = p.filteredFrequencies[i];
              f.isInMix ? p.removeFromMix(f) : p.addToMix(f);
            },
          ).animate().fadeIn(delay: (i * 18).ms, duration: 280.ms),
        ),
      ),
    ]);
  }
}
