import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/res/colours.dart';
import '../providers/navigation_controller.dart';
import '../widgets/navigation_item.dart';

class BottomNavigationCore extends StatefulWidget {
  const BottomNavigationCore({super.key});

  static const routeName = '/bottom-navigation';

  @override
  State<BottomNavigationCore> createState() => _BottomNavigationCoreState();
}

class _BottomNavigationCoreState extends State<BottomNavigationCore> {
  @override
  void initState() {
    context.bottomNavigator.getScreens();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (_, controller, __) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          if (controller.currentIndex == 5) {
            controller.changeIndex(2);
          } else if (controller.currentIndex > 0) {
            controller.backToHome();
          } else {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                ),
              ],
            ),
            child: BottomAppBar(
              elevation: 10,
              color: Colours.white,
              height: context.widthScale * 64,
              padding: const EdgeInsets.all(8),
              shadowColor: Colours.black.withValues(alpha: 0.2),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NavItem(
                      currentIndex: controller.currentIndex,
                      index: 0,
                      icon: Icons.home,
                      label: 'Home',
                      onSelected: (index) {
                        controller.changeIndex(index);
                      },
                    ),
                    NavItem(
                      currentIndex: controller.currentIndex,
                      index: 1,
                      icon: Icons.stacked_bar_chart_rounded,
                      label: 'Stats',
                      onSelected: (index) {
                        controller.changeIndex(index);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: IndexedStack(
              index: controller.currentIndex,
              children: controller.screens,
            ),
          ),
        ),
      ),
    );
  }
}
