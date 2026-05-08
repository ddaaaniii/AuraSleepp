import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/frequency.dart';
import '../providers/sleep_provider.dart';
import '../theme/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SleepProvider>();
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // ── Header ─────────────────────────────────
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('AuraSleep',
                    style: TextStyle(color: C.text, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1)),
                GestureDetector(
                  onTap: p.toggleDeepSleep,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: p.deepSleepMode ? C.primary.withOpacity(0.18) : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: p.deepSleepMode ? C.primary.withOpacity(0.45) : C.border),
                    ),
                    child: Text(
                      p.deepSleepMode ? '🌙 Activo' : 'Modo Sueño',
                      style: TextStyle(fontSize: 11, color: p.deepSleepMode ? C.primary : C.muted, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              Text(
                '\${p.activeFreq?.hzDisplay ?? "2 Hz"} · \${p.activeFreq?.categoryLabel ?? "Delta"} · Sueño profundo',
                style: const TextStyle(fontSize: 12, color: C.muted),
              ),
              const SizedBox(height: 32),

              // ── Card frecuencia activa ──────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [(p.activeFreq?.color ?? C.primary).withOpacity(0.18), Colors.transparent],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: (p.activeFreq?.color ?? C.primary).withOpacity(0.3)),
                ),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      p.deepSleepMode ? '🌙' : '🎵',
                      style: const TextStyle(fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: p.toggleDeepSleep,
                      child: Icon(
                        p.deepSleepMode ? Icons.nightlight_round : Icons.music_note_rounded,
                        color: p.activeFreq?.color ?? C.primary, size: 22,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Text(
                    p.activeFreq?.hzDisplay ?? '2 Hz',
                    style: TextStyle(
                      color: p.activeFreq?.color ?? C.primary,
                      fontSize: 64, fontWeight: FontWeight.w900, letterSpacing: -4,
                    ),
                  ),
                  Text(
                    p.activeFreq?.categoryLabel ?? 'Delta — Sueño profundo',
                    style: const TextStyle(fontSize: 13, color: C.muted),
                  ),
                  const SizedBox(height: 24),
                  WaveVisualizer(playing: p.isPlaying, height: 90, baseColor: p.activeFreq?.color ?? C.primary),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: p.togglePlay,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        color: p.activeFreq?.color ?? C.primary,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: (p.activeFreq?.color ?? C.primary).withOpacity(0.4), blurRadius: 24, spreadRadius: 2)],
                      ),
                      child: Icon(p.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 36),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 24),

              // ── Volumen ────────────────────────────────
              Row(children: [
                const Icon(Icons.volume_down_rounded, color: C.muted, size: 18),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                    ),
                    child: Slider(
                      value: p.volume, onChanged: p.setVolume,
                      activeTrackColor: p.activeFreq?.color ?? C.primary,
                      inactiveTrackColor: Colors.white.withOpacity(0.1),
                      thumbColor: Colors.white,
                      overlayColor: WidgetStateProperty.all((p.activeFreq?.color ?? C.primary).withOpacity(0.15)),
                    ),
                  ),
                ),
                const Icon(Icons.volume_up_rounded, color: C.muted, size: 18),
              ]),
              const SizedBox(height: 24),

              // ── Timer ──────────────────────────────────
              Row(children: [
                Text(p.timer.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.text)),
                const Spacer(),
                const Icon(Icons.timer_outlined, color: C.muted, size: 18),
              ]),
              const SizedBox(height: 10),
              Row(children: TimerOption.values.map((t) => GestureDetector(
                onTap: () => p.setTimer(t),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: p.timer == t ? C.primary.withOpacity(0.18) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: p.timer == t ? C.primary.withOpacity(0.5) : C.border),
                  ),
                  child: Text(t.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: p.timer == t ? C.primary : C.muted)),
                ),
              )).toList()),
              const SizedBox(height: 28),

              // ── Quick Presets ──────────────────────────
              const Text('Presets rápidos', style: TextStyle(color: C.text, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...quickPresets.map((preset) => GestureDetector(
                onTap: () => p.applyPreset(preset),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: C.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: C.border),
                  ),
                  child: Row(children: [
                    Text(preset.emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(preset.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.text), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    Text(preset.subtitle, style: const TextStyle(fontSize: 10, color: C.faint)),
                  ]),
                ),
              )),
              const SizedBox(height: 28),

              // ── Frecuencias ────────────────────────────
              const Text('Frecuencias', style: TextStyle(color: C.text, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...allFrequencies.take(6).map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => p.selectFreq(f),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: p.activeFreq?.id == f.id ? f.color.withOpacity(0.15) : C.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: p.activeFreq?.id == f.id ? f.color.withOpacity(0.5) : Colors.white12),
                    ),
                    child: Row(children: [
                      Text(f.category.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(f.name, style: const TextStyle(color: C.text, fontSize: 14, fontWeight: FontWeight.w600)),
                        Text(f.description, style: const TextStyle(color: C.muted, fontSize: 11)),
                      ])),
                      Text(f.hzDisplay, style: TextStyle(color:
