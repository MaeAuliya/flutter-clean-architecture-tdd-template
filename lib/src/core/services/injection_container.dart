import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/tapper/data/datasources/tapper_local_data_source.dart';
import '../../features/tapper/data/datasources/tapper_remote_data_source.dart';
import '../../features/tapper/data/repositories/tapper_repository_impl.dart';
import '../../features/tapper/domain/repositories/tapper_repository.dart';
import '../../features/tapper/domain/usecases/get_all_tap_per_day.dart';
import '../../features/tapper/domain/usecases/get_today_tap_per_day.dart';
import '../../features/tapper/domain/usecases/go_to_repository.dart';
import '../../features/tapper/domain/usecases/long_press.dart';
import '../../features/tapper/domain/usecases/tap.dart';
import '../../features/tapper/presentation/bloc/tapper_bloc.dart';
import 'api.dart';
import 'local_database.dart';

part 'injection_container_main.dart';
