import 'package:flutter/material.dart';
import '../models/frequency.dart';

class SleepProvider extends ChangeNotifier {
  // ── Estado ────────────────────────────────────────────
  Frequency?   _activeFreq;
  bool         _isPlaying      = false;
  double       _volume         = 0.7;
  TimerOption  _timer          = TimerOption.off;
  bool         _deepSleepMode  = false;
  final List<Frequency> _mix   = [];
  FreqCategory _libraryFilter  = FreqCategory.all;
  int          _sessionCount   = 0;
  int          _totalMinutes   = 0;
  int          _streak         = 0;

  // ── Getters ───────────────────────────────────────────
  Frequency?   get activeFreq          => _activeFreq;
  bool         get isPlaying           => _isPlaying;
  double       get volume              => _volume;
  TimerOption  get timer               => _timer;
  bool         get deepSleepMode       => _deepSleepMode;
  List<Frequency> get mix              => List.unmodifiable(_mix);
  FreqCategory get libraryFilter       => _libraryFilter;
  int          get sessionCount        => _sessionCount;
  int          get totalSessionMinutes => _totalMinutes;
  int          get streak              => _streak;

  // ── Init ──────────────────────────────────────────────
  void init() {
    _activeFreq = allFrequencies.first;
    notifyListeners();
  }

  // ── Filtrado ──────────────────────────────────────────
  List<Frequency> get filteredFrequencies {
    if (_libraryFilter == FreqCategory.all) return allFrequencies;
    return allFrequencies.where((f) {
      switch (_libraryFilter) {
        case FreqCategory.sleep:   return f.category == FrequencyCategory.deepSleep;
        case FreqCategory.theta:   return f.category == FrequencyCategory.theta;
        case FreqCategory.alpha:   return f.category == FrequencyCategory.alpha;
        case FreqCategory.beta:    return f.category == FrequencyCategory.beta;
        case FreqCategory.gamma:   return f.category == FrequencyCategory.gamma;
        case FreqCategory.special: return f.category == FrequencyCategory.special;
        default:                   return true;
      }
    }).toList();
  }

  // ── Acciones ──────────────────────────────────────────
  void selectFreq(Frequency f) {
    _activeFreq = f;
    _isPlaying  = true;
    _sessionCount++;
    notifyListeners();
  }

  // alias usado por library_screen
  void selectFrequency(Frequency f) => selectFreq(f);

  void togglePlay() {
    _activeFreq ??= allFrequencies.first;
    _isPlaying = !_isPlaying;
    if (_isPlaying) _sessionCount++;
    notifyListeners();
  }

  void setVolume(double v) { _volume = v; notifyListeners(); }

  void setTimer(TimerOption t) { _timer = t; notifyListeners(); }

  void toggleDeepSleep() { _deepSleepMode = !_deepSleepMode; notifyListeners(); }

  void addToMix(Frequency f) {
    if (_mix.length >= 3 || _mix.any((m) => m.id == f.id)) return;
    f.isInMix = true;
    _mix.add(f);
    notifyListeners();
  }

  void removeFromMix(Frequency f) {
    f.isInMix = false;
    _mix.removeWhere((m) => m.id == f.id);
    notifyListeners();
  }

  void clearMix() {
    for (final f in _mix) f.isInMix = false;
    _mix.clear();
    notifyListeners();
  }

  void playMix(List<Frequency> freqs) {
    clearMix();
    for (final f in freqs) addToMix(f);
    if (freqs.isNotEmpty) { _activeFreq = freqs.first; _isPlaying = true; _sessionCount++; }
    notifyListeners();
  }

  void applyPreset(QuickPreset preset) {
    clearMix();
    final freqs = allFrequencies.where((f) => preset.freqIds.contains(f.id)).toList();
    for (final f in freqs) addToMix(f);
    if (freqs.isNotEmpty) { _activeFreq = freqs.first; _isPlaying = true; _sessionCount++; }
    notifyListeners();
  }

  void toggleFavorite(Frequency f) { f.isFavorite = !f.isFavorite; notifyListeners(); }

  void setFilter(FreqCategory cat) { _libraryFilter = cat; notifyListeners(); }

  void addSessionMinutes(int mins) { _totalMinutes += mins; notifyListeners(); }
}
