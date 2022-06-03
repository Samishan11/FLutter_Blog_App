import 'package:blog_app/screen/addBlog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('addblog page test', (tester) async {
    // await tester.runAsync(() async {
      final title = find.byKey(ValueKey("title"));
      final catagory = find.byKey(ValueKey("catagory"));
      final description = find.byKey(ValueKey("description"));
      final button = find.byKey(ValueKey('Post'));

      //
      await tester.pumpWidget(ProviderScope(child: MaterialApp(home: Addblog())));
      await tester.enterText(title, "Mount Everest");
      await tester.enterText(catagory, "Nature");
      await tester.enterText(description, "Hello from top of the world");
      await tester.tap(button);
      await tester.pump();

      //
      expect(find.text('Mount Everest'), findsOneWidget);
      expect(find.text('Nature'), findsOneWidget);
      expect(find.text('Hello from top of the world'), findsOneWidget);
    });
  // });
}
