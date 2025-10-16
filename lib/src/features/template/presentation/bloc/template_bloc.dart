import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/template_version.dart';
import '../../domain/usecases/get_current_template_version.dart';
import '../../domain/usecases/open_github_url.dart';

part 'template_event.dart';
part 'template_state.dart';

class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  final GetCurrentTemplateVersion _getCurrentTemplateVersion;
  final OpenGithubUrl _openGithubUrl;

  TemplateBloc({
    required GetCurrentTemplateVersion getCurrentTemplateVersion,
    required OpenGithubUrl openGithubUrl,
  }) : _getCurrentTemplateVersion = getCurrentTemplateVersion,
       _openGithubUrl = openGithubUrl,
       super(const TemplateInit()) {
    on<GetCurrentTemplateVersionEvent>(_getCurrentTemplateVersionHandler);
    on<OpenGithubUrlEvent>(_openGithubUrlHandler);
    on<SplashScreenMoveEvent>(_splashScreenMoveHandler);
  }

  Future<void> _getCurrentTemplateVersionHandler(
    GetCurrentTemplateVersionEvent event,
    Emitter<TemplateState> emit,
  ) async {
    emit(const GetCurrentTemplateVersionLoading());
    final result = await _getCurrentTemplateVersion.call();
    result.fold(
      (failure) => emit(GetCurrentTemplateVersionError(failure.message)),
      (version) => emit(GetCurrentTemplateVersionSuccess(version)),
    );
  }

  Future<void> _openGithubUrlHandler(
    OpenGithubUrlEvent event,
    Emitter<TemplateState> emit,
  ) async {
    final result = await _openGithubUrl.call();
    result.fold(
      (failure) => emit(OpenGithubUrlError(failure.message)),
      (_) => emit(const OpenGithubUrlSuccess()),
    );
  }

  Future<void> _splashScreenMoveHandler(
    SplashScreenMoveEvent event,
    Emitter<TemplateState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 2));
    emit(const SplashScreenDone());
  }
}
