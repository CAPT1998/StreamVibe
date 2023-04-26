import 'dart:convert';
import 'package:just_audio/just_audio.dart';

import 'package:just_audio/just_audio.dart';
import 'package:koinonia/Api/Networkutils.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../model/categorymusicmodel.dart';
import '/../../flutter_flow/flutter_flow_ad_banner.dart';
import '/../../flutter_flow/flutter_flow_icon_button.dart';
import '/../../flutter_flow/flutter_flow_theme.dart';
import '/../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:like_button/like_button.dart';

import '/../../model/musics.dart';

class PlayingWidget3 extends StatefulWidget {
  Categorymusicmodel music;

  PlayingWidget3({
    Key? key,
    required this.music,
  }) : super(key: key);

  get userId => "3";

  @override
  _PlayingWidgetState createState() => _PlayingWidgetState();
}

class _PlayingWidgetState extends State<PlayingWidget3> {
  late AudioPlayer _audioPlayer;
  late Duration _duration;
  late Duration _position;
  late String userid;

  late bool _isPlaying;
  late Networkutils networkutils;
  List<Categorymusicmodel> _musicList = [];
  final AudioPlayer audioPlayer = AudioPlayer();
  late List<String> _imageUrls;
  List<Musics> _playedSongs = [];
  bool _hasBeenPressed = false;
  bool _downloadhasBeenPressed = false;
  bool _repeathasBeenPressed = false;
  bool _listhasbeenPressed = false;
  late String nextsongimage;
  late int _currentIndex;
  late int _previousIndex;
  late int _nextIndex;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late DecorationImage _previousImage;
  late DecorationImage _nextImage;
  _fetchMusicData() async {
    final response = await http
        .get(Uri.parse('https://admin.koinoniaconnect.org/API/getAllMusics'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _musicList = List<Categorymusicmodel>.from(
            data.map((json) => Categorymusicmodel.fromJson(json)));
      });
    } else {
      throw Exception('Failed to fetch music data');
    }
  }

  void _initAudioPlayer() async {
    await _audioPlayer
        .setUrl("https://admin.koinoniaconnect.org/" + widget.music.musicFile);
    _audioPlayer.durationStream.listen((duration) {
      setState(() => _duration = duration!);
    });
    _audioPlayer.positionStream.listen((position) {
      setState(() => _position = position);
    });
    _audioPlayer.playerStateStream.listen((playerState) {
      setState(() {
        _isPlaying = playerState.playing ||
            playerState.processingState == ProcessingState.loading;
      });
    });
  }

  Future<void> _addPlayedSong(Musics music) async {
    final prefs = await SharedPreferences.getInstance();
    final playedSongsJson = prefs.getStringList('played_songs_${userid}') ?? [];
    playedSongsJson.add(json.encode(music));
    prefs.setStringList('played_songs_${userid}', playedSongsJson);
    setState(() {
      _playedSongs.add(music);
    });
  }
  

  sharedprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid")!;
    });
    print("current_user_id is " + userid);
  }

  @override
  void initState() {
    _fetchMusicData();
    userid = "";
    super.initState();
    networkutils = Networkutils();
    nextsongimage = "";
    _audioPlayer = AudioPlayer();
    _duration = Duration.zero;
    _position = Duration.zero;
    _isPlaying = false;
    sharedprefs();
    _initAudioPlayer();
    //_play();
    print("hello world");
    int index = _musicList.indexOf(widget.music);

    _currentIndex = index;
    _previousIndex = index - 1;
    _nextIndex = index + 1;
    _previousImage = _previousIndex >= 0 && _previousIndex < _musicList.length
        ? DecorationImage(
            image: NetworkImage(_musicList[_previousIndex].musicImage),
            fit: BoxFit.cover)
        : DecorationImage(
            image: AssetImage(
                "assets/images/bd1d3b89077c4b2fff916366bf447503.png"),
            fit: BoxFit.cover);
    _nextImage = _nextIndex >= 0 && _nextIndex < _musicList.length
        ? DecorationImage(
            image: NetworkImage(_musicList[_nextIndex].musicImage),
            fit: BoxFit.cover)
        : DecorationImage(
            image: AssetImage(
                "assets/images/47002bcae4d44bc54785fc1e03e5428d.png"),
            fit: BoxFit.cover);
    print(_previousIndex);

    print(_currentIndex);
    print(_nextIndex);
  }

  void _play() {
    _audioPlayer.play();
  }

  void _pause() {
    _audioPlayer.pause();
  }

  void _seek(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  getnextsongimage() async {
    int nextIndex = (_musicList.indexOf(widget.music) + 1) % _musicList.length;
    Categorymusicmodel nextimage = _musicList[nextIndex];
    setState(() {
      widget.music = nextimage;
      nextsongimage = nextimage.musicImage;
    });
    print(" Hellow world" + nextimage.musicImage);
  }

  _next() async {
    // Stop current track
    await _audioPlayer.stop();

    // Get the next track index
    int nextIndex = (_musicList.indexOf(widget.music) + 1) % _musicList.length;
    // Load the next track
    Categorymusicmodel nextMusic = _musicList[nextIndex];
    await _audioPlayer.setAudioSource(
      AudioSource.uri(Uri.parse(
          "https://admin.koinoniaconnect.org/" + nextMusic.musicFile)),
      initialPosition: Duration.zero,
      preload: true,
    );
    setState(() {
      widget.music = nextMusic;
      _isPlaying = true;
      _position = Duration.zero;
      _duration = _audioPlayer.duration ?? Duration.zero;
    });

    // Play the next track
    _audioPlayer.play();
  }

  void _previous() async {
    // Stop current track
    await _audioPlayer.stop();

    // Get the previous track index
    int previousIndex =
        (_musicList.indexOf(widget.music) - 1) % _musicList.length;

    // Load the previous track
    Categorymusicmodel previousMusic = _musicList[previousIndex];
    await _audioPlayer.setAudioSource(
      AudioSource.uri(Uri.parse(
          "https://admin.koinoniaconnect.org/" + previousMusic.musicFile)),
      initialPosition: Duration.zero,
      preload: true,
    );
    setState(() {
      widget.music = previousMusic;
      _isPlaying = true;
      _position = Duration.zero;
      _duration = _audioPlayer.duration ?? Duration.zero;
    });

    // Play the previous track
    _audioPlayer.play();
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    await networkutils.addtoliked(userid, widget.music.musicId);

    /// if failed, you can do nothin
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  late String _localPath;
  // ProgressDialog pr;
  double percentage = 0.0;
  bool downloading = false;
  var progress = "";
  Widget dialog() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        backgroundColor: Color(0xFFF15C00),
      ),
    );
  }

  String _durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inMinutes}:$twoDigitSeconds";
  }

  String _positionToString(Duration position) {
    return _durationToString(position);
  }

  Future<void> _download() async {
    _localPath = (await _findLocalPath()) + '/Download';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    dialog();

    Dio dio = Dio();

    var dirToSave = await getApplicationDocumentsDirectory();

    await dio.download(
        "https://admin.koinoniaconnect.org/" + widget.music.musicFile,
        "$_localPath/" + widget.music.musicTitle + ".mp3",
        onReceiveProgress: (rec, total) {
      setState(() {
        downloading = true;

        // pr.show();
        dialog();

        Future.delayed(Duration(seconds: 2)).then((onvalue) {
          percentage = (percentage + 1.0);
          print("=======================>>>" + percentage.toString());
          print("${dirToSave.path}/" + widget.music.musicTitle + ".mp3");
        });
      });
    });

    setState(() {
      downloading = false;
      print("${dirToSave.path}/" + widget.music.musicTitle + ".mp3");
      progress = "Complete";
      Fluttertoast.showToast(
        msg: "Download Complated!" +
            "${dirToSave.path}/" +
            "widget.musictitle" +
            ".mp3",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
      );
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => {Navigator.pop(context)},
        ),
        title: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(-0.3, 0),
              child: Text(
                'Played From',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).title2.override(
                      fontFamily: 'Poppins',
                      color: Color(0xFF150734),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-0.3, 0),
              child: Text(
                "",
                style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      //resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: FlutterFlowAdBanner(
                            width: MediaQuery.of(context).size.width,
                            height: 179,
                             
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 568.3,
                    height: 556.9,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: Image.asset(
                          'assets/images/Group_8_Copy_(1).png',
                        ).image,
                      ),
                    ),
                    child: Stack(
                      children: [
                        ListView(
                          children: [
                            GestureDetector(
                              onHorizontalDragEnd: (DragEndDetails drag) {
                                print("someting");
                                if (drag.primaryVelocity == null) return;

                                if (drag.primaryVelocity! < 0) {
                                  // drag from right to left
                                  print("forward");
                                } else {
                                  print("backward");
                                }
                              },
                              child: CarouselSlider(
                                items: [
                                  //1st Image of Slider

                                  Container(
                                    width: 151,
                                    height: 151,
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.0),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "https://admin.koinoniaconnect.org/" +
                                                widget.music.musicImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  //2nd Image of Slider
                                  Container(
                                    width: 151,
                                    height: 151,
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        image: _nextImage),
                                  ),

                                  //3rd Image of Slider
                                  Container(
                                    width: 151,
                                    height: 151,
                                    margin: EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/47002bcae4d44bc54785fc1e03e5428d.png"),
                                            fit: BoxFit.cover)),
                                  ),

                                  //4th Image of Slider

                                  //5th Image of Slider
                                ],

                                //Slider Container properties
                                options: CarouselOptions(
                                  height: 180.0,
                                  // onScrolled: () => {_next()},
                                  enlargeCenterPage: true,
                                  autoPlay: false,
                                  //padEnds: false,
                                  //reverse: true,
                                  scrollPhysics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  aspectRatio: 16 / 9,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enableInfiniteScroll: true,
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  viewportFraction: 0.5,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Text(
                                      widget.music.musicTitle,
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Source Serif Pro',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 30,
                                  borderWidth: 1,
                                  buttonSize: 30,
                                  icon: Icon(
                                    Icons.download_sharp,
                                    color: _downloadhasBeenPressed
                                        ? Color(0xFFF15C00)
                                        : Colors.black,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _download();
                                    setState(() {
                                      _downloadhasBeenPressed =
                                          !_downloadhasBeenPressed;
                                    });
                                    var snackBar = SnackBar(
                                      content: Text(
                                        'Download Started',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFFF15C00),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      shape: StadiumBorder(),
                                      width: 200,
                                      duration: Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                ),
                                FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 30,
                                  borderWidth: 1,
                                  buttonSize: 30,
                                  icon: Icon(
                                    Icons.repeat,
                                    color: _repeathasBeenPressed
                                        ? Color(0xFFF15C00)
                                        : Colors.black,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _repeathasBeenPressed =
                                          !_repeathasBeenPressed;
                                    });
                                    var snackBar = SnackBar(
                                      content: Text(
                                        'Repeat song',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFFF15C00),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      shape: StadiumBorder(),
                                      width: 200,
                                      duration: Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                ),
                                FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 30,
                                  borderWidth: 1,
                                  buttonSize: 30,
                                  icon: Icon(
                                    Icons.list,
                                    color: _listhasbeenPressed
                                        ? Color(0xFFF15C00)
                                        : Colors.black,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _listhasbeenPressed =
                                          !_listhasbeenPressed;
                                    });
                                  },
                                ),
                                FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 30,
                                  borderWidth: 1,
                                  buttonSize: 30,
                                  icon: Icon(
                                    Icons.shuffle,
                                    color: _hasBeenPressed
                                        ? Color(0xFFF15C00)
                                        : Colors.black,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _hasBeenPressed = !_hasBeenPressed;
                                    });
                                    var snackBar = SnackBar(
                                      content: Text(
                                        'Shuffle songs',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFFF15C00),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      shape: StadiumBorder(),
                                      width: 200,
                                      duration: Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                ),
                                LikeButton(
                                  size: 20,
                                  isLiked: false,
                                  postFrameCallback: (LikeButtonState state) {
                                    state.controller?.forward();
                                  },
                                  onTap: onLikeButtonTapped,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("${_positionToString(_position)}"),
                                  Expanded(
                                    child: Slider(
                                      activeColor: Color(0xFFF15C00),
                                      thumbColor: Color(0xFFF15C00),
                                      value: _position.inSeconds.toDouble(),
                                      min: 0.0,
                                      max: _duration.inSeconds.toDouble(),
                                      onChanged: (value) => _seek(
                                          Duration(seconds: value.toInt())),
                                    ),
                                  ),
                                  Text("${_durationToString(_duration)}"),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: new Image.asset(
                                        'assets/images/previoussong.png',
                                        width: 60),
                                    onPressed: _previous,
                                  ),
                                  IconButton(
                                    iconSize: 60,
                                    icon: _isPlaying
                                        ? new Image.asset(
                                            'assets/images/stop.png',
                                          )
                                        : new Image.asset(
                                            'assets/images/play.png',
                                          ),
                                    onPressed: _isPlaying ? _pause : _play,
                                  ),
                                  IconButton(
                                    icon: new Image.asset(
                                        'assets/images/nextsong.png',
                                        width: 60),
                                    onPressed: _next,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
