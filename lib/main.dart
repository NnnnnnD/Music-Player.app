import 'package:flutter/material.dart';
import 'MyApp/music_list.dart';

void main() => runApp(MusicPlayerApp());

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MusicListPage(),
    );
  }
}