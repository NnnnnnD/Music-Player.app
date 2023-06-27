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
  final List<Music> musicList;
  final int currentIndex;

  MusicPlayerPage(
      {required this.music, required this.musicList, required this.currentIndex}
      );

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration currentPosition = Duration();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    audioPlayer = AudioPlayer();

    audioPlayer.onAudioPositionChanged.listen((Duration position) {
      setState(() {
        currentPosition = position;
      });
      checkEndOfSong();
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      playNextSong();
    });
    playMusic(widget.music.audioPath);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playMusic(String audioPath) async {
    if (isPlaying) {
      await audioPlayer.resume();
    }else {
      await audioPlayer.play(audioPath, isLocal: true);
      audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.PAUSED || state == PlayerState.STOPPED) {
          setState(() {
            isPlaying = false;
          });
        }else if (state == PlayerState.PLAYING) {
          setState(() {
            isPlaying = true;
          });
        }
      });
    }
  }

  Future<void> pauseMusic() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> stopMusic() async {
    int result = await audioPlayer.stop();
    if (result == 1) {
      setState(() {
        isPlaying = false;
        currentPosition = Duration();
      });
    }
  }

  void seekMusic(Duration position) {
    audioPlayer.seek(position);
  }

  void playNextSong() {
    int nextIndex = currentIndex + 1;
    if (nextIndex < widget.musicList.length) {
      setState(() {
        currentIndex = nextIndex;
        currentPosition = Duration();
      });
      stopMusic().then((_) {
        playMusic(widget.musicList[currentIndex].audioPath);
      });
    }
  }

  void playPreviousSong() {
    int previousIndex = currentIndex - 1;
    if (previousIndex >= 0) {
      setState(() {
        currentIndex = previousIndex;
        currentPosition = Duration();
      });
      stopMusic().then((_) {
        playMusic(widget.musicList[currentIndex].audioPath);
      });
    }
  }

  void checkEndOfSong() {
    if (currentPosition >= widget.musicList[currentIndex].duration) {
      playNextSong();
    }
  }

  @override
  Widget build(BuildContext context) {
    String formatDuration(Duration duration) {
      String minutes =
          duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }

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
                        image: AssetImage(
                            widget.musicList[currentIndex].imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    widget.musicList[currentIndex].title,
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
                    widget.musicList[currentIndex].artist,
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
                        formatDuration(currentPosition),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        formatDuration(
                            widget.musicList[currentIndex].duration),
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
                  max: widget.musicList[currentIndex].duration.inSeconds
                      .toDouble(),
                  onChanged: (value) {
                    setState(() {
                      currentPosition = Duration(seconds: value.toInt());
                    });
                    audioPlayer.seek(currentPosition);
                  },
                  onChangeEnd: (value) {
                    seekMusic(currentPosition);
                  },
                  activeColor: Colors.green,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.skip_previous,
                          size: 36,
                          color: Colors.white,
                        ),
                        onPressed: playPreviousSong,
                      ),
                      SizedBox(width: 20),
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
                              playMusic(
                                  widget.musicList[currentIndex].audioPath);
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(
                          Icons.skip_next,
                          size: 36,
                          color: Colors.white,
                        ),
                        onPressed: playNextSong,
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
      'assets/audio/I Want to Break Free.mp3',
      Duration(minutes: 4, seconds: 23),
    ),
    Music(
      'Somebody To Love',
      'Queen',
      'assets/images/Cover3.jpeg',
      'assets/audio/Somebody To Love.mp3',
      Duration(minutes: 5, seconds: 9),
    ),
    Music(
      'Love Of My Life',
      'Queen',
      'assets/images/Cover4.jpeg',
      'assets/audio/Love of My Life.mp3',
      Duration(minutes: 3, seconds: 41),
    ),
    Music(
      'Killer Queen',
      'Queen',
      'assets/images/Cover5.jpeg',
      'assets/audio/Killer Queen.mp3',
      Duration(minutes: 3, seconds: 12),
    ),
    Music(
      'Good Old-Fashioned Lover Boy',
      'Queen',
      'assets/images/Cover6.jpeg',
      'assets/audio/Good Old Fashioned Lover Boy.mp3',
      Duration(minutes: 3, seconds: 6),
    ),
    Music(
      'Radio Ga-Ga',
      'Queen',
      'assets/images/Cover7.jpeg',
      'assets/audio/Radio Ga Ga.mp3',
      Duration(minutes: 5, seconds: 53),
    ),
    Music(
      'Under Pressure',
      'Queen',
      'assets/images/Cover8.jpeg',
      'assets/audio/Under Pressure.mp3',
      Duration(minutes: 4, seconds: 13),
    ),
    Music(
      'We Will Rock You',
      'Queen',
      'assets/images/Cover9.jpeg',
      'assets/audio/We Will Rock You.mp3',
      Duration(minutes: 2, seconds: 14),
    ),
    Music(
      "Don't Stop Me Now",
      'Queen',
      'assets/images/Cover10.jpeg',
      'assets/audio/Don\'t Stop Me Now.mp3',
      Duration(minutes: 3, seconds: 30),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('OH Music Player'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background1.jpeg'),
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
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MusicPlayerPage(
                        music: musicList[index],
                        musicList: musicList,
                        currentIndex: index,
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
    title: 'OH Music Player',
    theme: ThemeData.dark(),
    home: MusicListPage(),
  ));
}