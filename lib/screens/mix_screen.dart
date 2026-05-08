import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/sleep_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/wave_visualizer.dart';
import '../widgets/freq_tile.dart';
import '../widgets/play_button.dart';
import '../theme/app_theme.dart';

class MixScreen extends StatelessWidget {
  const MixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SleepProvider>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [

        // ── MIXER PLAYER CARD ──
        GlassCard(
          radius: 26,
          child: Column(children: [
            const SectionHeader(title: 'Mezclador', action: null),
            const Text('Combina múltiples frecuencias simultáneamente', style: TextStyle(fontSize: 13, color: C.muted), textAlign: TextAlign.center),
            const SizedBox(height: 18),
            WaveVisualizer(playing: p.isPlaying, height: 80),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Play mix
              Expanded(
                child: GestureDetector(
                  onTap: p.mix.isEmpty ? null : p.playMix,
                  child: AnimatedContainer(
                    duration: 200.ms,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: p.mix.isEmpty ? null : LinearGradient(colors: [C.primary.withOpacity(0.35), C.secondary.withOpacity(0.22)]),
                      color: p.mix.isEmpty ? Colors.white.withOpacity(0.05) : null,
                      border: Border.all(color: p.mix.isEmpty ? C.border : C.primary.withOpacity(0.5)),
                      boxShadow: p.mix.isEmpty ? null : [BoxShadow(color: C.primary.withOpacity(0.25), blurRadius: 20)],
                    ),
                    child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.play_arrow_rounded, color: p.mix.isEmpty ? C.faint : C.text, size: 20),
                      const SizedBox(width: 6),
                      Text('Reproducir mezcla (${p.mix.length})', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: p.mix.isEmpty ? C.faint : C.text)),
                    ])),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: p.clearMix,
                child: Container(
                  height: 52, width: 52,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05), border: Border.all(color: C.border)),
                  child: const Icon(Icons.clear_rounded, color: C.muted, size: 20),
                ),
              ),
            ]),
          ]),
        ).animate().fadeIn(duration: 340.ms),

        const SizedBox(height: 14),

        // ── MIX SLOTS ──
        if (p.mix.isNotEmpty) GlassCard(
          radius: 22,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionHeader(title: 'En la mezcla · ${p.mix.length}'),
            ...p.mix.map((f) => FreqTile(
              freq: f, isActive: true,
              onTap: () => p.selectFrequency(f),
              onFav: () => p.toggleFavorite(f),
              onMix: () => p.removeFromMix(f),
            )),
          ]),
        ).animate().fadeIn(delay: 60.ms),

        if (p.mix.isNotEmpty) const SizedBox(height: 14),

        // ── ADD FROM LIBRARY ──
        GlassCard(
          radius: 22,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeader(title: 'Añadir frecuencias'),
            ...allFrequencies.take(12).map((f) => FreqTile(
              freq: f,
              isActive: p.activeFreq?.id == f.id,
              onTap: () => p.selectFrequency(f),
              onFav: () => p.toggleFavorite(f),
              onMix: () => f.isInMix ? p.removeFromMix(f) : p.addToMix(f),
            )),
          ]),
        ).animate().fadeIn(delay: 120.ms),
      ],
    );
  }
}
