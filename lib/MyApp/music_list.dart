import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'music_player.dart';

class MusicListPage extends StatelessWidget {
  final List<Music> musicList = [
    Music('Bohemian Rhapsody', 'Queen', 'assets/images/Cover1.jpeg', 'assets/audio/Queen1.mp3'),
    Music('I Want To Break Free', 'Queen', 'assets/images/Cover2.jpeg','assets/audio/Don\'t Stop Me Now.mp3'),
    Music('Somebody To Love', 'Queen', 'assets/images/Cover3.jpeg','assets/audio/Good Old Fashioned Lover Boy'),
    Music('Love Of My Life', 'Queen', 'assets/images/Cover4.jpeg','assets/audio/I Want to Break Free'),
    Music('Killer Queen', 'Queen', 'assets/images/Cover5.jpeg','assets/audio/Killer Queen'),
    Music('Good Old-Fashioned Lover Boy', 'Queen', 'assets/images/Cover6.jpeg','assets/audio/Love of My Life'),
    Music('Radio Ga-Ga', 'Queen', 'assets/images/Cover7.jpeg','assets/audio/Radio Ga Ga'),
    Music('Under Pressure', 'Queen', 'assets/images/Cover8.jpeg','assets/audio/Somebody To Love'),
    Music('We Will Rock You', 'Queen', 'assets/images/Cover9.jpeg','assets/audio/Under Pressure'),
    Music("Don't Stop Me Now", 'Queen', 'assets/images/Cover10.jpeg','assets/audio/We Will Rock You'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('OH Music Player'),
        actions: [
  IconButton(
    icon: Icon(Icons.info),
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Music Player Made by :',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('Team 1'),
                  SizedBox(height: 8.0),
                  Text('1. Nandy'),
                  Text('2. Tiara'),
                  Text('3. Adit S'),
                  Text('4. Adit F'),
                  Text('5. Dadan'),
                  Text('6. Syeila'),
                  SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ),
],


      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/BackgroundIMG.jpeg'),
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