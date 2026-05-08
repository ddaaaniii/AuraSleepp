import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sleep_provider.dart';
import '../theme/colors.dart';

class AsmrScreen extends StatelessWidget {
  const AsmrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SleepProvider>();
    final primary = p.theme.primary;

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ASMR',
                    style: TextStyle(color: C.text, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1),
                  ),
                  GestureDetector(
                    onTap: () => _showUploadDialog(context, p),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primary.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add_rounded, color: primary, size: 16),
                          const SizedBox(width: 4),
                          Text('Subir MP3', style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('Paisajes sonoros y tus audios', style: TextStyle(color: C.muted, fontSize: 13)),
            ),
            const SizedBox(height: 16),

            // Reproductor activo
            if (p.activeAsmr != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary.withOpacity(0.2), primary.withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: primary.withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(p.activeAsmr!.emoji, style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.activeAsmr!.name,
                                    style: const TextStyle(color: C.text, fontSize: 15, fontWeight: FontWeight.w700)),
                                Text(p.asmrPlaying ? 'Reproduciendo...' : 'Pausado',
                                    style: TextStyle(color: primary, fontSize: 11)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: p.toggleAsmr,
                            child: Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                              child: Icon(
                                p.asmrPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                color: Colors.white, size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.volume_down_rounded, color: C.muted, size: 16),
                          Expanded(
                            child: Slider(
                              value: p.asmrVolume,
                              onChanged: p.setAsmrVolume,
                              activeColor: primary,
                              inactiveColor: Colors.white12,
                            ),
                          ),
                          const Icon(Icons.volume_up_rounded, color: C.muted, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Lista
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: p.allAsmrTracks.length,
                itemBuilder: (ctx, i) {
                  final track = p.allAsmrTracks[i];
                  final isActive = p.activeAsmr?.id == track.id;
                  return GestureDetector(
                    onTap: () => p.selectAsmr(track),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isActive ? primary.withOpacity(0.12) : C.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isActive ? primary.withOpacity(0.4) : Colors.white12,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: isActive ? primary.withOpacity(0.2) : Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(track.emoji, style: const TextStyle(fontSize: 22)),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(track.name,
                                    style: const TextStyle(color: C.text, fontSize: 14, fontWeight: FontWeight.w600)),
                                Text(
                                  track.isUserUpload ? 'Tu audio' : 'Integrado',
                                  style: TextStyle(
                                    color: track.isUserUpload ? primary : C.muted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (track.isUserUpload)
                            GestureDetector(
                              onTap: () => p.removeUserTrack(track.id),
                              child: const Icon(Icons.delete_outline_rounded, color: C.muted, size: 20),
                            )
                          else
                            Icon(
                              isActive && p.asmrPlaying
                                  ? Icons.pause_circle_outline_rounded
                                  : Icons.play_circle_outline_rounded,
                              color: isActive ? primary : C.muted,
                              size: 24,
                            ),
                        ],
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

  void _showUploadDialog(BuildContext context, SleepProvider p) {
    final nameCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Subir audio MP3',
                style: TextStyle(color: C.text, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text(
              'Usa la app Archivos de iOS para compartir tu MP3 a AuraSleep, o pega el nombre aqui para registrarlo.',
              style: TextStyle(color: C.muted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: C.text),
              decoration: InputDecoration(
                hintText: 'Nombre del audio',
                hintStyle: const TextStyle(color: C.muted),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: p.theme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  if (name.isNotEmpty) {
                    p.addUserTrack(name, 'user/' + name + '.mp3');
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Agregar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
