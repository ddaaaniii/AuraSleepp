import 'package:flutter/material.dart';

enum FrequencyCategory { deepSleep, theta, alpha, beta, gamma, special }

enum FreqCategory { all, sleep, theta, alpha, beta, gamma, special }

extension FrequencyCategoryExt on FrequencyCategory {
  String get label {
    switch (this) {
      case FrequencyCategory.deepSleep: return 'Sueño Profundo';
      case FrequencyCategory.theta:     return 'Theta';
      case FrequencyCategory.alpha:     return 'Alpha';
      case FrequencyCategory.beta:      return 'Beta';
      case FrequencyCategory.gamma:     return 'Gamma';
      case FrequencyCategory.special:   return 'Especiales';
    }
  }
  String get emoji {
    switch (this) {
      case FrequencyCategory.deepSleep: return '🌙';
      case FrequencyCategory.theta:     return '🌊';
      case FrequencyCategory.alpha:     return '🍃';
      case FrequencyCategory.beta:      return '⚡';
      case FrequencyCategory.gamma:     return '✨';
      case FrequencyCategory.special:   return '🎵';
    }
  }
  Color get color {
    switch (this) {
      case FrequencyCategory.deepSleep: return const Color(0xFF6C63FF);
      case FrequencyCategory.theta:     return const Color(0xFF48BEFF);
      case FrequencyCategory.alpha:     return const Color(0xFF43E97B);
      case FrequencyCategory.beta:      return const Color(0xFFFF9A44);
      case FrequencyCategory.gamma:     return const Color(0xFFFF6CAB);
      case FrequencyCategory.special:   return const Color(0xFFFFD700);
    }
  }
}

class QuickPreset {
  final String label;
  final String emoji;
  final List<String> freqIds;
  const QuickPreset({required this.label, required this.emoji, required this.freqIds});
}

const List<QuickPreset> quickPresets = [
  QuickPreset(label: 'Sueño', emoji: '🌙', freqIds: ['d2', 'd3', 't1']),
  QuickPreset(label: 'Focus', emoji: '⚡', freqIds: ['b1', 'b2']),
  QuickPreset(label: 'Meditación', emoji: '🧘', freqIds: ['t2', 'a1']),
  QuickPreset(label: '432 Hz', emoji: '🎵', freqIds: ['s5']),
  QuickPreset(label: '528 Hz', emoji: '✨', freqIds: ['s7']),
];

class Frequency {
  final String id;
  final double hz;
  final String name;
  final String description;
  final FrequencyCategory category;
  bool isFavorite;
  bool isInMix;

  Frequency({
    required this.id,
    required this.hz,
    required this.name,
    required this.description,
    required this.category,
    this.isFavorite = false,
    this.isInMix = false,
  });

  String get hzDisplay {
    if (hz < 10) return '${hz.toStringAsFixed(1)} Hz';
    return '${hz.toInt()} Hz';
  }

  String get label => name;
  String get categoryLabel => category.label;
  Color get color => category.color;
}

final List<Frequency> allFrequencies = [
  Frequency(id: 'd1', hz: 0.5, name: 'Delta 0.5 Hz', description: 'Sueño profundo máximo',    category: FrequencyCategory.deepSleep),
  Frequency(id: 'd2', hz: 1.0, name: 'Delta 1 Hz',   description: 'Recuperación celular',     category: FrequencyCategory.deepSleep),
  Frequency(id: 'd3', hz: 2.0, name: 'Delta 2 Hz',   description: 'Sueño reparador',          category: FrequencyCategory.deepSleep),
  Frequency(id: 'd4', hz: 3.0, name: 'Delta 3 Hz',   description: 'Regeneración profunda',    category: FrequencyCategory.deepSleep),
  Frequency(id: 'd5', hz: 4.0, name: 'Delta 4 Hz',   description: 'Transición al sueño',      category: FrequencyCategory.deepSleep),
  Frequency(id: 't1', hz: 4.0, name: 'Theta 4 Hz',   description: 'Meditación profunda',      category: FrequencyCategory.theta),
  Frequency(id: 't2', hz: 5.0, name: 'Theta 5 Hz',   description: 'Creatividad REM',          category: FrequencyCategory.theta),
  Frequency(id: 't3', hz: 6.0, name: 'Theta 6 Hz',   description: 'Intuición y sueños',       category: FrequencyCategory.theta),
  Frequency(id: 't4', hz: 7.0, name: 'Theta 7 Hz',   description: 'Estado hipnótico',         category: FrequencyCategory.theta),
  Frequency(id: 'a1', hz: 8.0,  name: 'Alpha 8 Hz',  description: 'Relajación consciente',    category: FrequencyCategory.alpha),
  Frequency(id: 'a2', hz: 10.0, name: 'Alpha 10 Hz', description: 'Calma y claridad',         category: FrequencyCategory.alpha),
  Frequency(id: 'a3', hz: 12.0, name: 'Alpha 12 Hz', description: 'Flujo mental',             category: FrequencyCategory.alpha),
  Frequency(id: 'b1', hz: 14.0, name: 'Beta 14 Hz',  description: 'Atención activa',          category: FrequencyCategory.beta),
  Frequency(id: 'b2', hz: 18.0, name: 'Beta 18 Hz',  description: 'Concentración plena',      category: FrequencyCategory.beta),
  Frequency(id: 'b3', hz: 20.0, name: 'Beta 20 Hz',  description: 'Procesamiento rápido',     category: FrequencyCategory.beta),
  Frequency(id: 'g1', hz: 30.0, name: 'Gamma 30 Hz', description: 'Insights y epifanías',     category: FrequencyCategory.gamma),
  Frequency(id: 'g2', hz: 40.0, name: 'Gamma 40 Hz', description: 'Consciencia plena',        category: FrequencyCategory.gamma),
  Frequency(id: 'g3', hz: 80.0, name: 'Gamma 80 Hz', description: 'Hiper-consciencia',        category: FrequencyCategory.gamma),
  Frequency(id: 's1',  hz: 174.0, name: '174 Hz',  description: 'Alivio del dolor',           category: FrequencyCategory.special),
  Frequency(id: 's2',  hz: 285.0, name: '285 Hz',  description: 'Regeneración tisular',       category: FrequencyCategory.special),
  Frequency(id: 's3',  hz: 396.0, name: '396 Hz',  description: 'Liberar el miedo',           category: FrequencyCategory.special),
  Frequency(id: 's4',  hz: 417.0, name: '417 Hz',  description: 'Facilitar el cambio',        category: FrequencyCategory.special),
  Frequency(id: 's5',  hz: 432.0, name: '432 Hz',  description: 'Armonía universal',          category: FrequencyCategory.special),
  Frequency(id: 's6',  hz: 440.0, name: '440 Hz',  description: 'Estándar musical',           category: FrequencyCategory.special),
  Frequency(id: 's7',  hz: 528.0, name: '528 Hz',  description: 'Reparación del ADN',         category: FrequencyCategory.special),
  Frequency(id: 's8',  hz: 639.0, name: '639 Hz',  description: 'Relaciones y amor',          category: FrequencyCategory.special),
  Frequency(id: 's9',  hz: 741.0, name: '741 Hz',  description: 'Expresión y solución',       category: FrequencyCategory.special),
  Frequency(id: 's10', hz: 852.0, name: '852 Hz',  description: 'Intuición espiritual',       category: FrequencyCategory.special),
  Frequency(id: 's11', hz: 963.0, name: '963 Hz',  description: 'Consciencia divina',         category: FrequencyCategory.special),
];
