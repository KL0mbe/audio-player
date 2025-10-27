import 'package:audio_player/ui/widgets/app_defaults/my_app_bar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Settings Screen", onBackClick: () => Navigator.pop(context)),
    );
  }
}
