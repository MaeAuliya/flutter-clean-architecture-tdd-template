import '../../file_template.dart';
import '../../name_case.dart';

class RouteRegistryTemplate extends CoreTemplateGen {
  @override
  String featureTpl(NameCase n) =>
      '''
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/${n.snake}/presentation/bloc/${n.snake}_bloc.dart';
import '../../../../features/${n.snake}/presentation/screens/${n.snake}_screen.dart';
import '../../injection/injection_container.dart';
import '../app_route.dart';

class ${n.pascal}RouteRegistry implements FeatureRouteRegistry {
  const ${n.pascal}RouteRegistry();

  @override
  List<AppRoute> get routes => [
        AppRoute(
          name: ${n.pascal}Screen.routeName,
          builder: (context, settings) => BlocProvider(
            create: (_) => sl<${n.pascal}Bloc>(),
            child: const ${n.pascal}Screen(),
          ),
        ),

        // GENERATED ${n.upperSnake} FEATURE ROUTES - DO NOT REMOVE
      ];
}
''';

  @override
  String? moduleTpl(NameCase n) => null;
}
