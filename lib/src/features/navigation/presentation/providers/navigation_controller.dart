import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/injection_container.dart';
import '../../../tapper/presentation/bloc/tapper_bloc.dart';
import '../../../tapper/presentation/screens/tap_screen.dart';
import '../../../tapper/presentation/screens/tap_statistic_screen.dart';

class NavigationController extends ChangeNotifier {
  List<int> _indexHistory = [0];

  List<int> get indexHistory => _indexHistory;

  List<Widget> _screens = [];

  List<Widget> get screens => _screens;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void getScreens() {
    _indexHistory = [0];
    _screens = [
      BlocProvider(
        create: (_) => sl<TapperBloc>(),
        child: const TapScreen(),
      ),
      BlocProvider(
        create: (_) => sl<TapperBloc>(),
        child: const TapStatisticScreen(),
      ),
    ];
  }

  void changeIndex(int index) {
    if (index == _currentIndex) return;
    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void backToHome() {
    _currentIndex = 0;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}
