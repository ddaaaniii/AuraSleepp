import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/frequency.dart';
import '../providers/sleep_provider.dart';
import '../theme/colors.dart';

const _filters = [
  ('🎵 Todas',      FreqCategory.all),
  ('🌙 Sueño',      FreqCategory.sleep),
  ('🌀 Theta',      FreqCategory.theta),
  ('🌊 Alpha',      FreqCategory.alpha),
  ('⚡ Beta',       FreqCategory.beta),
  ('🔥 Gamma',      FreqCategory.gamma),
  ('✨ Especiales',  FreqCategory.special),
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
              padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Text('Biblioteca',
                  style: TextStyle(color: C.text, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1)),
            ),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final (label, cat) = _filters[i];
                  final active = p.libraryFilter == cat;
                  return GestureDetector(
                    onTap: () => p.setFilter(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? C.primary.withOpacity(0.25) : C.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: active ? C.primary : Colors.white12),
                      ),
                      child: Text(label,
                          style: TextStyle(color: active ? C.primary : C.muted, fontSize: 12, fontWeight: FontWeight.w600)),
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
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () => p.selectFrequency(f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isActive ? f.color.withOpacity(0.12) : C.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: isActive ? f.color.withOpacity(0.4) : Colors.white12),
                        ),
                        child: Row(children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: f.color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(child: Text(f.hzDisplay.split(' ')[0],
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: f.color))),
                          ),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(f.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.text)),
                            const SizedBox(height: 2),
                            Row(children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: f.color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                                child: Text(f.categoryLabel, style: TextStyle(fontSize: 9, color: f.color, fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(width: 6),
                              Flexible(child: Text(f.description, style: const TextStyle(fontSize: 11, color: C.muted), overflow: TextOverflow.ellipsis)),
                            ]),
                          ])),
                          Column(mainAxisSize: MainAxisSize.min, children: [
                            GestureDetector(
                              onTap: () => p.toggleFavorite(f),
                              child: Icon(f.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: f.isFavorite ? C.red : C.muted, size: 20),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => f.isInMix ? p.removeFromMix(f) : p.addToMix(f),
                              child: Icon(
                                f.isInMix ? Icons.remove_circle_outline_rounded : Icons.add_circle_outline_rounded,
                                size: 20, color: f.isInMix ? C.red : C.primary.withOpacity(0.7),
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
