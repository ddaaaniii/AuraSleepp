import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/frequency.dart';
import '../providers/sleep_provider.dart';
import '../theme/colors.dart';

class MixScreen extends StatefulWidget {
  const MixScreen({super.key});
  @override
  State<MixScreen> createState() => _MixScreenState();
}

class _MixScreenState extends State<MixScreen> {
  final Set<String> _selected = {};

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
              child: Text('Mezclar',
                  style: TextStyle(color: C.text, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('Hasta 3 frecuencias', style: TextStyle(color: C.muted, fontSize: 14)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.6),
                itemCount: allFrequencies.length > 12 ? 12 : allFrequencies.length,
                itemBuilder: (ctx, i) {
                  final f = allFrequencies[i];
                  final sel = _selected.contains(f.id);
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (sel) {
                        _selected.remove(f.id);
                      } else if (_selected.length < 3) {
                        _selected.add(f.id);
                      }
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: sel ? f.color.withOpacity(0.2) : C.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: sel ? f.color : Colors.white.withOpacity(0.08),
                          width: sel ? 1.5 : 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(f.category.emoji, style: const TextStyle(fontSize: 22)),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              f.hzDisplay,
                              style: TextStyle(color: f.color, fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              f.description,
                              style: const TextStyle(color: C.muted, fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_selected.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: C.accent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      final freqs = allFrequencies.where((f) => _selected.contains(f.id)).toList();
                      p.playMix(freqs);
                    },
                    child: Text(
                      'Reproducir mezcla (' + _selected.length.toString() + ')',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
