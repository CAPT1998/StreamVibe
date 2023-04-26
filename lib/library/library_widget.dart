import 'dart:convert';

import 'package:koinonia/albums/albums_widget.dart';
import 'package:koinonia/following/following_widget.dart';
import 'package:koinonia/src/widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../flutter_flow/flutter_flow_ad_banner.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../likedsongs.dart';
import '../main.dart';
import '../model/musics.dart';
import '../playing/playing_widget.dart';
import '../playlist/getallplaylist_widget.dart';
import 'library_model.dart';
export 'library_model.dart';

class LibraryWidget extends StatefulWidget {
  const LibraryWidget({Key? key}) : super(key: key);

  @override
  _LibraryWidgetState createState() => _LibraryWidgetState();
}

class _LibraryWidgetState extends State<LibraryWidget> {
  late LibraryModel _model;
  List<Musics> _playedSongs = [];
  String userid = ' ';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    sharedprefs();

    _model = createModel(context, () => LibraryModel());
    _loadPlayedSongs();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  Future<void> sharedprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid")!;
    });
    print("current_user_id is " + userid);
  }

  Future<void> _loadPlayedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('played_songs_${userid}')) {
      final playedSongsJson = prefs.getStringList('played_songs_${userid}');
      print("playedSongsJson = $playedSongsJson");

      if (playedSongsJson != null) {
        final playedSongs = playedSongsJson
            .map((item) => Musics.fromJson(json.decode(item)))
            .toList();
        setState(() {
          _playedSongs = playedSongs;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (ctx, animation, secondaryAnimation) => NavBarPage(
              initialPage: 'HomePage',
              userid: userid,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
        //trigger leaving and use own data

        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: CustomAppBar(title: 'Library', userid: userid,),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: ListView(
                      // padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GestureDetector(
                              onTap: () => {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    transitionDuration:
                                        Duration(milliseconds: 300),
                                    pageBuilder:
                                        (ctx, animation, secondaryAnimation) =>
                                            NavBarPage(
                                      userid: userid,
                                      initialPage: 'Library',
                                      page: likedwidget(
                                        userid: userid,
                                      ),
                                    ),
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
                                ),
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          21, 0, 0, 0),
                                      child: Text(
                                        'Liked Tracks',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                              fontFamily: 'Urbanist',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: AlignmentDirectional(0.9, 0),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: FlutterFlowTheme.of(context)
                                              .customColor4,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 300),
                                pageBuilder:
                                    (ctx, animation, secondaryAnimation) =>
                                        NavBarPage(
                                            userid: userid,
                                            initialPage: 'Library',
                                            page: getallPlaylistWidget(
                                              userid: userid,
                                            )),
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
                            ),
                          },
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            21, 0, 0, 0),
                                        child: Text(
                                          'Playlists',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Urbanist',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.9, 0),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: FlutterFlowTheme.of(context)
                                                .customColor4,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 300),
                                pageBuilder:
                                    (ctx, animation, secondaryAnimation) =>
                                        NavBarPage(
                                            userid: userid,
                                            initialPage: 'Library',
                                            page: AlbumsWidget(
                                              userid: userid,
                                            )),
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
                            ),
                          },
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            21, 0, 0, 0),
                                        child: Text(
                                          'Albums',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Urbanist',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.9, 0),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: FlutterFlowTheme.of(context)
                                                .customColor4,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                onTap: () => {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 300),
                                      pageBuilder: (ctx, animation,
                                              secondaryAnimation) =>
                                          NavBarPage(
                                              userid: userid,
                                              initialPage: 'Library',
                                              page: FollowingWidget(
                                                userid: userid,
                                              )),
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
                                  ),
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            21, 0, 0, 0),
                                        child: Text(
                                          'Following',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Urbanist',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.9, 0),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: FlutterFlowTheme.of(context)
                                                .customColor4,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  shape: BoxShape.rectangle,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          21, 0, 0, 0),
                                      child: Text(
                                        'PDF Library',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                              fontFamily: 'Urbanist',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: AlignmentDirectional(0.9, 0),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: FlutterFlowTheme.of(context)
                                              .customColor4,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        */
                        Container(
                          width: 100,
                          height: 80,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    //alignment: AlignmentDirectional(-0.1, 0.1),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15, 0, 0, 0),
                                      child: Text(
                                        'Listening History',
                                        textAlign: TextAlign.end,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                              fontFamily: 'Urbanist',
                                              fontSize: 21,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          itemCount: _playedSongs.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(), // new
                          //controller: ScrollController(),

                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final music = _playedSongs[index];
                            return GestureDetector(
                              onTap: () => {},
                              child: ListTile(
                                title: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 15, 0, 10),
                                  child: Text(
                                    music.musicTitle,
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      color:
                                          FlutterFlowTheme.of(context).black600,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                leading: Container(
                                  width: 60.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    //shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        "https://admin.koinoniaconnect.org/" +
                                            music.musicImage,
                                      ),
                                    ),
                                  ),
                                ),
                                subtitle: Text(music.albumName ?? "not set"),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
