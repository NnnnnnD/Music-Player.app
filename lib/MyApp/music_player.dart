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
  Duration _duration = Duration();
  Duration _position = Duration();
  double _sliderValue = 0.0;
  bool _isSliderDragging = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((position) {
      if (!_isSliderDragging) {
        setState(() {
          _position = position;
          if (_duration.inMilliseconds > 0) {
            _sliderValue = _position.inMilliseconds.toDouble() /
                _duration.inMilliseconds.toDouble();
          }
        });
      }
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
    setState(() {
      isPlaying = true;
      _sliderValue = _clampSliderValue(_sliderValue);
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
      _position = Duration();
      _sliderValue = 0.0;
    });
  }

  void seekToPosition(double value) {
    final double position = _clampSliderValue(value);
    audioPlayer.seek(Duration(milliseconds: position.toInt()));
  }

  double _clampSliderValue(double value) {
    final double min = 0.0;
    final double max = _duration.inMilliseconds.toDouble();
    return value.clamp(min, max);
  }

  String formatDuration(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
                        formatDuration(_position),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        formatDuration(_duration),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Slider(
                    min: 0,
                    max: _duration.inMilliseconds.toDouble(),
                    value: _sliderValue,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                        _isSliderDragging = true;
                      });
                    },
                    onChangeEnd: (value) {
                      setState(() {
                        _isSliderDragging = false;
                        seekToPosition(value);
                      });
                    },
                  ),
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
    Music('Bohemian Rhapsody', 'Queen', 'assets/images/Cover1.jpeg',
        'assets/audio/Queen1.mp3'),
    Music('I Want To Break Free', 'Queen', 'assets/images/Cover2.jpeg',
        'assets/audio/I Want to Break Free.mp3'),
    Music('Somebody To Love', 'Queen', 'assets/images/Cover3.jpeg',
        'assets/audio/Somebody To Love.mp3'),
    Music('Love Of My Life', 'Queen', 'assets/images/Cover4.jpeg',
        'assets/audio/Love of My Life.mp3'),
    Music('Killer Queen', 'Queen', 'assets/images/Cover5.jpeg',
        'assets/audio/Killer Queen.mp3'),
    Music('Good Old-Fashioned Lover Boy', 'Queen',
        'assets/images/Cover6.jpeg', 'assets/audio/Good Old Fashioned Lover Boy.mp3'),
    Music('Radio Ga-Ga', 'Queen', 'assets/images/Cover7.jpeg',
        'assets/audio/Radio Ga Ga.mp3'),
    Music('Under Pressure', 'Queen', 'assets/images/Cover8.jpeg',
        'assets/audio/Under Pressure.mp3'),
    Music('We Will Rock You', 'Queen', 'assets/images/Cover9.jpeg',
        'assets/audio/We Will Rock You.mp3'),
    Music("Don't Stop Me Now", 'Queen', 'assets/images/Cover10.jpeg',
        "assets/audio/Don't Stop Me Now.mp3"),
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
