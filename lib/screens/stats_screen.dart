import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/sleep_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/freq_tile.dart';
import '../theme/app_theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SleepProvider>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [

        // ── KEY STATS ──
        GlassCard(
          radius: 24,
          child: Column(children: [
            GridView.count(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, childAspectRatio: 1.8, mainAxisSpacing: 8, crossAxisSpacing: 8,
              children: [
                _StatBox(value: '${p.sessionCount}', label: 'Noches de uso', icon: '🌙', color: C.primary),
                _StatBox(value: '⏱️ ${p.totalHours}h', label: 'Tiempo total', icon: null, color: C.cyan),
                _StatBox(value: '${p.favorites.length}', label: 'Favoritos', icon: '❤️', color: C.secondary),
                _StatBox(value: '${allFrequencies.length}', label: 'Frecuencias', icon: '🎵', color: C.green),
              ],
            ),
          ]),
        ).animate().fadeIn(duration: 340.ms),

        const SizedBox(height: 14),

        // ── SESSIONS WEEK ──
        GlassCard(
          radius: 22,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeader(title: 'Sesiones esta semana'),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ['L','M','X','J','V','S','D'].asMap().entries.map((e) {
                  final heights = [0.4, 0.7, 0.5, 0.9, 0.6, 1.0, 0.3];
                  final isToday = e.key == 5;
                  return Column(children: [
                    AnimatedContainer(
                      duration: (300 + e.key * 60).ms,
                      width: 28, height: 80 * heights[e.key],
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: isToday ? LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [C.primary, C.primary.withOpacity(0.4)]) : null,
                        color: isToday ? null : Colors.white.withOpacity(0.08),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(e.value, style: TextStyle(fontSize: 11, color: isToday ? C.primary : C.faint, fontWeight: isToday ? FontWeight.w700 : FontWeight.w400)),
                  ]);
                }).toList(),
              ].expand((e) => e is List ? e : [e]).cast<Widget>().toList(),
            ),
          ]),
        ).animate().fadeIn(delay: 60.ms),

        const SizedBox(height: 14),

        // ── FAVORITE FREQUENCY ──
        GlassCard(
          radius: 22,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionHeader(title: 'Frecuencia favorita'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(colors: [C.primary.withOpacity(0.14), C.secondary.withOpacity(0.08)]),
                border: Border.all(color: C.primary.withOpacity(0.3)),
              ),
              child: Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text('${allFrequencies.firstWhere((f) => f.id == 'd2').hz.toInt()}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: -2, color: C.text, height: 1.0)),
                    const Padding(padding: EdgeInsets.only(bottom: 4, left: 2), child: Text(' Hz', style: TextStyle(fontSize: 16, color: C.muted))),
                  ]),
                  const Text('2 Hz — Delta', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: C.text)),
                  const SizedBox(height: 2),
                  const Text('Sueño profundo · 8 sesiones', style: TextStyle(fontSize: 12, color: C.faint)),
                ]),
              ]),
            ),
          ]),
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 14),

        // ── FAVORITES LIST ──
        GlassCard(
          radius: 22,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionHeader(title: 'Frecuencias favoritas guardadas', action: p.favorites.isEmpty ? null : 'Ver todas'),
            if (p.favorites.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Column(children: [
                  Text('❤️', style: TextStyle(fontSize: 32)),
                  SizedBox(height: 8),
                  Text('Aún no tienes favoritos', style: TextStyle(color: C.muted, fontSize: 14)),
                  SizedBox(height: 4),
                  Text('Toca el ♡ en cualquier frecuencia para guardarla aquí', style: TextStyle(color: C.faint, fontSize: 12), textAlign: TextAlign.center),
                ])),
              )
            else
              ...p.favorites.map((f) => FreqTile(
                freq: f, isActive: false,
                onTap: () => context.read<SleepProvider>().selectFrequency(f),
                onFav: () => context.read<SleepProvider>().toggleFavorite(f),
              )),
          ]),
        ).animate().fadeIn(delay: 140.ms),

        const SizedBox(height: 14),

        // ── STREAK ──
        GlassCard(
          radius: 22,
          child: Row(children: [
            const Text('🔥', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${p.streak} días de racha', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.text)),
              const SizedBox(height: 2),
              const Text('Sigue así, estás mejorando tu sueño cada noche.', style: TextStyle(fontSize: 12, color: C.muted)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: C.amber.withOpacity(0.12),
                border: Border.all(color: C.amber.withOpacity(0.35)),
              ),
              child: Text('+${p.streak}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: C.amber)),
            ),
          ]),
        ).animate().fadeIn(delay: 180.ms),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value, label;
  final String? icon;
  final Color color;
  const _StatBox({required this.value, required this.label, this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: color.withOpacity(0.06),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      if (icon != null) Text(icon!, style: const TextStyle(fontSize: 20)),
      Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.8, color: color, height: 1.1)),
      Text(label, style: const TextStyle(fontSize: 11, color: C.faint)),
    ]),
  );
}
