import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:music_player_app/music_app.dart';

void main() {
  testWidgets('Music Player App Test', (WidgetTester tester) async {
    await tester.pumpWidget(MusicPlayerApp());

    expect(find.text('Music Player'), findsOneWidget);
    expect(find.text('Song 1'), findsOneWidget);
    expect(find.text('Song 2'), findsOneWidget);
    expect(find.text('Song 3'), findsOneWidget);
    expect(find.text('Song 4'), findsOneWidget);
    expect(find.text('Song 5'), findsOneWidget);

    await tester.tap(find.text('Song 3'));
    await tester.pumpAndSettle();

    expect(find.text('Now Playing:'), findsOneWidget);
    expect(find.text('Song 3'), findsOneWidget);
    expect(find.text('Back to List'), findsOneWidget);

    await tester.tap(find.text('Back to List'));
    await tester.pumpAndSettle();

    expect(find.text('Music Player'), findsOneWidget);
    expect(find.text('Song 1'), findsOneWidget);
    expect(find.text('Song 2'), findsOneWidget);
    expect(find.text('Song 3'), findsOneWidget);
    expect(find.text('Song 4'), findsOneWidget);
    expect(find.text('Song 5'), findsOneWidget);
  });
}
