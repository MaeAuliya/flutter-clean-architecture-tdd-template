import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/template/data/datasources/template_local_data_source.dart';
import '../../../features/template/data/datasources/template_remote_data_source.dart';
import '../../../features/template/data/repositories/template_repository_impl.dart';
import '../../../features/template/domain/repositories/template_repository.dart';
import '../../../features/template/domain/usecases/get_current_template_version.dart';
import '../../../features/template/domain/usecases/open_github_url.dart';
import '../../../features/template/presentation/bloc/template_bloc.dart';
import '../api/api.dart';
import '../url_launcher_gateway/url_launcher_gateway.dart';

part 'injection_container_main.dart';
