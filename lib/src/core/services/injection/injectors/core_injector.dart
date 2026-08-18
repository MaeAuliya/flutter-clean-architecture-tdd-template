import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../logging/app_logger.dart';
import '../../url_launcher_gateway/url_launcher_gateway.dart';
import '../injection_container.dart';

class CoreInjector implements Injector {
  const CoreInjector();

  @override
  Future<void> inject(GetIt sl) async {
    const api = API();
    api.validate();

    final preference = await SharedPreferences.getInstance();
    final dio = Dio(
      BaseOptions(
        baseUrl: api.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    final packageInfo = await PackageInfo.fromPlatform();

    sl
      ..registerLazySingleton(() => preference)
      ..registerLazySingleton(() => dio)
      ..registerLazySingleton(() => api)
      ..registerLazySingleton(() => packageInfo)
      // Core Services
      ..registerLazySingleton<AppLogger>(DebugAppLogger.new)
      ..registerLazySingleton<UrlLauncherGateway>(UrlLauncherGatewayImpl.new);
  }
}
