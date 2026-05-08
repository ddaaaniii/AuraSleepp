import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/frequency.dart';
import '../providers/sleep_provider.dart';
import '../theme/colors.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SleepProvider>();
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Estadísticas',
                  style: TextStyle(color: C.text, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1)),
              const SizedBox(height: 8),
              const Text('Tu historial de relajación', style: TextStyle(color: C.muted, fontSize: 14)),
              const SizedBox(height: 28),
              _GlassCard(child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Sleep Score', style: TextStyle(color: C.text, fontSize: 18, fontWeight: FontWeight.w700)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: C.green.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                    child: const Text('Bueno', style: TextStyle(color: C.green, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ]),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('\${allFrequencies.length}',
                      style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900, letterSpacing: -3, color: C.primary, height: 1.0)),
                  const SizedBox(width: 6),
                  const Padding(padding: EdgeInsets.only(bottom: 10),
                      child: Text('frecuencias', style: TextStyle(color: C.muted, fontSize: 14))),
                ]),
              ])),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.4,
                children: [
                  _StatBox(value: '\${allFrequencies.length}', label: 'Frecuencias', emoji: '🎵', color: C.primary),
                  _StatBox(value: '\${p.sessionCount}',        label: 'Sesiones',    emoji: '🎧', color: const Color(0xFF48BEFF)),
                  _StatBox(value: '\${p.totalSessionMinutes} min', label: 'Tiempo total', emoji: '⏱', color: C.green),
                  _StatBox(value: p.streak > 0 ? '\${p.streak} días' : '—', label: 'Racha', emoji: '🔥', color: const Color(0xFFFF9A44)),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Categorías', style: TextStyle(color: C.text, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...FrequencyCategory.values.map((cat) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _GlassCard(child: Row(children: [
                  Text(cat.emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(cat.label, style: const TextStyle(color: C.text, fontWeight: FontWeight.w600, fontSize: 15)),
                    Text('\${allFrequencies.where((f) => f.category == cat).length} frecuencias',
                        style: const TextStyle(color: C.muted, fontSize: 12)),
                  ])),
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: cat.color, shape: BoxShape.circle)),
                ])),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.1)),
    ),
    child: child,
  );
}

class _StatBox extends StatelessWidget {
  final String value, label, emoji;
  final Color color;
  const _StatBox({required this.value, required this.label, required this.emoji, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(18), border: Border.all(color: color.withOpacity(0.2))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(emoji, style: const TextStyle(fontSize: 22)),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        Text(label, style: const TextStyle(color: C.muted, fontSize: 11)),
      ]),
    ]),
  );
}
