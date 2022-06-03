import 'package:blog_app/screen/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('login page', (tester) async {
    // await tester.runAsync(() async {
      final email = find.byKey(ValueKey("email"));
      final password = find.byKey(ValueKey("password"));
      final button = find.byKey(ValueKey('login'));

      //
      await tester.pumpWidget(ProviderScope(child: MaterialApp(home: Login())));
      await tester.enterText(email, "samishanthapa0@gmail.com");
      await tester.enterText(password, "hello11");
      await tester.tap(button);
      await tester.pump();

      //
      expect(find.text('samishanthapa0@gmail.com'), findsOneWidget);
      expect(find.text('hello11'), findsOneWidget);
    });
  // });
}
