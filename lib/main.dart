import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/sleep_provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/library_screen.dart';
import 'screens/mix_screen.dart';
import 'screens/stats_screen.dart';
import 'widgets/glass_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    ChangeNotifierProvider(
      create: (_) => SleepProvider()..init(),
      child: const LiquidSleepApp(),
    ),
  );
}

class LiquidSleepApp extends StatelessWidget {
  const LiquidSleepApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Liquid Sleep',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    home: const MainShell(),
  );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  static const _screens = [HomeScreen(), LibraryScreen(), MixScreen(), StatsScreen()];
  static const _navItems = [
    (Icons.home_rounded,          'Inicio'),
    (Icons.library_music_rounded, 'Biblioteca'),
    (Icons.tune_rounded,          'Mezcla'),
    (Icons.bar_chart_rounded,     'Stats'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [C.primary.withOpacity(0.4), C.secondary.withOpacity(0.15)]),
                      border: Border.all(color: C.border),
                    ),
                    child: const Center(child: Text('◉', style: TextStyle(color: C.primary, fontSize: 14))),
                  ),
                  const SizedBox(width: 8),
                  const Text('Liquid Sleep', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.text, letterSpacing: -0.4)),
                ]),
                GlassPill(text: _navItems[_index].$2),
              ],
            ),
          ),
        ),
      ),
      body: Stack(children: [
        const _LiquidBackground(),
        SafeArea(
          bottom: false, top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: IndexedStack(index: _index, children: _screens),
          ),
        ),
      ]),
      bottomNavigationBar: _GlassNav(index: _index, items: _navItems, onTap: (i) => setState(() => _index = i)),
    );
  }
}

class _GlassNav extends StatelessWidget {
  final int index;
  final List<(IconData, String)> items;
  final ValueChanged<int> onTap;
  const _GlassNav({required this.index, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(context).padding.bottom + 12),
    child: GlassCard(
      radius: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((e) {
          final active = e.key == index;
          return GestureDetector(
            onTap: () => onTap(e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: active ? Colors.white.withOpacity(0.08) : Colors.transparent,
                border: active ? Border.all(color: C.border) : null,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(e.value.$1, size: 22, color: active ? C.text : C.faint),
                const SizedBox(height: 3),
                Text(e.value.$2, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: active ? C.text : C.faint)),
              ]),
            ),
          );
        }).toList(),
      ),
    ),
  );
}

class _LiquidBackground extends StatefulWidget {
  const _LiquidBackground();
  @override
  State<_LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<_LiquidBackground> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 14))..repeat();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => CustomPaint(painter: _BgPainter(_ctrl.value), child: const SizedBox.expand()),
  );
}

class _BgPainter extends CustomPainter {
  final double t;
  _BgPainter(this.t);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = C.bg);
    final orbs = [
      (0.15, 0.12, const Color(0xFF7CE6FF), 0.11),
      (0.85, 0.18, const Color(0xFF9F7BFF), 0.13),
      (0.50, 0.92, const Color(0xFF5476FF), 0.09),
    ];
    for (final (ox, oy, color, alpha) in orbs) {
      final x = ox * size.width  + sin(t * 2 * pi) * size.width  * 0.04;
      final y = oy * size.height + cos(t * 2 * pi * 0.7) * size.height * 0.04;
      final r = 0.28 * size.shortestSide;
      canvas.drawCircle(
        Offset(x, y), r,
        Paint()
          ..shader = RadialGradient(colors: [color.withOpacity(alpha), color.withOpacity(0)])
              .createShader(Rect.fromCircle(center: Offset(x, y), radius: r))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50),
      );
    }
  }
  @override
  bool shouldRepaint(_BgPainter o) => o.t != t;
}
