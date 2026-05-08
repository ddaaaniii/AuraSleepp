import 'package:flutter/material.dart';

enum FrequencyCategory { deepSleep, theta, alpha, beta, gamma, special }

enum FreqCategory { all, sleep, theta, alpha, beta, gamma, special }

extension FrequencyCategoryExt on FrequencyCategory {
  String get label {
    switch (this) {
      case FrequencyCategory.deepSleep:
        return 'Sueno Profundo';
      case FrequencyCategory.theta:
        return 'Theta';
      case FrequencyCategory.alpha:
        return 'Alpha';
      case FrequencyCategory.beta:
        return 'Beta';
      case FrequencyCategory.gamma:
        return 'Gamma';
      case FrequencyCategory.special:
        return 'Especiales';
    }
  }

  String get emoji {
    switch (this) {
      case FrequencyCategory.deepSleep:
        return '🌙';
      case FrequencyCategory.theta:
        return '🌊';
      case FrequencyCategory.alpha:
        return '🍃';
      case FrequencyCategory.beta:
        return '⚡';
      case FrequencyCategory.gamma:
        return '✨';
      case FrequencyCategory.special:
        return '🎵';
    }
  }

  Color get color {
    switch (this) {
      case FrequencyCategory.deepSleep:
        return const Color(0xFF6C63FF);
      case FrequencyCategory.theta:
        return const Color(0xFF48BEFF);
      case FrequencyCategory.alpha:
        return const Color(0xFF43E97B);
      case FrequencyCategory.beta:
        return const Color(0xFFFF9A44);
      case FrequencyCategory.gamma:
        return const Color(0xFFFF6CAB);
      case FrequencyCategory.special:
        return const Color(0xFFFFD700);
    }
  }
}

enum TimerOption {
  off(0, 'Off'),
  t15(15, '15 min'),
  t30(30, '30 min'),
  t45(45, '45 min'),
  t60(60, '1 hora'),
  t90(90, '1.5 h');

  final int minutes;
  final String label;
  const TimerOption(this.minutes, this.label);
}

class QuickPreset {
  final String title;
  final String subtitle;
  final String emoji;
  final List<String> freqIds;
  const QuickPreset({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.freqIds,
  });
  String get label => title;
}

const List<QuickPreset> quickPresets = [
  QuickPreset(
      title: 'Sueno profundo',
      subtitle: 'Delta + Theta',
      emoji: '🌙',
      freqIds: ['d2', 'd3', 't1']),
  QuickPreset(
      title: 'Concentracion',
      subtitle: 'Beta 14-18 Hz',
      emoji: '⚡',
      freqIds: ['b1', 'b2']),
  QuickPreset(
      title: 'Meditacion',
      subtitle: 'Theta + Alpha',
      emoji: '🧘',
      freqIds: ['t2', 'a1']),
  QuickPreset(
      title: 'Armonia 432',
      subtitle: '432 Hz Solfeo',
      emoji: '🎵',
      freqIds: ['s5']),
  QuickPreset(
      title: 'Reparacion', subtitle: '528 Hz ADN', emoji: '✨', freqIds: ['s7']),
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
    if (hz < 10) {
      return hz.toStringAsFixed(1) + ' Hz';
    }
    return hz.toInt().toString() + ' Hz';
  }

  String get label => name;
  String get categoryLabel => category.label;
  Color get color => category.color;
}

