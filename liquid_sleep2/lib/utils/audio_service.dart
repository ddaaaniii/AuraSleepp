import 'dart:math';
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class BinauralEngine {
  final _players = <String, AudioPlayer>{};
  bool _running = false;
  double _volume = 0.7;

  bool get isRunning => _running;
  double get masterVolume => _volume;

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
    ));
  }

  /// Plays a binaural beat: left ear = baseHz, right ear = baseHz + beatHz
  /// In production: generate PCM via dart:ffi C plugin or use prerecorded tones
  Future<void> playFrequency(String id, double hz) async {
    if (_players.containsKey(id)) {
      await _players[id]!.play();
      return;
    }
    final player = AudioPlayer();
    _players[id] = player;
    // TODO: swap with actual generated tone asset or C-generated PCM stream
    // await player.setAudioSource(GeneratedToneSource(hz: hz));
    // await player.setLoopMode(LoopMode.all);
    // await player.setVolume(_volume);
    // await player.play();
    _running = true;
  }

  Future<void> stopFrequency(String id) async {
    await _players[id]?.stop();
    _players.remove(id);
    if (_players.isEmpty) _running = false;
  }

  Future<void> stopAll() async {
    for (final p in _players.values) await p.stop();
    _players.clear();
    _running = false;
  }

  Future<void> setVolume(double v) async {
    _volume = v;
    for (final p in _players.values) await p.setVolume(v);
  }

  Future<void> pauseAll() async {
    for (final p in _players.values) await p.pause();
    _running = false;
  }

  Future<void> resumeAll() async {
    for (final p in _players.values) await p.play();
    if (_players.isNotEmpty) _running = true;
  }

  void dispose() {
    for (final p in _players.values) p.dispose();
    _players.clear();
  }
}
