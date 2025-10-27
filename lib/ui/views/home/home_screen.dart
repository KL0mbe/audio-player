import 'package:audio_player/ui/views/home/playback_section.dart';
import 'package:audio_player/ui/widgets/app_defaults/my_body_text.dart';
import 'package:audio_player/ui/widgets/app_defaults/my_text_button.dart';
import 'package:audio_player/ui/widgets/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: MyBodyText.semiBold("Audio Player")),
      drawer: Drawer(
        width: 150.h,
        child: Column(
          children: [
            Gap(64.h),
            MyTextButton("Files", onPressed: () {}),
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
              MyBodyText.semiBold("Title"),
              Gap(24.h),
              SizedBox(
                width: 300,
                height: 300,
                child: Image(image: AssetImage("assets/files/Screenshot 2025-10-26 at 15.06.26.png")),
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
