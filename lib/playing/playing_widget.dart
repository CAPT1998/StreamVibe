import 'dart:convert';

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
import '../flutter_flow/flutter_flow_ad_banner.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:like_button/like_button.dart';

import '../model/musics.dart';
import 'playing_model.dart';
export 'playing_model.dart';

class PlayingWidget extends StatefulWidget {
  final String musicid;
  final String musicalbumname;
  final String musicfile;
  final String musicimage;
  final String musictitle;
  final String musicartist;

  const PlayingWidget({
    Key? key,
    required this.musicid,
    required this.musicalbumname,
    required this.musicfile,
    required this.musicimage,
    required this.musictitle,
    required this.musicartist,
  }) : super(key: key);

  @override
  _PlayingWidgetState createState() => _PlayingWidgetState();
}

class _PlayingWidgetState extends State<PlayingWidget> {
  //late PlayingModel _model;
  late Networkutils networkutils;
  List<Musics> musicList = [];
  final AudioPlayer audioPlayer = AudioPlayer();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  Future<List<Musics>> fetchMusicList() async {
    final response = await http
        .get(Uri.parse('https://admin.koinoniaconnect.org/API/getAllMusics'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Musics> musicList =
          data.map((json) => Musics.fromJson(json)).toList();
      return musicList;
    } else {
      throw Exception('Failed to fetch music list');
    }
  }

  void playMusic(int index) async {
    final music = musicList[index];
    await audioPlayer.setAudioSource((AudioSource.uri(
        Uri.parse("https://admin.koinoniaconnect.org/" + music.musicFile))));
    await audioPlayer.play();
  }

  int currentPlayingIndex = 0;

  void playNextMusic() async {
    if (currentPlayingIndex == musicList.length - 1) {
      // reached the end of the list, do something (e.g., stop playing)
      return;
    }

    currentPlayingIndex++;
    playMusic(currentPlayingIndex);
  }

  @override
  void initState() {
    //   fetchMusicList().then((list) {
    //     setState(() {
    //      musicList = list;
    //    });
    //          playMusic(0);

    //  });
    super.initState();
    //  _model = createModel(context, () => PlayingModel());
    networkutils = Networkutils();
  }

  @override
  void dispose() {
    // _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    await networkutils.addtoliked("1", "6");

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

  Future<void> _download() async {
    _localPath = (await _findLocalPath()) + '/Download';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    // pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    dialog();

    Dio dio = Dio();

    var dirToSave = await getApplicationDocumentsDirectory();

    await dio.download("https://admin.koinoniaconnect.org/" + widget.musicfile,
        "$_localPath/" + widget.musictitle + ".mp3",
        onReceiveProgress: (rec, total) {
      setState(() {
        downloading = true;

        // pr.show();
        dialog();

        Future.delayed(Duration(seconds: 2)).then((onvalue) {
          percentage = (percentage + 1.0);
          print("=======================>>>" + percentage.toString());
          print("${dirToSave.path}/" + widget.musictitle + ".mp3");
        });
      });
    });

    setState(() {
      downloading = false;
      print("${dirToSave.path}/" + widget.musictitle + ".mp3");
      progress = "Complete";
      Fluttertoast.showToast(
        msg: "Download Complated!" +
            "${dirToSave.path}/" +
            widget.musictitle +
            ".mp3",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      // pr.hide().whenComplete(() {});
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
                widget.musicartist,
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
                            CarouselSlider(
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
                                              widget.musicimage),
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
                                    borderRadius: BorderRadius.circular(40.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://images.saymedia-content.com/.image/c_limit%2Ccs_srgb%2Cq_auto:eco%2Cw_700/MTg1ODQ2NjYxNzQ0OTYwNjQx/popular-english-songs-top-300-best-songs-of-all-time.webp"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                //3rd Image of Slider
                                Container(
                                  width: 151,
                                  height: 151,
                                  margin: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.0),
                                    image: DecorationImage(
                                      image: Image.asset(
                                        'assets/images/455ae48a81e56c1d908f971b50d0f823.png',
                                      ).image,
                                    ),
                                  ),
                                ),

                                //4th Image of Slider

                                //5th Image of Slider
                              ],

                              //Slider Container properties
                              options: CarouselOptions(
                                height: 180.0,
                                enlargeCenterPage: true,
                                autoPlay: false,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                viewportFraction: 0.5,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Text(
                                      widget.musictitle,
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
                                    // widget.musicartist,
                                    widget.musicartist,
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
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _download();

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
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 20,
                                  ),
                                  onPressed: () {
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
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 15,
                                  ),
                                  onPressed: () {
                                    print('IconButton pressed ...');
                                  },
                                ),
                                FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 30,
                                  borderWidth: 1,
                                  buttonSize: 30,
                                  icon: Icon(
                                    Icons.shuffle,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 20,
                                  ),
                                  onPressed: () {
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
                                  isLiked: true,
                                  postFrameCallback: (LikeButtonState state) {
                                    state.controller?.forward();
                                  },
                                  onTap: onLikeButtonTapped,
                                ),
                              ],
                            ),
                            Container(
                              width: 300,
                              height: 170,
                              child: custom_widgets.AudioPlayerWidget(
                                  width: 300,
                                  height: 100,
                                  musicfile: widget.musicfile),
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
