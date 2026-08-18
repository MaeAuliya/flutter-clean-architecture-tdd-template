import 'package:flutter/material.dart';
import 'package:flutter_clean_tdd_template/src/core/shared/views/error_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget app(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('plain variant has no refresh control', (tester) async {
    await tester.pumpWidget(app(const ErrorView()));

    expect(find.byType(RefreshIndicator), findsNothing);
    expect(find.text('Refresh'), findsNothing);
  });

  testWidgets('button variant invokes refresh callback', (tester) async {
    var refreshCount = 0;
    await tester.pumpWidget(
      app(
        ErrorView(
          variant: ErrorViewVariant.button,
          onRefresh: () async => refreshCount++,
        ),
      ),
    );

    await tester.tap(find.text('Refresh'));
    await tester.pump();

    expect(refreshCount, 1);
  });

  testWidgets('pull-to-refresh variant owns RefreshIndicator', (tester) async {
    await tester.pumpWidget(
      app(
        ErrorView(
          variant: ErrorViewVariant.pullToRefresh,
          onRefresh: () async {},
        ),
      ),
    );

    expect(find.byType(RefreshIndicator), findsOneWidget);
    final list = tester.widget<ListView>(find.byType(ListView));
    expect(list.physics, isA<AlwaysScrollableScrollPhysics>());
  });

  testWidgets('outside-refresh variant leaves refresh ownership outside', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(const ErrorView(variant: ErrorViewVariant.outsideRefresh)),
    );

    expect(find.byType(RefreshIndicator), findsNothing);
    expect(find.byType(ListView), findsOneWidget);
  });
}
