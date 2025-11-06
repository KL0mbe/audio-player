class FileData {
  FileData({
    required this.id,
    required this.path,
    required this.fastForward,
    required this.rewind,
    this.lastPosition = 0,
    this.isSkip = false,
    this.speed = 1,
  });

  final int id;
  final String path;
  final int fastForward;
  final int rewind;
  final double lastPosition;
  final bool isSkip;
  final double speed;

  factory FileData.fromMap(Map<String, Object?> map) {
    return FileData(
      id: map["id"] as int,
      path: map["path"] as String,
      fastForward: map["fast_forward"] as int,
      rewind: map["rewind"] as int,
      lastPosition: map["last_position"] as double,
      isSkip: (map["is_skip"] as int) == 1,
      speed: map["speed"] as double,
    );
  }
}
