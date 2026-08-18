import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/template_bloc.dart';
import '../providers/template_provider.dart';

extension TemplateContextExtension on BuildContext {
  TemplateBloc get templateBloc => read<TemplateBloc>();

  TemplateProvider get templateProvider => read<TemplateProvider>();
}
