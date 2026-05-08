import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sleep_provider.dart';
import '../theme/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SleepProvider>();
    final primary = p.theme.primary;

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ajustes',
                style: TextStyle(color: C.text, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1),
              ),
              const SizedBox(height: 8),
              const Text('Personaliza AuraSleep', style: TextStyle(color: C.muted, fontSize: 14)),
              const SizedBox(height: 32),

              // ── Tema ──────────────────────────────────
              _SectionTitle('Tema de color'),
              const SizedBox(height: 12),
              Row(
                children: AppTheme.values.map((t) {
                  final active = p.theme == t;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => p.setTheme(t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: active ? t.primary.withOpacity(0.2) : C.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: active ? t.primary : Colors.white12,
                            width: active ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(t.emoji, style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 4),
                            Text(
                              t.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: active ? t.primary : C.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // ── Audio ─────────────────────────────────
              _SectionTitle('Audio'),
              const SizedBox(height: 12),
              _SettingsTile(
                icon: p.useSpeaker ? Icons.volume_up_rounded : Icons.headphones_rounded,
                title: 'Salida de audio',
                subtitle: p.useSpeaker ? 'Altavoz del movil' : 'Solo auriculares',
                trailing: Switch(
                  value: p.useSpeaker,
                  onChanged: (_) => p.toggleSpeaker(),
                  activeColor: primary,
                  inactiveTrackColor: Colors.white12,
                ),
              ),
              const SizedBox(height: 8),
              _SettingsTile(
                icon: Icons.nightlight_round,
                title: 'Modo Sueno Profundo',
                subtitle: p.deepSleepMode ? 'Activo' : 'Desactivado',
                trailing: Switch(
                  value: p.deepSleepMode,
                  onChanged: (_) => p.toggleDeepSleep(),
                  activeColor: primary,
                  inactiveTrackColor: Colors.white12,
                ),
              ),
              const SizedBox(height: 28),

              // ── Info ──────────────────────────────────
              _SectionTitle('Informacion'),
              const SizedBox(height: 12),
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'Version',
                subtitle: '1.0.0',
              ),
              const SizedBox(height: 8),
              _SettingsTile(
                icon: Icons.music_note_rounded,
                title: 'Frecuencias disponibles',
                subtitle: '29 frecuencias en 6 categorias',
              ),
              const SizedBox(height: 8),
              _SettingsTile(
                icon: Icons.headset_rounded,
                title: 'Sonidos ASMR integrados',
                subtitle: '8 paisajes sonoros',
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: C.muted,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
    ),
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: C.muted, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: C.text, fontSize: 14, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(color: C.muted, fontSize: 12)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
