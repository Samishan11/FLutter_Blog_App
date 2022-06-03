import 'package:blog_app/screen/register.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('regiter page test', (tester) async {
    // await tester.runAsync(() async {
      final username = find.byKey(ValueKey("username"));
      final email = find.byKey(ValueKey("email"));
      final password = find.byKey(ValueKey("password"));
      final button = find.byKey(ValueKey('register'));

      //
      await tester.pumpWidget(ProviderScope(child: MaterialApp(home: RegisterPage())));
      await tester.enterText(username, "samishanthapa");
      await tester.enterText(email, "samishanthapa0@gmail.com");
      await tester.enterText(password, "hello11");
      await tester.tap(button);
      await tester.pump();

      //
      expect(find.text('samishanthapa'), findsOneWidget);
      expect(find.text('samishanthapa0@gmail.com'), findsOneWidget);
      expect(find.text('hello11'), findsOneWidget);
    });
  // });
}
