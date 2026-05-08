import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/sleep_provider.dart';
import 'screens/home_screen.dart';
import 'screens/library_screen.dart';
import 'screens/asmr_screen.dart';
import 'screens/mix_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';
import 'theme/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(
    ChangeNotifierProvider(
      create: (_) => SleepProvider()..init(),
      child: const AuraSleepApp(),
    ),
  );
}

class AuraSleepApp extends StatelessWidget {
  const AuraSleepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuraSleep',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const _RootNav(),
    );
  }
}

class _RootNav extends StatefulWidget {
  const _RootNav();
  @override
  State<_RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<_RootNav> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    LibraryScreen(),
    AsmrScreen(),
    MixScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SleepProvider>();
    final primary = p.theme.primary;

    return Scaffold(
      backgroundColor: C.bg,
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: PhysicalModel(
          color: Colors.transparent,
          shadowColor: Colors.black38,
          elevation: 24,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            decoration: BoxDecoration(
              color: C.surface.withOpacity(0.96),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                _NavItem(icon: Icons.home_rounded,            label: 'Inicio',    index: 0, current: _index, primary: primary, onTap: (i) => setState(() => _index = i)),
                _NavItem(icon: Icons.library_music_rounded,   label: 'Biblioteca',index: 1, current: _index, primary: primary, onTap: (i) => setState(() => _index = i)),
                _NavItem(icon: Icons.headset_mic_rounded,     label: 'ASMR',      index: 2, current: _index, primary: primary, onTap: (i) => setState(() => _index = i)),
                _NavItem(icon: Icons.tune_rounded,            label: 'Mezcla',    index: 3, current: _index, primary: primary, onTap: (i) => setState(() => _index = i)),
                _NavItem(icon: Icons.settings_rounded,        label: 'Ajustes',   index: 4, current: _index, primary: primary, onTap: (i) => setState(() => _index = i)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final Color primary;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? primary.withOpacity(0.16) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? primary : C.muted, size: active ? 26 : 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? primary : C.muted,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 4,
              width: 26,
              decoration: BoxDecoration(
                color: active ? primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
