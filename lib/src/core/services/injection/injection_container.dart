import 'package:get_it/get_it.dart';

import 'injectors/core_injector.dart';

final sl = GetIt.instance;

abstract class Injector {
  Future<void> inject(GetIt sl);
}

class InjectionContainer {
  static const _injectors = <Injector>[
    // All Injectors modules

    // All Injectors features
  ];

  static Future<void> init(GetIt sl) async {
    await const CoreInjector().inject(sl);
    await Future.wait(_injectors.map((i) => i.inject(sl)));
  }
}
