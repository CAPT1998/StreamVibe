import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import '../model/musics.dart';

class Music {
  final String musicImage;
  final String musicTitle;
  final String musicFile;

  Music(
      {required this.musicImage,
      required this.musicTitle,
      required this.musicFile});

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      musicImage: json['musicImage'],
      musicTitle: json['musicTitle'],
      musicFile: json['musicFile'],
    );
  }
}

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({Key? key}) : super(key: key);

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late AudioPlayer audioPlayer;
  List<Musics> musicList = [];
  int currentIndex = 0;
  Duration position = Duration();
  Duration musicLength = Duration();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    fetchMusicList();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  void fetchMusicList() async {
    final response = await http
        .get(Uri.parse('https://admin.koinoniaconnect.org/API/getAllMusics'));
    final data = jsonDecode(response.body);
    setState(() {
      musicList =
          List<Musics>.from(data.map((music) => Musics.fromJson(music)));
    });
    playMusic(musicList[currentIndex].musicFile);
  }

  void playMusic(String url) async {
    await audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse("https://admin.koinoniaconnect.org/" + url)));
    await audioPlayer.play();
    setState(() {
      isPlaying = true;
    });
  }

  void pauseMusic() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void seekMusic(Duration duration) {
    audioPlayer.seek(duration);
  }

  void nextMusic() {
    if (currentIndex == musicList.length - 1) {
      currentIndex = 0;
    } else {
      currentIndex++;
    }
    playMusic(musicList[currentIndex].musicFile);
  }

  void previousMusic() {
    if (currentIndex == 0) {
      currentIndex = musicList.length - 1;
    } else {
      currentIndex--;
    }
    playMusic(musicList[currentIndex].musicFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            "https://admin.koinoniaconnect.org/" +
                musicList[currentIndex].musicImage,
            width: 200,
            height: 200,
          ),
          SizedBox(height: 20),
          Text(
            musicList[currentIndex].musicTitle,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                onPressed: () {
                  isPlaying
                      ? pauseMusic()
                      : playMusic(musicList[currentIndex].musicFile);
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () {
                  previousMusic();
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () {
                  nextMusic();
                },
              ),
              SizedBox(height: 20),
              Slider(
                value: position.inSeconds.toDouble(),
                min: 0,
                max: musicLength.inSeconds.toDouble(),
                onChanged: (value) {
                  seekMusic(Duration(seconds: value.toInt()));
                },
                inactiveColor: Colors.grey,
                activeColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
