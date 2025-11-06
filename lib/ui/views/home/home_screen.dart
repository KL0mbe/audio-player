import 'package:audio_player/ui/widgets/app_defaults/my_text_button.dart';
import 'package:audio_player/ui/widgets/app_defaults/my_body_text.dart';
import 'package:audio_player/ui/views/home/playback_section.dart';
import 'package:audio_player/ui/views/files/files_screen.dart';
import 'package:audio_player/ui/widgets/settings_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_player/core/app_init.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static final audioHandler = getIt<AudioHandler>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: MyBodyText.semiBold("Audio Player")),
      drawer: Drawer(
        width: 150.h,
        child: Column(
          children: [
            Gap(64.h),
            MyTextButton(
              "Files",
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FilesScreen())),
            ),
            Gap(12.h),
            MyTextButton(
              "Settings",
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen())),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              Gap(64.h),
              MyBodyText.semiBold("${audioHandler.mediaItem.value?.title}"),
              Gap(24.h),
              SizedBox(
                width: 300.h,
                height: 300.h,
                child: Image(image: AssetImage("assets/files/avatar.png")),
              ),
              Gap(24.h),
              PlaybackSection(),
            ],
          ),
        ),
      ),
    );
  }
}
