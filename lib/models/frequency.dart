enum FreqCategory { all, sleep, theta, alpha, beta, gamma, special }

class Frequency {
  final String id;
  final double hz;
  final String label;
  final String categoryLabel;
  final String description;
  final FreqCategory category;
  final Color color;
  bool isFavorite;
  bool isInMix;

  Frequency({
    required this.id, required this.hz, required this.label,
    required this.categoryLabel, required this.description,
    required this.category, required this.color,
    this.isFavorite = false, this.isInMix = false,
  });

  String get hzDisplay => hz < 100 ? '${hz % 1 == 0 ? hz.toInt() : hz} Hz' : '${hz.toInt()} Hz';
}

import 'package:flutter/material.dart';

final List<Frequency> allFrequencies = [
  // Sleep / Delta
  Frequency(id:'d05', hz:0.5,  label:'Sueño extremo',    categoryLabel:'Delta',   description:'Inducción al sueño más profundo. Regeneración celular máxima.',           category:FreqCategory.sleep,   color:const Color(0xFF6B8EFF)),
  Frequency(id:'d1',  hz:1.0,  label:'Inducción lenta',   categoryLabel:'Delta',   description:'Transición suave al sueño profundo. Relajación total.',                   category:FreqCategory.sleep,   color:const Color(0xFF7B9FFF)),
  Frequency(id:'d2',  hz:2.0,  label:'Sueño profundo',    categoryLabel:'Delta',   description:'Ondas delta para inducir el sueño más profundo y restaurador.',           category:FreqCategory.sleep,   color:const Color(0xFF8AABFF), isFavorite:true),
  Frequency(id:'d3',  hz:3.0,  label:'Calma corporal',    categoryLabel:'Delta',   description:'Relajación muscular profunda. Restauración física.',                      category:FreqCategory.sleep,   color:const Color(0xFF9BB8FF)),
  Frequency(id:'d4',  hz:4.0,  label:'Puerta Theta',      categoryLabel:'Delta',   description:'Umbral entre sueño y meditación. Creatividad subconsciente.',             category:FreqCategory.sleep,   color:const Color(0xFFAAC4FF)),
  // Theta
  Frequency(id:'t5',  hz:5.0,  label:'Insight',           categoryLabel:'Theta',   description:'Estado de insight y procesamiento de memoria. Creatividad profunda.',     category:FreqCategory.theta,   color:const Color(0xFFBB88FF)),
  Frequency(id:'t6',  hz:6.0,  label:'Astral',            categoryLabel:'Theta',   description:'Expansión de consciencia. Meditación profunda y viaje interior.',        category:FreqCategory.theta,   color:const Color(0xFFCC99FF)),
  Frequency(id:'t7',  hz:7.0,  label:'Esquemas',          categoryLabel:'Theta',   description:'Procesamiento de recuerdos y esquemas mentales. Aprendizaje REM.',       category:FreqCategory.theta,   color:const Color(0xFFDDABFF)),
  // Alpha
  Frequency(id:'a8',  hz:8.0,  label:'Alpha puro',        categoryLabel:'Alpha',   description:'Calma mental plena. Estado de alerta relajada y receptividad.',          category:FreqCategory.alpha,   color:const Color(0xFF55DDCC)),
  Frequency(id:'a10', hz:10.0, label:'Anti-estrés',       categoryLabel:'Alpha',   description:'Reducción de estrés y ansiedad. Estado de flujo mental óptimo.',        category:FreqCategory.alpha,   color:const Color(0xFF66EED8)),
  Frequency(id:'a12', hz:12.0, label:'Flow',              categoryLabel:'Alpha',   description:'Estado de flujo creativo. Concentración relajada y productiva.',         category:FreqCategory.alpha,   color:const Color(0xFF77FFEE)),
  // Beta
  Frequency(id:'b14', hz:14.0, label:'Focus',             categoryLabel:'Beta',    description:'Concentración activa y pensamiento lógico. Ideal para estudiar.',        category:FreqCategory.beta,    color:const Color(0xFFFFCC44)),
  Frequency(id:'b18', hz:18.0, label:'Deep Work',         categoryLabel:'Beta',    description:'Máxima productividad y procesamiento rápido. Análisis profundo.',        category:FreqCategory.beta,    color:const Color(0xFFFFDD66)),
  Frequency(id:'b20', hz:20.0, label:'Alerta total',      categoryLabel:'Beta',    description:'Alerta máxima y reacción rápida. Deportes y rendimiento.',               category:FreqCategory.beta,    color:const Color(0xFFFFEE88)),
  // Gamma
  Frequency(id:'g30', hz:30.0, label:'Lucidez',           categoryLabel:'Gamma',   description:'Lucidez expandida y percepción ampliada. Consciencia plena.',            category:FreqCategory.gamma,   color:const Color(0xFFFF8877)),
  Frequency(id:'g40', hz:40.0, label:'Consciencia',       categoryLabel:'Gamma',   description:'Consciencia plena y meditación avanzada. Integración cognitiva.',        category:FreqCategory.gamma,   color:const Color(0xFFFF9988)),
  Frequency(id:'g80', hz:80.0, label:'Gamma alto',        categoryLabel:'Gamma',   description:'Estado meditativo avanzado. Procesamiento neural de alta velocidad.',    category:FreqCategory.gamma,   color:const Color(0xFFFFAA99)),
  // Solfeggio / Special
  Frequency(id:'s174', hz:174.0, label:'Anti-dolor',      categoryLabel:'Solfeggio', description:'Reduce el dolor y el estrés. Base de seguridad y bienestar.',           category:FreqCategory.special, color:const Color(0xFF88CCFF)),
  Frequency(id:'s285', hz:285.0, label:'Sanación',        categoryLabel:'Solfeggio', description:'Regeneración de tejidos y sanación celular. Restauración física.',      category:FreqCategory.special, color:const Color(0xFF99DDFF)),
  Frequency(id:'s396', hz:396.0, label:'Liberación',      categoryLabel:'Solfeggio', description:'Libera el miedo y la culpa. Transforma el dolor en alegría.',           category:FreqCategory.special, color:const Color(0xFFAAEEFF)),
  Frequency(id:'s417', hz:417.0, label:'Cambio',          categoryLabel:'Solfeggio', description:'Facilita el cambio positivo. Deshace situaciones negativas.',           category:FreqCategory.special, color:const Color(0xFF66DDBB)),
  Frequency(id:'s432', hz:432.0, label:'Tierra',          categoryLabel:'Solfeggio', description:'Afinación natural del universo. Armonía con la naturaleza.',            category:FreqCategory.special, color:const Color(0xFF77EECC)),
  Frequency(id:'s440', hz:440.0, label:'Estándar',        categoryLabel:'Solfeggio', description:'Afinación convencional. Base de la música moderna occidental.',         category:FreqCategory.special, color:const Color(0xFF88FFDD)),
  Frequency(id:'s528', hz:528.0, label:'Amor / ADN',      categoryLabel:'Solfeggio', description:'Frecuencia del amor y reparación del ADN. Transformación milagrosa.',   category:FreqCategory.special, color:const Color(0xFFBB88FF), isFavorite:true),
  Frequency(id:'s639', hz:639.0, label:'Conexión',        categoryLabel:'Solfeggio', description:'Relaciones interpersonales y amor. Armonía social y comunicación.',     category:FreqCategory.special, color:const Color(0xFFCC99FF)),
  Frequency(id:'s741', hz:741.0, label:'Intuición',       categoryLabel:'Solfeggio', description:'Despertar de la intuición y expresión. Solución de problemas.',         category:FreqCategory.special, color:const Color(0xFF9988FF)),
  Frequency(id:'s852', hz:852.0, label:'Espiritual',      categoryLabel:'Solfeggio', description:'Retorno al orden espiritual. Consciencia superior y claridad.',         category:FreqCategory.special, color:const Color(0xFFAA99FF)),
  Frequency(id:'s963', hz:963.0, label:'Corona',          categoryLabel:'Solfeggio', description:'Conexión con lo divino. Activación del tercer ojo y chakra corona.',   category:FreqCategory.special, color:const Color(0xFFBBAEFF)),
];

class QuickPreset {
  final String title, subtitle, emoji;
  final List<String> freqIds;
  const QuickPreset({required this.title, required this.subtitle, required this.emoji, required this.freqIds});
}

const quickPresets = [
  QuickPreset(title:'Sueño profundo', subtitle:'2 Hz · 396 Hz', emoji:'🌙', freqIds:['d2','s396']),
  QuickPreset(title:'Concentración',  subtitle:'18 Hz · 528 Hz', emoji:'⚡', freqIds:['b18','s528']),
  QuickPreset(title:'Meditación',     subtitle:'6 Hz · 432 Hz',  emoji:'🔮', freqIds:['t6','s432']),
  QuickPreset(title:'Sanación',       subtitle:'528 Hz · 852 Hz', emoji:'✨', freqIds:['s528','s852']),
];
