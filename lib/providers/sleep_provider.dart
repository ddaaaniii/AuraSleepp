import 'package:flutter/material.dart';
import '../models/frequency.dart';
import '../theme/colors.dart';

class AsmrTrack {
  final String id;
  final String name;
  final String emoji;
  final String assetPath; // vacío si es upload del usuario
  final bool isUserUpload;

  const AsmrTrack({
    required this.id,
    required this.name,
    required this.emoji,
    this.assetPath = '',
    this.isUserUpload = false,
  });
}

const List<AsmrTrack> builtinAsmr = [
  AsmrTrack(id: 'rain',    name: 'Lluvia suave',    emoji: '🌧',  assetPath: 'assets/audio/rain.mp3'),
  AsmrTrack(id: 'ocean',   name: 'Oceano',          emoji: '🌊',  assetPath: 'assets/audio/ocean.mp3'),
  AsmrTrack(id: 'forest',  name: 'Bosque',          emoji: '🌲',  assetPath: 'assets/audio/forest.mp3'),
  AsmrTrack(id: 'fire',    name: 'Chimenea',        emoji: '🔥',  assetPath: 'assets/audio/fire.mp3'),
  AsmrTrack(id: 'wind',    name: 'Viento',          emoji: '💨',  assetPath: 'assets/audio/wind.mp3'),
  AsmrTrack(id: 'thunder', name: 'Tormenta',        emoji: '⛈',   assetPath: 'assets/audio/thunder.mp3'),
  AsmrTrack(id: 'cafe',    name: 'Cafe concurrido', emoji: '☕',  assetPath: 'assets/audio/cafe.mp3'),
  AsmrTrack(id: 'space',   name: 'Espacio',         emoji: '🌌',  assetPath: 'assets/audio/space.mp3'),
];

class SleepProvider extends ChangeNotifier {
  Frequency?       _activeFreq;
  bool             _isPlaying     = false;
  double           _volume        = 0.7;
  TimerOption      _timer         = TimerOption.off;
  bool             _deepSleepMode = false;
  final List<Frequency> _mix      = [];
  FreqCategory     _libraryFilter = FreqCategory.all;
  int              _sessionCount  = 0;
  int              _totalMinutes  = 0;
  int              _streak        = 0;
  AppTheme         _theme         = AppTheme.purple;
  bool             _useSpeaker    = true;  // true = altavoz, false = solo cascos
  AsmrTrack?       _activeAsmr;
  bool             _asmrPlaying   = false;
  double           _asmrVolume    = 0.5;
  final List<AsmrTrack> _userTracks = [];

  Frequency?       get activeFreq          => _activeFreq;
  bool             get isPlaying           => _isPlaying;
  double           get volume              => _volume;
  TimerOption      get timer               => _timer;
  bool             get deepSleepMode       => _deepSleepMode;
  List<Frequency>  get mix                 => List.unmodifiable(_mix);
  FreqCategory     get libraryFilter       => _libraryFilter;
  int              get sessionCount        => _sessionCount;
  int              get totalSessionMinutes => _totalMinutes;
  int              get streak              => _streak;
  AppTheme         get theme               => _theme;
  bool             get useSpeaker          => _useSpeaker;
  AsmrTrack?       get activeAsmr          => _activeAsmr;
  bool             get asmrPlaying         => _asmrPlaying;
  double           get asmrVolume          => _asmrVolume;
  List<AsmrTrack>  get userTracks          => List.unmodifiable(_userTracks);
  List<AsmrTrack>  get allAsmrTracks       => [...builtinAsmr, ..._userTracks];

  void init() {
    _activeFreq = allFrequencies.first;
    notifyListeners();
  }

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

  void selectFreq(Frequency f) {
    _activeFreq = f;
    _isPlaying  = true;
    _sessionCount++;
    notifyListeners();
  }

  void selectFrequency(Frequency f) => selectFreq(f);

  void togglePlay() {
    _activeFreq ??= allFrequencies.first;
    _isPlaying = !_isPlaying;
    if (_isPlaying) _sessionCount++;
    notifyListeners();
  }

  void setVolume(double v)       { _volume = v; notifyListeners(); }
  void setTimer(TimerOption t)   { _timer = t; notifyListeners(); }
  void toggleDeepSleep()         { _deepSleepMode = !_deepSleepMode; notifyListeners(); }
  void setTheme(AppTheme t)      { _theme = t; notifyListeners(); }
  void toggleSpeaker()           { _useSpeaker = !_useSpeaker; notifyListeners(); }

  void selectAsmr(AsmrTrack t)   { _activeAsmr = t; _asmrPlaying = true; notifyListeners(); }
  void toggleAsmr()              { _asmrPlaying = !_asmrPlaying; notifyListeners(); }
  void setAsmrVolume(double v)   { _asmrVolume = v; notifyListeners(); }

  void addUserTrack(String name, String path) {
    final track = AsmrTrack(
      id: 'user_' + DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      emoji: '🎵',
      assetPath: path,
      isUserUpload: true,
    );
    _userTracks.add(track);
    notifyListeners();
  }

  void removeUserTrack(String id) {
    _userTracks.removeWhere((t) => t.id == id);
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
