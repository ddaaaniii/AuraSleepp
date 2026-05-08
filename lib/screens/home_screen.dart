import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/frequency.dart';
import '../providers/sleep_provider.dart';
import '../theme/colors.dart';
import '../widgets/wave_visualizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SleepProvider>();
    final activeColor = p.activeFreq?.color ?? C.primary;

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              _buildHeader(p),
              const SizedBox(height: 32),
              _buildPlayerCard(context, p, activeColor),
              const SizedBox(height: 24),
              _buildVolume(context, p, activeColor),
              const SizedBox(height: 24),
              _buildTimer(p),
              const SizedBox(height: 28),
              _buildPresets(p),
              const SizedBox(height: 28),
              _buildFreqList(p),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(SleepProvider p) {
    return Row(
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
              p.deepSleepMode ? 'Sueno ON' : 'Modo Sueno',
              style: TextStyle(
                fontSize: 11,
                color: p.deepSleepMode ? C.primary : C.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard(BuildContext context, SleepProvider p, Color activeColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [activeColor.withOpacity(0.18), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: activeColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            p.activeFreq != null ? p.activeFreq!.hzDisplay : '2 Hz',
            style: TextStyle(
              color: activeColor,
              fontSize: 64,
              fontWeight: FontWeight.w900,
              letterSpacing: -4,
            ),
          ),
          Text(
            p.activeFreq != null ? p.activeFreq!.categoryLabel : 'Delta',
            style: const TextStyle(fontSize: 13, color: C.muted),
          ),
          const SizedBox(height: 24),
          WaveVisualizer(
            playing: p.isPlaying,
            height: 90,
            baseColor: activeColor,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: p.togglePlay,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withOpacity(0.4),
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
    );
  }

  Widget _buildVolume(BuildContext context, SleepProvider p, Color activeColor) {
    return Row(
      children: [
        const Icon(Icons.volume_down_rounded, color: C.muted, size: 18),
        Expanded(
          child: Slider(
            value: p.volume,
            onChanged: p.setVolume,
            activeColor: activeColor,
            inactiveColor: Colors.white12,
          ),
        ),
        const Icon(Icons.volume_up_rounded, color: C.muted, size: 18),
      ],
    );
  }

  Widget _buildTimer(SleepProvider p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildPresets(SleepProvider p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Presets rapidos',
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
      ],
    );
  }

  Widget _buildFreqList(SleepProvider p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frecuencias',
          style: TextStyle(color: C.text, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Column(
          children: allFrequencies.take(6).map((f) {
            final isActive = p.activeFreq?.id == f.id;
            return GestureDetector(
              onTap: () => p.selectFreq(f),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isActive ? f.color.withOpacity(0.15) : C.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive
                        ? f.color.withOpacity(0.5)
                        : Colors.white12,
                  ),
                ),
                child: Row(
                  children: [
                    Text(f.category.emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.name,
                            style: const TextStyle(
                              color: C.text,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            f.description,
                            style: const TextStyle(color: C.muted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      f.hzDisplay,
                      style: TextStyle(
                        color: f.color,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
