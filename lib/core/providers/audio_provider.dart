import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:audio_player/core/services/database_service.dart';
import 'package:audio_player/core/models/file_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_player/core/app_init.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';

class AudioProvider extends ChangeNotifier {
  final dbService = getIt<DatabaseService>();

  FileData? _currentFile;
  FileData? get currentFile => _currentFile;

  List<FileData> _files = [];
  List<FileData> get files => _files;
  late Directory libDirectory;

  String get coverPath => '${libDirectory.path}/media/${currentFile!.cover}';

  Future<void> init() async {
    await loadFiles();
    await loadCurrentFile();
    // for testing only not permanent solution
    // refactor to cache directory in app init
    libDirectory = await getLibraryDirectory();
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
    final mediaItem = MediaItem(
      id: file.id.toString(),
      title: file.title,
      artist: file.author.first,
      extras: {'path': file.path, "coverPath": file.cover},
    );
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
      final metadata = await MetadataRetriever.fromFile(dest);
      final mimeType = lookupMimeType("", headerBytes: metadata.albumArt);
      final ext = mimeType?.split("/").last ?? "png";
      final coverPath = "${basenameWithoutExtension(dest.path)}_cover.$ext";
      if (metadata.albumArt != null) {
        await File("${stableDir.path}/$coverPath").writeAsBytes(metadata.albumArt!);
      } else {
        final data = await rootBundle.load("assets/media/avatar.png");
        final bytes = data.buffer.asUint8List();
        File("${stableDir.path}/$coverPath").writeAsBytes(bytes);
      }
      // bool isSong = ["mp3", "m4a", "aac", "wav", "flac"].contains(extension(file.path));
      await dbService.insertFile(basePath, metadata.trackName ?? "", jsonEncode(metadata.trackArtistNames), coverPath);
    }
    await loadFiles();
  }
}
