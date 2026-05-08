import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/sleep_provider.dart';
import '../models/frequency.dart';
import '../widgets/glass_card.dart';
import '../widgets/wave_visualizer.dart';
import '../widgets/play_button.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SleepProvider>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [

        // ── DEEP SLEEP BANNER ──
        if (p.deepSleepMode)
          GlassCard(
            radius: 22,
            gradient: LinearGradient(colors: [C.primary.withOpacity(0.22), C.secondary.withOpacity(0.14)]),
            borderColor: C.primary.withOpacity(0.4),
            child: Row(children: [
              const Text('🌙', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Modo Sueño Profundo', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: C.text)),
                Text('${p.activeFreq?.hzDisplay ?? '2 Hz'} · ${p.activeFreq?.categoryLabel ?? 'Delta'} · Sueño profundo', style: const TextStyle(fontSize: 12, color: C.muted)),
              ])),
              GestureDetector(
                onTap: p.toggleDeepSleep,
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: C.border), color: Colors.white.withOpacity(0.06)),
                  child: const Text('Salir', style: TextStyle(fontSize: 12, color: C.muted)),
                ),
              ),
            ]),
          ).animate().fadeIn(duration: 300.ms),

        if (p.deepSleepMode) const SizedBox(height: 12),

        // ── MAIN PLAYER CARD ──
        GlassCard(
          radius: 28,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Reproduciendo ahora', style: TextStyle(fontSize: 11, color: C.faint, letterSpacing: 0.2)),
                const SizedBox(height: 6),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(p.deepSleepMode ? '🌙' : '🎵', style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(p.activeFreq?.categoryLabel ?? 'Sueño Profundo',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: C.text)),
                ]),
              ])),
              GestureDetector(
                onTap: p.toggleDeepSleep,
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: p.deepSleepMode ? C.primary.withOpacity(0.18) : Colors.white.withOpacity(0.05),
                    border: Border.all(color: p.deepSleepMode ? C.primary.withOpacity(0.45) : C.border),
                  ),
                  child: Text(p.deepSleepMode ? '🌙 Activo' : 'Modo Sueño', style: TextStyle(fontSize: 11, color: p.deepSleepMode ? C.primary : C.muted, fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
            const SizedBox(height: 6),
            // Big Hz display
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(
                p.activeFreq?.hz != null
                    ? (p.activeFreq!.hz < 100 ? '${p.activeFreq!.hz % 1 == 0 ? p.activeFreq!.hz.toInt() : p.activeFreq!.hz}' : '${p.activeFreq!.hz.toInt()}')
                    : '2',
                style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w800, letterSpacing: -3, color: C.text, height: 1.0),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 8, left: 4), child: Text('Hz', style: TextStyle(fontSize: 20, color: C.muted, fontWeight: FontWeight.w600))),
            ]),
            Text(p.activeFreq?.categoryLabel ?? 'Delta — Sueño profundo', style: const TextStyle(fontSize: 13, color: C.muted)),
            const SizedBox(height: 4),
            Text(p.activeFreq?.description ?? 'Ondas delta para inducir el sueño más profundo y restaurador.', style: const TextStyle(fontSize: 13, color: C.faint, height: 1.5)),
            const SizedBox(height: 20),
            // Wave visualizer
            WaveVisualizer(playing: p.isPlaying, height: 90, baseColor: p.activeFreq?.color ?? C.primary),
            const SizedBox(height: 16),
            // Play + volume
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Volumen', style: TextStyle(fontSize: 11, color: C.faint)),
                const SizedBox(height: 2),
                Text('${(p.volume * 100).round()}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.text)),
              ]),
              PlayButton(isPlaying: p.isPlaying, onTap: p.togglePlay),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text('Timer', style: TextStyle(fontSize: 11, color: C.faint)),
                const SizedBox(height: 2),
                Text(p.timer.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.text)),
              ]),
            ]),
            const SizedBox(height: 12),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 4, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
                activeTrackColor: p.activeFreq?.color ?? C.primary, inactiveTrackColor: Colors.white.withOpacity(0.1),
                thumbColor: Colors.white, overlayColor: (p.activeFreq?.color ?? C.primary).withOpacity(0.15),
              ),
              child: Slider(value: p.volume, min: 0, max: 1, onChanged: p.setVolume),
            ),
            const SizedBox(height: 8),
            // Timer pills
            Row(children: TimerOption.values.map((t) => GestureDetector(
              onTap: () => p.setTimer(t),
              child: AnimatedContainer(
                duration: 200.ms,
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: p.timer == t ? C.primary.withOpacity(0.18) : Colors.white.withOpacity(0.05),
                  border: Border.all(color: p.timer == t ? C.primary.withOpacity(0.5) : C.border),
                ),
                child: Text(t.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: p.timer == t ? C.primary : C.muted)),
              ),
            )).toList()),
          ]),
        ).animate().fadeIn(duration: 380.ms).slideY(begin: 0.06, end: 0),

        const SizedBox(height: 14),

        // ── QUICK PRESETS ──
        GlassCard(
          radius: 22,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeader(title: 'Presets rápidos'),
            GridView.count(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, childAspectRatio: 2.4, mainAxisSpacing: 8, crossAxisSpacing: 8,
              children: quickPresets.map((preset) => GestureDetector(
                onTap: () => p.applyPreset(preset),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.04),
                    border: Border.all(color: C.border),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Row(children: [
                      Text(preset.emoji, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Expanded(child: Text(preset.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.text), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ]),
                    const SizedBox(height: 2),
                    Text(preset.subtitle, style: const TextStyle(fontSize: 10, color: C.faint)),
                  ]),
                ),
              )).toList(),
            ),
          ]),
        ).animate().fadeIn(delay: 80.ms, duration: 340.ms),
      ],
    );
  }
}
