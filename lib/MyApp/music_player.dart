import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Music {
  final String title;
  final String artist;
  final String imagePath;
  final String audioPath;
  final Duration duration;

  Music(this.title, this.artist, this.imagePath, this.audioPath, this.duration);
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
  Duration currentPosition = Duration();

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    audioPlayer.onAudioPositionChanged.listen((Duration position) {
      setState(() {
        currentPosition = position;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playMusic(String audioPath) async {
    await audioPlayer.stop();
    await audioPlayer.play(audioPath, isLocal: true);
    await audioPlayer.seek(Duration(seconds: 0));
    setState(() {
      isPlaying = true;
      currentPosition = Duration(seconds: 0);
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
                        currentPosition.toString().split('.').first,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.music.duration.toString().split('.').first,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Slider(
                  value: currentPosition.inSeconds.toDouble(),
                  min: 0.0,
                  max: widget.music.duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      currentPosition = Duration(seconds: value.toInt());
                    });
                    audioPlayer.seek(currentPosition);
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
    Music(
      'Bohemian Rhapsody',
      'Queen',
      'assets/images/Cover1.jpeg',
      'assets/audio/Bohemian Rhapsody.mp3',
      Duration(minutes: 5, seconds: 59),
    ),
    Music(
      'I Want To Break Free',
      'Queen',
      'assets/images/Cover2.jpeg',
      'assets/audio/Don\'t Stop Me Now.mp3',
      Duration(minutes: 4, seconds: 23),
    ),
    // Add the rest of the music entries
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
