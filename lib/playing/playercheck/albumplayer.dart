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
import '../../model/albummusicmode.dart';
import '../../model/playlistsongsmodel.dart';
import '../../payment/choosePlanScreen.dart';
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
import '../playing_model.dart';
export '../playing_model.dart';

class albumplayer extends StatefulWidget {
  Albummusicmodel music;
  List<Albummusicmodel> allSongs;
  String aid;
  String userid;
  albumplayer(
      {Key? key,
      required this.music,
      required this.allSongs,
      required this.userid,
      required this.aid})
      : super(key: key);

  @override
  _PlayingWidgetState createState() => _PlayingWidgetState();
}

class _PlayingWidgetState extends State<albumplayer> {
  late AudioPlayer _audioPlayer;
  late Duration _duration;
  late Duration _position;
  late String userid;
  int _currentIndex_shuffle = 0;
  bool _isshufflpressed = false;
  bool _isrepeatpressed = false;
  late bool _isPlaying;
  late Networkutils networkutils;
  List<Albummusicmodel> _musicList = [];
  final AudioPlayer audioPlayer = AudioPlayer();
  late List<String> _imageUrls;
  List<Albummusicmodel> _playedSongs = [];
  bool _hasBeenPressed = false;
  bool isLikedfromserver = false;
  bool _downloadhasBeenPressed = false;
  bool _repeathasBeenPressed = false;
  bool _listhasbeenPressed = false;
  bool isliked = false;
  late int myCurrentImageIndex;
  late String nextsongimage;
  late int _currentIndex;
  late int _previousIndex;
  late int _nextIndex;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late DecorationImage _previousImage;
  late DecorationImage _nextImage;
  final CarouselController _controller = CarouselController();

