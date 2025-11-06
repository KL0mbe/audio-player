import 'package:audio_player/core/services/database_service.dart';
import 'package:audio_player/core/providers/audio_provider.dart';
import 'package:audio_player/core/services/audio_handler.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class AppInit {
  AppInit._();

  static Future<void> init() async {
    getIt.registerSingleton<DatabaseService>(DatabaseService());
    await getIt<DatabaseService>().init();
    getIt.registerSingleton<AudioProvider>(AudioProvider());
    await getIt<AudioProvider>().init();
    getIt.registerSingleton<AudioHandler>(await initAudioHandler());
  }
}
