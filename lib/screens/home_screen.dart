import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/frequency.dart';
import '../providers/sleep_provider.dart';
import '../theme/colors.dart';
import '../widgets/play_button.dart';
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
              const SizedBox(height: 34),
              _buildHeader(p),
              const SizedBox(height: 34),
              _buildPlayerCard(p, activeColor),
              const SizedBox(height: 28),
              _buildTimer(p),
              const SizedBox(height: 30),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'AuraSleep',
                style: TextStyle(
                  color: C.text,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Tu frecuencia ahora es el foco principal.',
                style: TextStyle(color: C.muted, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: p.toggleDeepSleep,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: p.deepSleepMode
                  ? C.primary.withOpacity(0.22)
                  : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: p.deepSleepMode ? C.primary.withOpacity(0.5) : C.border,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.nights_stay_rounded,
                    color: p.deepSleepMode ? C.primary : C.muted, size: 16),
                const SizedBox(width: 8),
                Text(
                  p.deepSleepMode ? 'Sueño profundo' : 'Modo Sueño',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: p.deepSleepMode ? C.primary : C.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard(SleepProvider p, Color activeColor) {
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
        border: Border.all(color: activeColor.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: activeColor.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  p.activeFreq?.categoryLabel.toUpperCase() ?? 'DELTA',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: C.primary,
                      letterSpacing: 0.7),
                ),
              ),
              const Spacer(),
              Text(
                p.isPlaying ? 'Reproduciendo' : 'Preparado',
                style: const TextStyle(
                    fontSize: 12, color: C.muted, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            p.activeFreq?.hzDisplay ?? '2 Hz',
            style: TextStyle(
              color: activeColor,
              fontSize: 64,
              fontWeight: FontWeight.w900,
              letterSpacing: -4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            p.activeFreq?.description ?? 'Ideal para descanso profundo',
            style:
                const TextStyle(fontSize: 14, color: C.textMuted, height: 1.5),
          ),
          const SizedBox(height: 22),
          WaveVisualizer(
            playing: p.isPlaying,
            height: 84,
            baseColor: activeColor,
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              PlayButton(isPlaying: p.isPlaying, onTap: p.togglePlay, size: 64),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.isPlaying ? 'Ondas activas' : 'Listo para iniciar',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: C.text),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text('00:00',
                            style: TextStyle(
                                color: C.text.withOpacity(0.75), fontSize: 12)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: p.isPlaying ? 0.42 : 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: activeColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('30:00',
                            style: TextStyle(
                                color: C.text.withOpacity(0.75), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                  child:
                      _buildInfoChip(Icons.wifi, 'Auriculares', activeColor)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildInfoChip(
                      Icons.nights_stay_rounded, 'Modo sueño', activeColor)),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Icon(Icons.volume_down_rounded, color: C.muted, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Slider(
                  value: p.volume,
                  onChanged: p.setVolume,
                  activeColor: activeColor,
                  inactiveColor: Colors.white12,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.volume_up_rounded, color: C.muted, size: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color activeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, color: activeColor, size: 18),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(
                  color: C.muted, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildVolume(
      BuildContext context, SleepProvider p, Color activeColor) {
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
          style: TextStyle(
              color: C.text, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Column(
          children: quickPresets.map((preset) {
            return GestureDetector(
              onTap: () => p.applyPreset(preset),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: C.border),
                ),
                child: Row(
                  children: [
                    Text(preset.emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            preset.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: C.text,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            preset.subtitle,
                            style: const TextStyle(
                                fontSize: 12, color: C.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.chevron_right_rounded, color: C.muted, size: 20),
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
          style: TextStyle(
              color: C.text, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Column(
          children: allFrequencies.take(6).map((f) {
            final isActive = p.activeFreq?.id == f.id;
            return GestureDetector(
              onTap: () => p.selectFreq(f),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: isActive ? f.color.withOpacity(0.14) : C.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isActive ? f.color.withOpacity(0.4) : Colors.white12,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 6,
                      height: 60,
                      decoration: BoxDecoration(
                        color: f.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: f.color.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(f.category.emoji,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.name,
                            style: const TextStyle(
                              color: C.text,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            f.description,
                            style: const TextStyle(
                                color: C.textMuted, fontSize: 12, height: 1.45),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      f.hzDisplay,
                      style: TextStyle(
                        color: f.color,
                        fontSize: 14,
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