final List<Frequency> allFrequencies = [
  Frequency(
      id: 'd1',
      hz: 0.5,
      name: 'Delta 0.5 Hz',
      description: 'Ideal para sueño profundo',
      category: FrequencyCategory.deepSleep),
  Frequency(
      id: 'd2',
      hz: 1.0,
      name: 'Delta 1 Hz',
      description: 'Asociado con reparación suave',
      category: FrequencyCategory.deepSleep),
  Frequency(
      id: 'd3',
      hz: 2.0,
      name: 'Delta 2 Hz',
      description: 'Apoya el descanso profundo',
      category: FrequencyCategory.deepSleep),
  Frequency(
      id: 'd4',
      hz: 3.0,
      name: 'Delta 3 Hz',
      description: 'Orientado a restauración',
      category: FrequencyCategory.deepSleep),
  Frequency(
      id: 'd5',
      hz: 4.0,
      name: 'Delta 4 Hz',
      description: 'Facilita la entrada al sueño',
      category: FrequencyCategory.deepSleep),
  Frequency(
      id: 't1',
      hz: 4.0,
      name: 'Theta 4 Hz',
      description: 'Asociado a estados meditativos',
      category: FrequencyCategory.theta),
  Frequency(
      id: 't2',
      hz: 5.0,
      name: 'Theta 5 Hz',
      description: 'Ideal para creatividad tranquila',
      category: FrequencyCategory.theta),
  Frequency(
      id: 't3',
      hz: 6.0,
      name: 'Theta 6 Hz',
      description: 'Asociado a sueños lúcidos',
      category: FrequencyCategory.theta),
  Frequency(
      id: 't4',
      hz: 7.0,
      name: 'Theta 7 Hz',
      description: 'Orientado a calma interior',
      category: FrequencyCategory.theta),
  Frequency(
      id: 'a1',
      hz: 8.0,
      name: 'Alpha 8 Hz',
      description: 'Ideal para relajación serena',
      category: FrequencyCategory.alpha),
  Frequency(
      id: 'a2',
      hz: 10.0,
      name: 'Alpha 10 Hz',
      description: 'Asociado a calma mental',
      category: FrequencyCategory.alpha),
  Frequency(
      id: 'a3',
      hz: 12.0,
      name: 'Alpha 12 Hz',
      description: 'Ideal para flujo mental',
      category: FrequencyCategory.alpha),
  Frequency(
      id: 'b1',
      hz: 14.0,
      name: 'Beta 14 Hz',
      description: 'Asociado a concentración',
      category: FrequencyCategory.beta),
  Frequency(
      id: 'b2',
      hz: 18.0,
      name: 'Beta 18 Hz',
      description: 'Apoya la atención sostenida',
      category: FrequencyCategory.beta),
  Frequency(
      id: 'b3',
      hz: 20.0,
      name: 'Beta 20 Hz',
      description: 'Ideal para trabajo ágil',
      category: FrequencyCategory.beta),
  Frequency(
      id: 'g1',
      hz: 30.0,
      name: 'Gamma 30 Hz',
      description: 'Asociado a claridad mental',
      category: FrequencyCategory.gamma),
  Frequency(
      id: 'g2',
      hz: 40.0,
      name: 'Gamma 40 Hz',
      description: 'Orientado a presencia',
      category: FrequencyCategory.gamma),
  Frequency(
      id: 'g3',
      hz: 80.0,
      name: 'Gamma 80 Hz',
      description: 'Asociado a enfoque elevado',
      category: FrequencyCategory.gamma),
  Frequency(
      id: 's1',
      hz: 174.0,
      name: '174 Hz',
      description: 'Ideal para calma corporal',
      category: FrequencyCategory.special),
  Frequency(
      id: 's2',
      hz: 285.0,
      name: '285 Hz',
      description: 'Orientado a bienestar físico',
      category: FrequencyCategory.special),
  Frequency(
      id: 's3',
      hz: 396.0,
      name: '396 Hz',
      description: 'Asociado a tranquilidad',
      category: FrequencyCategory.special),
  Frequency(
      id: 's4',
      hz: 417.0,
      name: '417 Hz',
      description: 'Ideal para transición',
      category: FrequencyCategory.special),
  Frequency(
      id: 's5',
      hz: 432.0,
      name: '432 Hz',
      description: 'Orientado a equilibrio',
      category: FrequencyCategory.special),
  Frequency(
      id: 's6',
      hz: 440.0,
      name: '440 Hz',
      description: 'Estandar musical',
      category: FrequencyCategory.special),
  Frequency(
      id: 's7',
      hz: 528.0,
      name: '528 Hz',
      description: 'Asociado a armonía celular',
      category: FrequencyCategory.special),
  Frequency(
      id: 's8',
      hz: 639.0,
      name: '639 Hz',
      description: 'Ideal para conexiones suaves',
      category: FrequencyCategory.special),
  Frequency(
      id: 's9',
      hz: 741.0,
      name: '741 Hz',
      description: 'Orientado a claridad creativa',
      category: FrequencyCategory.special),
  Frequency(
      id: 's10',
      hz: 852.0,
      name: '852 Hz',
      description: 'Asociado a intuición serena',
      category: FrequencyCategory.special),
  Frequency(
      id: 's11',
      hz: 963.0,
      name: '963 Hz',
      description: 'Orientado a bienestar interior',
      category: FrequencyCategory.special),
];
