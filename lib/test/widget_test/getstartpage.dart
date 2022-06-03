import 'package:blog_app/screen/getstart.dart';
import 'package:blog_app/screen/profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('getstart page test', (tester) async {
    await tester
        .pumpWidget(ProviderScope(child: MaterialApp(home: GetstartPage())));
    final title = find.byType(SafeArea);
    expect(title, findsOneWidget);
  });
}
