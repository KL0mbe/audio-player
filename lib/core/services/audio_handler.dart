import 'package:path_provider/path_provider.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';
import 'dart:io';

Future<AudioHandler> initAudioHandler() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(fastForwardInterval: Duration(seconds: 15), rewindInterval: Duration(seconds: 15)),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  AudioPlayer get player => _player;

  MyAudioHandler() {
    _init();
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  @override
  Future<void> play() async => await _player.play();

  @override
  Future<void> pause() async => await _player.pause();

  @override
  Future<void> seek(Duration position) async => await _player.seek(position);

  @override
  Future<void> fastForward() async {
    await _player.seek(
      Duration(seconds: min((_player.position + Duration(seconds: 15)).inSeconds, _player.duration!.inSeconds)),
    );
  }

  @override
  Future<void> rewind() async =>
      await _player.seek(Duration(seconds: max((_player.position - Duration(seconds: 15)).inSeconds, 0)));

  @override
  Future<void> skipToNext() async => await fastForward();

  @override
  Future<void> skipToPrevious() async => await rewind();

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> playMediaItem(MediaItem item) async {
    final libDir = await getLibraryDirectory();
    final stableDir = Directory("${libDir.path}/media");
    final path = "${stableDir.path}/${item.extras?["path"]}";
    final exists = await File(path).exists();
    print("Play path: $path");
    print("Exists on disk: $exists");
    mediaItem.add(item);

    await _player.setAudioSource(AudioSource.file(path));
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(
        playbackState.value.copyWith(
          systemActions: {
            MediaAction.pause,
            MediaAction.play,
            MediaAction.seek,
            MediaAction.fastForward,
            MediaAction.rewind,
            MediaAction.skipToNext,
            MediaAction.skipToPrevious,
          },
          processingState: {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_player.processingState]!,
          playing: playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
          queueIndex: event.currentIndex,
        ),
      );
    });
  }
}
