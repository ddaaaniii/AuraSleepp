import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/frequency.dart';
import '../providers/audio_provider.dart';
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
    final audio = context.watch<AudioProvider>();
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Text('Mezclar Frecuencias',
                  style: TextStyle(
                      color: C.text,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('Selecciona hasta 3 frecuencias para combinar',
                  style: TextStyle(color: C.textMuted, fontSize: 14)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                ),
                itemCount: allFrequencies.take(12).length,
                itemBuilder: (ctx, i) {
                  final f = allFrequencies.take(12).toList()[i];
                  return FreqTile(
                    freq: f,
                    selected: _selected.contains(f.id),
                    onTap: () => setState(() {
                      if (_selected.contains(f.id)) {
                        _selected.remove(f.id);
                      } else if (_selected.length < 3) {
                        _selected.add(f.id);
                      }
                    }),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      final freqs = allFrequencies
                          .where((f) => _selected.contains(f.id))
                          .toList();
                      audio.playMix(freqs);
                    },
                    child: Text(
                      'Reproducir mezcla (${_selected.length})',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
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

class FreqTile extends StatelessWidget {
  final Frequency freq;
  final bool selected;
  final VoidCallback onTap;

  const FreqTile(
      {super.key,
      required this.freq,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected
              ? freq.category.color.withOpacity(0.25)
              : C.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? freq.category.color
                : Colors.white.withOpacity(0.08),
            width: selected ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(freq.category.emoji,
                style: const TextStyle(fontSize: 22)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${freq.hz.toStringAsFixed(freq.hz % 1 == 0 ? 0 : 1)} Hz',
                    style: TextStyle(
                        color: freq.category.color,
                        fontSize: 15,
                        fontWeight: FontWeight.w800)),
                Text(freq.description,
                    style: TextStyle(
                        color: C.textMuted, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
