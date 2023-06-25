import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Music {
  final String title;
  final String artist;
  final String imagePath;
  final String audioPath;

  Music(this.title, this.artist, this.imagePath, this.audioPath);
}

class MusicPlayerPage extends StatefulWidget {
  final Music music;

  MusicPlayerPage({required this.music});

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playMusic(String audioPath) async {
    await audioPlayer.stop();
    await audioPlayer.play(audioPath, isLocal: true);
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> pauseMusic() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> stopMusic() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            stopMusic();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(widget.music.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    widget.music.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    widget.music.artist,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0:00',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '3:45',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Slider(
                  value: 0.5,
                  onChanged: (value) {
                    // Handle slider changes
                  },
                  activeColor: Colors.green,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.shuffle,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.skip_previous,
                        size: 36,
                        color: Colors.white,
                      ),
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.black,
                        child: IconButton(
                          iconSize: 48,
                          color: Colors.white,
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                          onPressed: () {
                            if (isPlaying) {
                              pauseMusic();
                            } else {
                              playMusic(widget.music.audioPath);
                            }
                          },
                        ),
                      ),
                      Icon(
                        Icons.skip_next,
                        size: 36,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.repeat,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MusicListPage extends StatelessWidget {
  final List<Music> musicList = [
    Music('Bohemian Rhapsody', 'Queen', 'assets/images/Cover1.jpeg', 'assets/audio/Bohemian Rhapsody.mp3'),
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

void main() {
  runApp(MaterialApp(
    home: MusicListPage(),
  ));
}