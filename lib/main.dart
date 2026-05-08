import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/sleep_provider.dart';
import 'screens/home_screen.dart';
import 'screens/library_screen.dart';
import 'screens/asmr_screen.dart';
import 'screens/mix_screen.dart';
import 'screens/settings_screen.dart';
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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: C.bg,
        colorScheme: const ColorScheme.dark(primary: C.primary),
      ),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: C.surface.withOpacity(0.95),
          border: const Border(top: BorderSide(color: Colors.white12)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? primary : C.muted, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active ? primary : C.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
