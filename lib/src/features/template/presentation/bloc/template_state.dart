part of 'template_bloc.dart';

abstract class TemplateState extends Equatable {
  const TemplateState();

  @override
  List<Object?> get props => [];
}

final class TemplateInit extends TemplateState {
  const TemplateInit();
}

final class GetCurrentTemplateVersionSuccess extends TemplateState {
  final TemplateVersion templateVersion;

  const GetCurrentTemplateVersionSuccess(this.templateVersion);

  @override
  List<Object?> get props => [templateVersion];
}

final class GetCurrentTemplateVersionLoading extends TemplateState {
  const GetCurrentTemplateVersionLoading();
}

final class GetCurrentTemplateVersionError extends TemplateState {
  final String errorMessage;

  const GetCurrentTemplateVersionError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

final class OpenGithubUrlSuccess extends TemplateState {
  const OpenGithubUrlSuccess();
}

final class OpenGithubUrlError extends TemplateState {
  final String errorMessage;

  const OpenGithubUrlError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

final class SplashScreenDone extends TemplateState {
  const SplashScreenDone();
}
