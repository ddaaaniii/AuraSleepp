import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/frequency.dart';
import '../providers/sleep_provider.dart';
import '../theme/colors.dart';

const _filters = [
  ('🎵 Todas', FreqCategory.all),
  ('🌙 Sueño', FreqCategory.sleep),
  ('🌀 Theta', FreqCategory.theta),
  ('🌊 Alpha', FreqCategory.alpha),
  ('⚡ Beta', FreqCategory.beta),
  ('🔥 Gamma', FreqCategory.gamma),
  ('✨ Especiales', FreqCategory.special),
];

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SleepProvider>();
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 4),
              child: Text('Biblioteca',
                  style: TextStyle(
                      color: C.text,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                  'Selecciona la categoría y descubre tu frecuencia ideal.',
                  style: TextStyle(color: C.muted, fontSize: 13, height: 1.5)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (ctx, i) {
                  final (label, cat) = _filters[i];
                  final active = p.libraryFilter == cat;
                  return GestureDetector(
                    onTap: () => p.setFilter(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: active ? C.primary.withOpacity(0.22) : C.surface,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: active
                                ? C.primary.withOpacity(0.45)
                                : Colors.white12),
                      ),
                      child: Text(label,
                          style: TextStyle(
                              color: active ? C.primary : C.muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: p.filteredFrequencies.length,
                itemBuilder: (ctx, i) {
                  final f = p.filteredFrequencies[i];
                  final isActive = p.activeFreq?.id == f.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => p.selectFrequency(f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color:
                              isActive ? f.color.withOpacity(0.14) : C.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                              color: isActive
                                  ? f.color.withOpacity(0.35)
                                  : Colors.white12),
                        ),
                        child: Row(children: [
                          Container(
                            width: 6,
                            height: 70,
                            decoration: BoxDecoration(
                              color: f.color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: f.color.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                                child: Text(f.category.emoji,
                                    style: const TextStyle(fontSize: 20))),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(f.name,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: C.text)),
                                const SizedBox(height: 6),
                                Text(f.description,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: C.textMuted,
                                        height: 1.4)),
                              ])),
                          const SizedBox(width: 12),
                          Text(
                            f.hzDisplay,
                            style: TextStyle(
                              color: f.color,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(mainAxisSize: MainAxisSize.min, children: [
                            GestureDetector(
                              onTap: () => p.toggleFavorite(f),
                              child: Icon(
                                  f.isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: f.isFavorite ? C.red : C.muted,
                                  size: 20),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => f.isInMix
                                  ? p.removeFromMix(f)
                                  : p.addToMix(f),
                              child: Icon(
                                f.isInMix
                                    ? Icons.remove_circle_outline_rounded
                                    : Icons.add_circle_outline_rounded,
                                size: 20,
                                color: f.isInMix
                                    ? C.red
                                    : C.primary.withOpacity(0.75),
                              ),
                            ),
                          ]),
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
