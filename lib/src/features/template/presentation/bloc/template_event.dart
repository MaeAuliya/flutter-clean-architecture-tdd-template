part of 'template_bloc.dart';

abstract class TemplateEvent extends Equatable {
  const TemplateEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentTemplateVersionEvent extends TemplateEvent {
  const GetCurrentTemplateVersionEvent();
}

class OpenGithubUrlEvent extends TemplateEvent {
  const OpenGithubUrlEvent();
}

class SplashScreenMoveEvent extends TemplateEvent {
  const SplashScreenMoveEvent();
}
