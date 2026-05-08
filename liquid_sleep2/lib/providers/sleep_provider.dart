import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../models/frequency.dart';
import '../utils/audio_service.dart';

enum TimerOption { t15, t30, t60, off }

extension TimerOptionExt on TimerOption {
  String get label => const ['15m','30m','1h','OFF'][index];
  int? get minutes => const [15,30,60,null][index];
}

class SleepProvider extends ChangeNotifier {
  final _engine = BinauralEngine();
  SharedPreferences? _prefs;

  // --- State ---
  bool _isPlaying = false;
  double _volume = 0.70;
  Frequency? _activeFreq;
  final List<Frequency> _mix = [];
  FreqCategory _libraryFilter = FreqCategory.all;
  TimerOption _timer = TimerOption.off;
  bool _deepSleepMode = false;
  int _sessionCount = 12;
  int _totalHours = 48;
  int _streak = 7;

  // --- Getters ---
  bool get isPlaying => _isPlaying;
  double get volume => _volume;
  Frequency? get activeFreq => _activeFreq;
  List<Frequency> get mix => List.unmodifiable(_mix);
  FreqCategory get libraryFilter => _libraryFilter;
  TimerOption get timer => _timer;
  bool get deepSleepMode => _deepSleepMode;
  int get sessionCount => _sessionCount;
  int get totalHours => _totalHours;
  int get streak => _streak;

  List<Frequency> get filteredFrequencies => _libraryFilter == FreqCategory.all
      ? allFrequencies
      : allFrequencies.where((f) => f.category == _libraryFilter).toList();

  List<Frequency> get favorites => allFrequencies.where((f) => f.isFavorite).toList();

  Future<void> init() async {
    await _engine.init();
    _prefs = await SharedPreferences.getInstance();
    _volume = (_prefs?.getDouble('volume') ?? 0.70);
    final savedFavs = _prefs?.getStringList('favorites') ?? [];
    for (final f in allFrequencies) {
      if (savedFavs.contains(f.id)) f.isFavorite = true;
    }
    _activeFreq = allFrequencies.firstWhere((f) => f.id == 'd2', orElse: () => allFrequencies.first);
    notifyListeners();
  }

  // --- Playback ---
  Future<void> togglePlay() async {
    if (_isPlaying) {
      await _engine.pauseAll();
      _isPlaying = false;
    } else {
      if (_activeFreq != null) await _engine.playFrequency(_activeFreq!.id, _activeFreq!.hz);
      _isPlaying = true;
      _sessionCount++;
    }
    _haptic(light: true);
    notifyListeners();
  }

  void selectFrequency(Frequency f) {
    _activeFreq = f;
    if (_isPlaying) _engine.playFrequency(f.id, f.hz);
    _haptic(light: true);
    notifyListeners();
  }

  // --- Mix ---
  void addToMix(Frequency f) {
    if (!_mix.any((m) => m.id == f.id)) {
      _mix.add(f);
      f.isInMix = true;
      _haptic(light: true);
      notifyListeners();
    }
  }

  void removeFromMix(Frequency f) {
    _mix.removeWhere((m) => m.id == f.id);
    f.isInMix = false;
    notifyListeners();
  }

  void clearMix() {
    for (final f in _mix) f.isInMix = false;
    _mix.clear();
    notifyListeners();
  }

  Future<void> playMix() async {
    if (_mix.isEmpty) return;
    for (final f in _mix) await _engine.playFrequency(f.id, f.hz);
    _isPlaying = true;
    _haptic(light: false);
    notifyListeners();
  }

  // --- Quick Preset ---
  void applyPreset(QuickPreset preset) {
    final freqs = allFrequencies.where((f) => preset.freqIds.contains(f.id)).toList();
    clearMix();
    for (final f in freqs) addToMix(f);
    if (freqs.isNotEmpty) selectFrequency(freqs.first);
    _haptic(light: false);
  }

  // --- Favorites ---
  void toggleFavorite(Frequency f) {
    f.isFavorite = !f.isFavorite;
    final favIds = allFrequencies.where((x) => x.isFavorite).map((x) => x.id).toList();
    _prefs?.setStringList('favorites', favIds);
    _haptic(light: true);
    notifyListeners();
  }

  // --- Volume ---
  void setVolume(double v) {
    _volume = v;
    _engine.setVolume(v);
    _prefs?.setDouble('volume', v);
    notifyListeners();
  }

  // --- Timer ---
  void setTimer(TimerOption t) {
    _timer = t;
    notifyListeners();
  }

  // --- Filter ---
  void setFilter(FreqCategory cat) {
    _libraryFilter = cat;
    notifyListeners();
  }

  // --- Deep Sleep Mode ---
  void toggleDeepSleep() {
    _deepSleepMode = !_deepSleepMode;
    if (_deepSleepMode) {
      final d2 = allFrequencies.firstWhere((f) => f.id == 'd2');
      selectFrequency(d2);
      setTimer(TimerOption.t60);
      if (!_isPlaying) togglePlay();
    }
    _haptic(light: false);
    notifyListeners();
  }

  Future<void> _haptic({required bool light}) async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: light ? 8 : 16, amplitude: light ? 60 : 100);
    }
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }
}
