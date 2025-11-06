import 'package:audio_player/core/services/database_service.dart';
import 'package:audio_player/core/models/file_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_player/core/app_init.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';

class AudioProvider extends ChangeNotifier {
  final dbService = getIt<DatabaseService>();

  FileData? _currentFile;
  FileData? get currentFile => _currentFile;

  List<FileData> _files = [];
  List<FileData> get files => _files;

  Future<void> init() async {
    await loadFiles();
    await loadCurrentFile();
  }

  Future<void> loadCurrentFile() async {
    _currentFile = await dbService.getCurrentFile();
    if (_currentFile != null) {
      setCurrentFile(_currentFile!);
      notifyListeners();
    }
  }

  Future<void> loadFiles() async {
    _files = await dbService.getFiles();
    notifyListeners();
  }

  Future<void> setCurrentFile(FileData file) async {
    // passing file might be stale (somehow) so use id and get the file
    await dbService.setCurrentFile(file.id);
    final mediaItem = MediaItem(id: file.id.toString(), title: file.path, extras: {'path': file.path});
    await getIt<AudioHandler>().playMediaItem(mediaItem);
    _currentFile = file;
    notifyListeners();
  }

  Future<void> pickFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final libDir = await getLibraryDirectory();
    final stableDir = Directory("${libDir.path}/media");
    if (!await stableDir.exists()) await stableDir.create(recursive: true);

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      initialDirectory: dir.path,
      type: FileType.custom,
      allowedExtensions: [
        // audio files
        "mp3", "m4a", "aac", "wav", "flac",
        // video files
        "mp4", "m4v", "mov", "avi", "mkv",
      ],
    );

    if (result == null) return;

    final files = result.paths.map((path) => File(path!)).toList();
    for (final file in files) {
      final basePath = basename(file.path);
      final dest = File("${stableDir.path}/${basename(file.path)}");

      if (await dbService.containsFile(basePath)) continue;

      await file.copy(dest.path);
      // bool isSong = ["mp3", "m4a", "aac", "wav", "flac"].contains(extension(file.path));
      await dbService.insertFile(basePath);
    }
    await loadFiles();
  }
}
