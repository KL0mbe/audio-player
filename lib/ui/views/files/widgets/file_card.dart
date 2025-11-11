import 'package:audio_player/ui/widgets/app_defaults/my_body_text.dart';
import 'package:audio_player/core/providers/audio_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audio_player/core/models/file_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class FileCard extends StatelessWidget {
  const FileCard({required this.file, super.key});
  final FileData file;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: GestureDetector(
        onTap: () async => await context.read<AudioProvider>().setCurrentFile(file),
        child: Container(
          padding: EdgeInsetsGeometry.all(8.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r), color: Colors.blueGrey),
          child: MyBodyText(basename(file.title)),
        ),
      ),
    );
  }
}
