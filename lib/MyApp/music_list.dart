   import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'music_player.dart';

class MusicListPage extends StatelessWidget {
  final List<Music> musicList = [
    Music('Bohemian Rhapsody', 'Queen', 'assets/images/Cover1.jpeg', 'assets/audio/Song1.mp3'),
    /*Music('I Want To Break Free', 'Queen', 'assets/images/Cover2.jpeg'),
    Music('Somebody To Love', 'Queen', 'assets/images/Cover3.jpeg'),
    Music('Love Of My Life', 'Queen', 'assets/images/Cover4.jpeg'),
    Music('Killer Queen', 'Queen', 'assets/images/Cover5.jpeg'),
    Music('Good Old-Fashioned Lover Boy', 'Queen', 'assets/images/Cover6.jpeg'),
    Music('Radio Ga-Ga', 'Queen', 'assets/images/Cover7.jpeg'),
    Music('Under Pressure', 'Queen', 'assets/images/Cover8.jpeg'),
    Music('We Will Rock You', 'Queen', 'assets/images/Cover9.jpeg'),
    Music("Don't Stop Me Now", 'Queen', 'assets/images/Cover10.jpeg'),
    */
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Music Player'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: musicList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.5),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: AssetImage(musicList[index].imagePath),
                  radius: 25,
                ),
                title: Text(
                  musicList[index].title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  musicList[index].artist,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(
                  Icons.play_circle_filled,
                  size: 30,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MusicPlayerPage(
                        music: musicList[index],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}