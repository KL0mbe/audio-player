import 'package:audio_player/ui/widgets/app_defaults/my_body_text.dart';
import 'package:audio_player/ui/widgets/app_defaults/my_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';

class PlaybackSection extends StatefulWidget {
  const PlaybackSection({super.key});

  @override
  State<PlaybackSection> createState() => _PlaybackSectionState();
}

class _PlaybackSectionState extends State<PlaybackSection> {
  final _player = AudioPlayer();
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _init();
    _player.positionStream.listen((p) => setState(() => position = p));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    try {
      await AudioPlayer.clearAssetCache();
      await _player.setAsset('assets/files/Colter Wall  Summer Wages  Western AF.mp3');
    } on PlayerException catch (e) {
      print("Error loading Audio Source $e");
    }
  }

  String formatDuration(Duration duration) {
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, "0")} : ${seconds.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Slider(
            value: position.inSeconds.toDouble(),
            min: 0,
            max: _player.duration!.inSeconds.toDouble(),
            onChanged: (newValue) => _player.seek(Duration(seconds: newValue.toInt())),
            // onChangeEnd: (newValue) => _player.seek(Duration(seconds: newValue.toInt())),
          ),
        ),
        Gap(12.h),
        // MyBodyText("${_player.positionStream.listen((position) => setState(() => _position = position))}"),
        MyBodyText(formatDuration(_player.position)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MyIconButton(
              icon: Icons.fast_rewind,
              onPressed: () => _player.seek(_player.position - Duration(seconds: 15)),
            ),
            MyIconButton(
              icon: _player.playing ? Icons.pause : Icons.play_arrow,
              onPressed: () {
                _player.playing ? _player.pause() : _player.play();
                setState(() {});
              },
            ),
            MyIconButton(
              icon: Icons.fast_forward,
              onPressed: () => _player.seek(_player.position + Duration(seconds: 15)),
            ),
          ],
        ),
      ],
    );
  }
}
