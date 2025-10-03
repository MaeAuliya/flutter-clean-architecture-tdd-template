import 'package:flutter/cupertino.dart';

import '../../domain/entities/tap_per_day.dart';

class TapperProvider extends ChangeNotifier {
  void init() {
    _todayTap = null;
  }

  TapPerDay? _todayTap;

  TapPerDay? get todayTap => _todayTap;

  void updateTodayTap(TapPerDay? todayTap) {
    _todayTap = todayTap;
    notifyListeners();
  }

  int? _successTap;
  int? get successTap => _successTap;

  void updateSuccessTap(int tap) {
    _successTap = tap;
    notifyListeners();
  }
}
