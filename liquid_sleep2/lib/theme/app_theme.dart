import 'package:flutter/material.dart';

class C {
  static const bg        = Color(0xFF04050A);
  static const surface   = Color(0xFF0E1018);
  static const surface2  = Color(0xFF141820);
  static const border    = Color(0x1EFFFFFF);
  static const borderHi  = Color(0x35FFFFFF);
  static const text      = Color(0xF0F5F7FF);
  static const muted     = Color(0xAAB8C8E8);
  static const faint     = Color(0x66A0B4D0);
  static const primary   = Color(0xFF7B9FFF);
  static const secondary = Color(0xFF9B6FFF);
  static const cyan      = Color(0xFF5FD8FF);
  static const green     = Color(0xFF4FDDAA);
  static const amber     = Color(0xFFFFBB55);
  static const red       = Color(0xFFFF6B8A);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: C.bg,
    fontFamily: 'SF Pro Display',
    colorScheme: const ColorScheme.dark(
      primary: C.primary, secondary: C.secondary,
      surface: C.surface, onSurface: C.text,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, letterSpacing: -2.5, color: C.text, height: 1.0),
      displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -1.5, color: C.text),
      titleLarge:   TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.6, color: C.text),
      titleMedium:  TextStyle(fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: -0.3, color: C.text),
      bodyLarge:    TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: C.muted, height: 1.55),
      bodyMedium:   TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: C.muted),
      labelSmall:   TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.08, color: C.faint),
    ),
    sliderTheme: SliderThemeData(
      trackHeight: 4,
      activeTrackColor: C.primary,
      inactiveTrackColor: Colors.white.withOpacity(0.1),
      thumbColor: Colors.white,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
      overlayColor: C.primary.withOpacity(0.15),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? C.primary : Colors.white.withOpacity(0.1)),
    ),
  );
}
