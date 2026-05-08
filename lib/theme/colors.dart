import 'package:flutter/material.dart';

enum AppTheme { purple, pink, blue, red }

extension AppThemeExt on AppTheme {
  String get label {
    switch (this) {
      case AppTheme.purple: return 'Aurora';
      case AppTheme.pink:   return 'Rosa';
      case AppTheme.blue:   return 'Oceano';
      case AppTheme.red:    return 'Fuego';
    }
  }
  String get emoji {
    switch (this) {
      case AppTheme.purple: return '🌙';
      case AppTheme.pink:   return '🌸';
      case AppTheme.blue:   return '🌊';
      case AppTheme.red:    return '🔥';
    }
  }
  Color get primary {
    switch (this) {
      case AppTheme.purple: return const Color(0xFF6C63FF);
      case AppTheme.pink:   return const Color(0xFFFF6CAB);
      case AppTheme.blue:   return const Color(0xFF48BEFF);
      case AppTheme.red:    return const Color(0xFFFF4D6D);
    }
  }
  Color get secondary {
    switch (this) {
      case AppTheme.purple: return const Color(0xFF48BEFF);
      case AppTheme.pink:   return const Color(0xFFFFB347);
      case AppTheme.blue:   return const Color(0xFF43E97B);
      case AppTheme.red:    return const Color(0xFFFF9A44);
    }
  }
  List<Color> get gradient {
    switch (this) {
      case AppTheme.purple: return [const Color(0xFF1A0533), const Color(0xFF050508)];
      case AppTheme.pink:   return [const Color(0xFF330A1A), const Color(0xFF050508)];
      case AppTheme.blue:   return [const Color(0xFF031A33), const Color(0xFF050508)];
      case AppTheme.red:    return [const Color(0xFF330A0A), const Color(0xFF050508)];
    }
  }
}

class C {
  static const bg      = Color(0xFF050508);
  static const surface = Color(0xFF0D0D18);
  static const card    = Color(0xFF12121F);
  static const border  = Color(0x1AFFFFFF);
  static const text    = Color(0xFFEEEEFF);
  static const muted   = Color(0xFF7A7A9A);
  static const faint   = Color(0xFF3A3A5C);
  static const primary = Color(0xFF6C63FF);
  static const accent  = Color(0xFF6C63FF);
  static const red     = Color(0xFFFF4D6D);
  static const green   = Color(0xFF43E97B);
  static const textMuted = Color(0xFF7A7A9A);
}
