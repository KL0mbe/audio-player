import 'package:path/path.dart';
import 'dart:convert';

class FileData {
  FileData({
    required this.id,
    required this.path,
    required this.title,
    required this.author,
    required this.cover,
    required this.fastForward,
    required this.rewind,
    this.lastPosition = 0,
    this.isSkip = false,
    this.speed = 1,
  });

  final int id;
  final String path;
  final String title;
  final List<String> author;
  final String cover;
  final int fastForward;
  final int rewind;
  final double lastPosition;
  final bool isSkip;
  final double speed;

  factory FileData.fromMap(Map<String, Object?> map) {
    final decoded = jsonDecode(map["author"] as String);
    return FileData(
      id: map["id"] as int,
      path: map["path"] as String,
      title: (map["title"] as String) != ""
          ? (map["title"] as String)
          : basenameWithoutExtension(map["path"] as String),
      author: List<String>.from((decoded is List && decoded.isNotEmpty) ? decoded : ["Unknown"]),
      // could get lib dir in here and set it right away
      cover: map["cover"] as String,
      fastForward: map["fast_forward"] as int,
      rewind: map["rewind"] as int,
      lastPosition: map["last_position"] as double,
      isSkip: (map["is_skip"] as int) == 1,
      speed: map["speed"] as double,
    );
  }
}