  _fetchMusicData() async {
    final response = await http.post(
        Uri.parse('https://admin.koinoniaconnect.org/API/getAlbumMusic'),
        body: {'user_id': widget.userid, 'album_id': widget.aid});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _musicList = List<Albummusicmodel>.from(
            data.map((json) => Albummusicmodel.fromJson(json)));
        print("musiclit length: ${_musicList.length}");
        myCurrentImageIndex = _musicList.indexOf(widget.music);
        print("myCurrentImageIndex: ${myCurrentImageIndex}");
        _controller.animateToPage(myCurrentImageIndex);
      });
    } else {
      throw Exception('Failed to fetch music data');
    }
  }

  void _initAudioPlayer() async {
    await _audioPlayer
        .setUrl("https://admin.koinoniaconnect.org/" + widget.music.musicFile);
    _audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration!);
      }
    });
    _audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() => _position = position);
      }
    });
    _audioPlayer.playerStateStream.listen((playerState) {
      if (mounted) {
        setState(() {
          _isPlaying = playerState.playing ||
              playerState.processingState == ProcessingState.loading;
          if (playerState.processingState == ProcessingState.completed) {
            if (_repeathasBeenPressed) {
              _audioPlayer.seek(Duration.zero);
              _audioPlayer.play();
            } else {
              _next();
            }
          }
        });
      }
    });
  }

  void checkdownloadallowed() async {
    await networkutils.downloads(widget.userid);
    setState(() {});
    if (Networkutils.download == 1) {
      print("premium user");
    } else {
      print("free user");
    }
  }

  void checklike() async {
    // make a POST request to the server
    var url =
        Uri.parse('https://admin.koinoniaconnect.org/API/checklikedmusic');
    var response = await http.post(url, body: {
      'user_id': widget.userid,
      'music_id': widget.music.musicId,
    });

    // decode the JSON response
    var data = jsonDecode(response.body);

    // update the isLiked variable based on the server response
    setState(() {
      isLikedfromserver = data['isLiked'];
    });
  }

  Future<void> _addPlayedSong(Albummusicmodel music) async {
    final prefs = await SharedPreferences.getInstance();
    final playedSongsJson = prefs.getStringList('played_songs_${userid}') ?? [];

    if (playedSongsJson.length != 0) {
      // Check if the music is already in the list of recently played tracks
      bool isAlreadyPlayed = playedSongsJson.any((songJson) {
        final song = Albummusicmodel.fromJson(json.decode(songJson));
        return song.musicId == music.musicId;
      });

      // If the music is not already in the list, add it
      if (!isAlreadyPlayed) {
        playedSongsJson.add(json.encode(music));
        prefs.setStringList('played_songs_${userid}', playedSongsJson);
        setState(() {
          _playedSongs.add(music);
        });
      }
    } else {
      playedSongsJson.add(json.encode(music));
      prefs.setStringList('played_songs_${userid}', playedSongsJson);
      setState(() {
        _playedSongs.add(music);
      });
    }
  }

  void _toggleRepeat() {
    setState(() {
      _isrepeatpressed = !_isrepeatpressed;
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
    userid = "";
    // myCurrentImageIndex=0;
    //  _fetchMusicData();
    _musicList = widget.allSongs;
    myCurrentImageIndex = _musicList.indexOf(widget.music);

    super.initState();
    networkutils = Networkutils();
    nextsongimage = "";
    _audioPlayer = AudioPlayer();
    _duration = Duration.zero;
    _position = Duration.zero;
    _isPlaying = false;
    sharedprefs();
    _initAudioPlayer();
    _play();
    checklike();
    checkdownloadallowed();
    print(isLikedfromserver);
    print("userid " + userid);
    print("music id " + widget.music.musicId);
    int index = _musicList.indexOf(widget.music);

    _currentIndex = index;
    _previousIndex = index - 1;
    _nextIndex = index + 1;
    // _previousImage = _previousIndex >= 0 && _previousIndex < _musicList.length
    //     ? DecorationImage(
    //         image: NetworkImage(_musicList[_previousIndex].musicImage),
    //         fit: BoxFit.cover)
    //     : DecorationImage(
    //         image: AssetImage(
    //             "assets/images/bd1d3b89077c4b2fff916366bf447503.png"),
    //         fit: BoxFit.cover);
    // _nextImage = _nextIndex >= 0 && _nextIndex < _musicList.length
    //     ? DecorationImage(
    //         image: NetworkImage(_musicList[_nextIndex].musicImage),
    //         fit: BoxFit.cover)
    //     : DecorationImage(
    //         image: AssetImage(
    //             "assets/images/47002bcae4d44bc54785fc1e03e5428d.png"),
    //         fit: BoxFit.cover);
    print(_previousIndex);

    print(_currentIndex);
    print(_nextIndex);
  }

  void _play() {
    final _musicList = widget.music.copyWith(userId: userid);
    print("_music list: ${_musicList}");
    _addPlayedSong(_musicList);
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

  void _toggleShuffle() {
    setState(() {
      _isshufflpressed = !_isshufflpressed;
    });
  }

  getnextsongimage() async {
    int nextIndex = (_musicList.indexOf(widget.music) + 1) % _musicList.length;
    Albummusicmodel nextimage = _musicList[nextIndex];
    setState(() {
      widget.music = nextimage;
      nextsongimage = nextimage.musicImage;
    });
    print(" Hellow world" + nextimage.musicImage);
  }

  _next() async {
    // Stop current track
    await _audioPlayer.stop();
    if (_isshufflpressed) {
      // Shuffle the list of musics
      _musicList.shuffle();
    }

    // Get the next track index
    int nextIndex = (_musicList.indexOf(widget.music) + 1) % _musicList.length;

    if (_repeathasBeenPressed) {
      await _audioPlayer.setUrl(
          "https://admin.koinoniaconnect.org/" + widget.music.musicFile);
      setState(() {
        _position = Duration.zero;
        _isPlaying = true;
      });
    } else {
      // Load the next track
      Albummusicmodel nextMusic = _musicList[nextIndex];

      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(
            "https://admin.koinoniaconnect.org/" + nextMusic.musicFile)),
        initialPosition: Duration.zero,
        preload: true,
      );
      setState(() {
        widget.music = nextMusic;
        _controller.animateToPage(nextIndex);
        _isPlaying = true;
        _position = Duration.zero;
        _duration = _audioPlayer.duration ?? Duration.zero;
      });
    }
    var url =
        Uri.parse('https://admin.koinoniaconnect.org/API/checklikedmusic');
    var response = await http.post(url, body: {
      'user_id': widget.userid,
      'music_id': widget.music.musicId,
    });

    // Decode the JSON response
    var data = jsonDecode(response.body);

    // Update the isLiked variable based on the server response
    setState(() {
      isLikedfromserver = data['isLiked'];
    });
    // Play the next track
    _audioPlayer.play();
  }

  void _previous() async {
    // Stop current track
    await _audioPlayer.stop();
    if (_isshufflpressed) {
      // Shuffle the list of musics
      _musicList.shuffle();
    }
    // Get the previous track index
    int previousIndex =
        (_musicList.indexOf(widget.music) - 1) % _musicList.length;

    // Load the previous track
    Albummusicmodel previousMusic = _musicList[previousIndex];
    await _audioPlayer.setAudioSource(
      AudioSource.uri(Uri.parse(
          "https://admin.koinoniaconnect.org/" + previousMusic.musicFile)),
      initialPosition: Duration.zero,
      preload: true,
    );
    setState(() {
      widget.music = previousMusic;
      _controller.animateToPage(previousIndex);
      _isPlaying = true;
      _position = Duration.zero;
      _duration = _audioPlayer.duration ?? Duration.zero;
    });

    // Play the previous track
    _audioPlayer.play();
  }

  Future<void> onLikeButtonTapped(bool isLiked) async {
    if (!isLiked) {
      await networkutils.addtoliked(userid, widget.music.musicId);

      print("liked");
    } else {
      print("unliked");
      await networkutils.deletelikedmusic(userid, widget.music.musicId);
    }

    /// if failed, you can do nothin
    // return success? !isLiked:isLiked;
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

    // var dirToSave = await getApplicationDocumentsDirectory();
    Directory? downloadsDirectory = await getExternalStorageDirectory();
    if (downloadsDirectory == null) {
      // Handle error
      return;
    }
    String savePath = '${downloadsDirectory.path}/Download/audio.mp3';

    await dio.download(
        "https://admin.koinoniaconnect.org/" + widget.music.musicFile, savePath,
        onReceiveProgress: (rec, total) {
      setState(() {
        downloading = true;

        // pr.show();
        dialog();

        Future.delayed(Duration(seconds: 2)).then((onvalue) {
          percentage = (percentage + 1.0);
          print("=======================>>>" + percentage.toString());
          // print("${dirToSave.path}/" + widget.music.musicTitle + ".mp3");
        });
      });
    });

    setState(() {
      downloading = false;
      print("${downloadsDirectory?.path}/" + widget.music.musicTitle + ".mp3");
      print('File saved to downloads directory: $savePath');

      progress = "Complete";
      Fluttertoast.showToast(
        msg: "Download Complated!" +
            "${downloadsDirectory?.path}/" +
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
    print("khurram");
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        // leading: FlutterFlowIconButton(
        //   borderColor: Colors.transparent,
        //   borderRadius: 30,
        //   borderWidth: 1,
        //   buttonSize: 60,
        //   icon: Icon(
        //     Icons.arrow_back_rounded,
        //     color: Colors.black,
        //     size: 30,
        //   ),
        //   onPressed: () => {Navigator.pop(context)},
        // ),
        title: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(-0.2, 0),
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
              alignment: AlignmentDirectional(-0.2, 0),
              child: Text(
                widget.music.albumName ?? "not set",
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

      body: Stack(
        // mainAxisSize: MainAxisSize.min,
        children: [
          // add widget

// Spacer(),

          Positioned.fill(
            left: 0,
            top: 180,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(
                    'assets/images/Group_8_Copy_(1).png',
                  ).image,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      // shrinkWrap: true,
                      children: [
                        Spacer(),
                        // image carousal slider
                        Container(
                          // width: w,
                          // height: 200,
                          child: GestureDetector(
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
                              carouselController: _controller,
                              items:
                                  List.generate(_musicList.length, (carIndex) {
                                print(
                                    "image = ${_musicList[carIndex].musicImage}");
                                // setState(() {
                                //   index=carIndex;
                                // });
                                return Container(
                                  width: 191,
                                  height: 191,
                                  margin: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://admin.koinoniaconnect.org/" +
                                              _musicList[carIndex].musicImage),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              }),

                              //Slider Container properties
                              options: CarouselOptions(
                                height: 191.0,
                                // onScrolled: () => {next()},
                                enlargeCenterPage: true,
                                initialPage: myCurrentImageIndex,
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
                        ),

                        // song name
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
                        //
                        // // song artist name
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                widget.music.artists!.isEmpty
                                    ? ""
                                    : widget.music.artists![0].artistName ?? "",
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
                        SizedBox(
                          height: 20,
                        ),
                        //
                        // // icon row having download, repear etc
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
                                if (widget.userid == "3") {
                                  var snackBar = SnackBar(
                                    content: Text(
                                      'Please Login to Download',
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
                                } else if (Networkutils.download == 1) {
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
                                } else {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 300),
                                      pageBuilder: (ctx, animation,
                                              secondaryAnimation) =>
                                          ChoosePlanScreen(
                                              userid: widget.userid),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return SlideTransition(
                                          position: new Tween<Offset>(
                                            begin: const Offset(1.0, 0.0),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: SlideTransition(
                                            position: Tween<Offset>(
                                              begin: Offset.zero,
                                              end: const Offset(1.0, 0.0),
                                            ).animate(secondaryAnimation),
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                ;
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
                                _toggleRepeat();
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
                                  _listhasbeenPressed = !_listhasbeenPressed;
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
                                _toggleShuffle();
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
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 30,
                              borderWidth: 1,
                              buttonSize: 30,
                              icon: Icon(
                                Icons.favorite,
                                color: isLikedfromserver
                                    ? Color(0xFFF15C00)
                                    : Colors.black,
                                size: 20,
                              ),
                              onPressed: () {
                                if (widget.userid == "3") {
                                  var snackBar = SnackBar(
                                    content: Text(
                                      'Please Login',
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
                                } else {
                                  onLikeButtonTapped(isliked);
                                  setState(() {
                                    isliked = !isliked;
                                    isLikedfromserver = !isLikedfromserver;
                                  });
                                }
                                ;
                              },
                            ),
                          ],
                        ),

                        Spacer(),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  //
                  // // song timer slider

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("${_positionToString(_position)}"),
                        Expanded(
                          child: Slider(
                            activeColor: Color(0xFFF15C00),
                            thumbColor: Color(0xFFF15C00),
                            value: _position.inSeconds.toDouble(),
                            min: 0.0,
                            max: _duration.inSeconds.toDouble(),
                            onChanged: (value) =>
                                _seek(Duration(seconds: value.toInt())),
                          ),
                        ),
                        Text("${_durationToString(_duration)}"),
                      ],
                    ),
                  ),
                  // SizedBox(height: 10,),
                  //
                  // // song play, pause, forword backward button
                  Container(
                    // height: 100,
                    child: Padding(
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
                            icon: new Image.asset('assets/images/nextsong.png',
                                width: 60),
                            onPressed: _next,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: FlutterFlowAdBanner(
                      width: MediaQuery.of(context).size.width,
                      height: 170,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Spacer(),
        ],
      ),
    );
  }
}
