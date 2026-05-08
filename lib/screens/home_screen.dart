
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

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'AuraSleep',
                    style: TextStyle(
                      color: C.text,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  GestureDetector(
                    onTap: p.toggleDeepSleep,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: p.deepSleepMode
                            ? C.primary.withOpacity(0.18)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: p.deepSleepMode
                              ? C.primary.withOpacity(0.45)
                              : C.border,
                        ),
                      ),
                      child: Text(
                        p.deepSleepMode ? 'Modo Sueño ON' : 'Modo Sueño',
                        style: TextStyle(
                          fontSize: 11,
                          color: p.deepSleepMode ? C.primary : C.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${p.activeFreq?.hzDisplay ?? "2 Hz"} · ${p.activeFreq?.categoryLabel ?? "Delta"}',
                style: const TextStyle(fontSize: 12, color: C.muted),
              ),
              const SizedBox(height: 32),

              // Card frecuencia activa
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (p.activeFreq?.color ?? C.primary).withOpacity(0.18),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: (p.activeFreq?.color ?? C.primary).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      p.activeFreq?.hzDisplay ?? '2 Hz',
                      style: TextStyle(
                        color: p.activeFreq?.color ?? C.primary,
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -4,
                      ),
                    ),
                    Text(
                      p.activeFreq?.categoryLabel ?? 'Delta',
                      style: const TextStyle(fontSize: 13, color: C.muted),
                    ),
                    const SizedBox(height: 24),
                    _WaveVisualizer(
                      playing: p.isPlaying,
                      height: 90,
                      baseColor: p.activeFreq?.color ?? C.primary,
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: p.togglePlay,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: p.activeFreq?.color ?? C.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (p.activeFreq?.color ?? C.primary).withOpacity(0.4),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          p.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Volumen
              Row(
                children: [
                  const Icon(Icons.volume_down_rounded, color: C.muted, size: 18),
                  Expanded(
                    child: Slider(
                      value: p.volume,
                      onChanged: p.setVolume,
                      activeColor: p.activeFreq?.color ?? C.primary,
                      inactiveColor: Colors.white12,
                    ),
                  ),
                  const Icon(Icons.volume_up_rounded, color: C.muted, size: 18),
                ],
              ),
              const SizedBox(height: 24),

              // Timer
              Row(
                children: [
                  Text(
                    p.timer.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: C.text,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.timer_outlined, color: C.muted, size: 18),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: TimerOption.values.map((t) {
                    final active = p.timer == t;
                    return GestureDetector(
                      onTap: () => p.setTimer(t),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: active
                              ? C.primary.withOpacity(0.18)
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: active ? C.primary.withOpacity(0.5) : C.border,
                          ),
                        ),
                        child: Text(
                          t.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: active ? C.primary : C.muted,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 28),

              // Presets
              const Text(
                'Presets rápidos',
                style: TextStyle(color: C.text, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Column(
                children: quickPresets.map((preset) {
                  return GestureDetector(
                    onTap: () => p.applyPreset(preset),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: C.border),
                      ),
                      child: Row(
                        children: [
                          Text(preset.emoji, style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              preset.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: C.text,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            preset.subtitle,
                            style: const TextStyle(fontSize: 10, color: C.faint),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // Frecuencias recientes
              const Text(
                'Frecuencias',
                style: TextStyle(color: 
