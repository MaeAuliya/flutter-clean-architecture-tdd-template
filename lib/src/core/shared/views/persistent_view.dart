// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../features/navigation/presentation/providers/bottom_tab_navigator.dart';
//
// class PersistentView extends StatefulWidget {
//   const PersistentView({super.key, this.body});
//
//   final Widget? body;
//
//   @override
//   State<PersistentView> createState() => _PersistentViewState();
// }
//
// class _PersistentViewState extends State<PersistentView>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return widget.body ?? context.watch<BottomTabNavigator>().currentPage.child;
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }
