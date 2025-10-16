import 'package:equatable/equatable.dart';

class TemplateVersion extends Equatable {
  final String appName;
  final String version;
  final String buildNumber;

  const TemplateVersion({
    required this.appName,
    required this.version,
    required this.buildNumber,
  });

  @override
  List<Object?> get props => [
    appName,
    version,
    buildNumber,
  ];
}
