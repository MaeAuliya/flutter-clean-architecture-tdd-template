import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/utils/core_utils.dart';
import '../bloc/template_bloc.dart';
import '../views/template_view.dart';

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  static const routeName = '/template';

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  @override
  void initState() {
    context.templateProvider.init();
    context.templateBloc.add(const GetCurrentTemplateVersionEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: BlocListener<TemplateBloc, TemplateState>(
          listener: (context, state) {
            if (state is GetCurrentTemplateVersionError) {
              CoreUtils.showSnackBar(
                context: context,
                message: state.errorMessage,
                isError: true,
              );
            } else if (state is OpenGithubUrlError) {
              CoreUtils.showSnackBar(
                context: context,
                message: state.errorMessage,
                isError: true,
              );
            } else if (state is GetCurrentTemplateVersionSuccess) {
              context.templateProvider.updateTemplateVersion(
                state.templateVersion,
              );
            }
          },
          child: const TemplateView(),
        ),
      ),
    );
  }
}
