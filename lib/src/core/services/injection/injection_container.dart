import 'package:get_it/get_it.dart';

import 'injectors/core_injector.dart';
import 'injectors/template_injector.dart';// GENERATED INJECTOR IMPORTS - DO NOT REMOVE

final sl = GetIt.instance;

abstract class Injector {
  Future<void> inject(GetIt sl);
}

class InjectionContainer {
  static const _injectors = <Injector>[// GENERATED MODULE INJECTORS - DO NOT REMOVE// GENERATED FEATURE INJECTORS - DO NOT REMOVE
    TemplateInjector(),
  ];

  static Future<void> init(GetIt sl) async {
    await const CoreInjector().inject(sl);
    await Future.wait(_injectors.map((i) => i.inject(sl)));
  }
}
