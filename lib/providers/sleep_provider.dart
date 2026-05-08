import 'package:flutter/material.dart';
import '../models/frequency.dart';

class SleepProvider extends ChangeNotifier {
  Frequency? _activeFreq;
  bool _isPlaying = false;
  double _volume = 0.7;
  int _timerMinutes = 0;
  int _elapsed = 0;
  final List<Frequency> _mix = [];
  FreqCategory _libraryFilter = FreqCategory.all;
  int _sessionCount = 0;
  int _totalSessionMinutes = 0;
  int _streak = 0;

  Frequency? get activeFreq       => _activeFreq;
  bool       get isPlaying        => _isPlaying;
  double     get volume           => _volume;
  int        get timerMinutes     => _timerMinutes;
  int        get elapsed          => _elapsed;
  List<Frequency> get mix         => List.unmodifiable(_mix);
  FreqCategory get libraryFilter  => _libraryFilter;
  int        get sessionCount     => _sessionCount;
  int        get totalSessionMinutes => _totalSessionMinutes;
  int        get streak           => _streak;

  List<Frequency> get filteredFrequencies => _libraryFilter == FreqCategory.all
      ? allFrequencies
      : allFrequencies.where((f) {
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

  void selectFreq(Frequency f) {
    _activeFreq = f;
    _isPlaying = true;
    _sessionCount++;
    notifyListeners();
  }

  void togglePlay() {
    if (_activeFreq == null) {
      _activeFreq = allFrequencies.first;
    }
    _isPlaying = !_isPlaying;
    if (_isPlaying) _sessionCount++;
    notifyListeners();
  }

  void setVolume(double v) {
    _volume = v;
    notifyListeners();
  }

  void setTimer(int minutes) {
    _timerMinutes = minutes;
    notifyListeners();
  }

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
    if (freqs.isNotEmpty) {
      _activeFreq = freqs.first;
      _isPlaying = true;
      _sessionCount++;
    }
    notifyListeners();
  }

  void applyPreset(QuickPreset preset) {
    clearMix();
    final freqs = allFrequencies.where((f) => preset.freqIds.contains(f.id)).toList();
    for (final f in freqs) addToMix(f);
    if (freqs.isNotEmpty) {
      _activeFreq = freqs.first;
      _isPlaying = true;
      _sessionCount++;
    }
    notifyListeners();
  }

  void toggleFavorite(Frequency f) {
    f.isFavorite = !f.isFavorite;
    notifyListeners();
  }

  void setFilter(FreqCategory cat) {
    _libraryFilter = cat;
    notifyListeners();
  }

  void addSessionMinutes(int mins) {
    _totalSessionMinutes += mins;
    notifyListeners();
  }
}
