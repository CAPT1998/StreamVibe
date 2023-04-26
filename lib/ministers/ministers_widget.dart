import 'dart:async';
import 'dart:convert';

import 'package:koinonia/home_page/homepage_recentlyadded_widget.dart';

import '../Api/Networkutils.dart';
import '../flutter_flow/flutter_flow_ad_banner.dart';
import '../flutter_flow/flutter_flow_audio_player.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/ministermusicmodel.dart';
import '../model/musics.dart';
import '../model/viewArtist.dart';
import '../playing/playercheck/ministermusicplayer.dart';
import '../playing/playercheck/musicplayer.dart';
import 'ministers_model.dart';
export 'ministers_model.dart';
import 'package:http/http.dart' as http;

import 'ministersongs.dart';

class MinistersWidget extends StatefulWidget {
  //const MinistersWidget({Key? key}) : super(key: key);
  final String artistid;
  final String artistname;
  final String artstimage;
  final String userid;
  // final String countview;
  // final int album;
  // final String type;
  MinistersWidget(this.artistid, this.artistname, this.artstimage, this.userid
      // this.countview,
      //this.album,
      // this.type,
      );

  @override
  _MinistersWidgetState createState() => _MinistersWidgetState();
}

class getuserfollowedartist {
  static Future<List<ViewArtistItem>> userfollowedartists(String userid) async {
    final url = Uri.parse(
        'https://admin.koinoniaconnect.org/API/getuserfollowedartist');
    final response = await http.post(url, body: {
      'user_id': userid,
    });

    if (response.statusCode == 200) {
      final List followedartist = json.decode(response.body);

      return followedartist
          .map((json) => ViewArtistItem.fromJson(json))
          .toList();
    }
    throw Exception();
  }
}

class _MinistersWidgetState extends State<MinistersWidget> {
  late MinistersModel _model;
  List<Ministermusicmodel> playlistsongs = [];
  late StreamController<List<ViewArtistItem>> _controller;
  bool _isFollowing = false;
  late Networkutils networkutils;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List<Ministermusicmodel> songs = [];

  @override
  void initState() {
    super.initState();
    networkutils = Networkutils();
    print("artist id is " + widget.artistid);

    _model = createModel(context, () => MinistersModel());
    init1();
    _controller = StreamController<List<ViewArtistItem>>.broadcast();
    getuserfollowedartist
        .userfollowedartists(widget.userid)
        .then((followedArtists) {
      _controller.add(followedArtists);
      _isFollowing =
          followedArtists.any((artist) => artist.artistId == widget.artistid);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  Future<void> unfollow(String id) async {
    await networkutils.unfollowminister(widget.userid, id);
    setState(() {});
  }

  Future<void> followminister(String uid, String mid) async {
    await networkutils.followminister(uid, mid);
    init1();
    setState(() {});
  }

  getallalbumsongs(String artistid) async {
    //print("HElloworld");

    final url = Uri.parse('https://admin.koinoniaconnect.org/API/viewArtist');
    final response = await http.post(url, body: {
      'user_id': '1',
      'artist_id': artistid,
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      final data = jsonResponse['music_list'];

      setState(() {
        songs = List<Ministermusicmodel>.from(
            data.map((json) => Ministermusicmodel.fromJson(json)));
      });

      //artistinfo.map((json) => Artists.fromJson(json)).toList();
    }
  }

  Future init1() async {
    await getallalbumsongs(widget.artistid);
    //setState(() => this.songs = songs);
    // setState(() {
    //   this.artistinfo = artistinfo;
    //});
    print("hello world");
    //model = createModel(context, () => AlbumsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  // Widget buildplaylistsongs(Ministermusicmodel songs, id) => Container(
  //       child: GestureDetector(
  //         onTap: () {
  //           Navigator.of(context).push(
  //             PageRouteBuilder(
  //               transitionDuration: Duration(milliseconds: 300),
  //               pageBuilder: (ctx, animation, secondaryAnimation) =>
  //                   ministermusicplayer(
  //                 music: songs,
  //                 userid: id,
  //                     mid: widget.artistid,
  //               ),
  //               transitionsBuilder:
  //                   (context, animation, secondaryAnimation, child) {
  //                 return SlideTransition(
  //                   position: new Tween<Offset>(
  //                     begin: const Offset(1.0, 0.0),
  //                     end: Offset.zero,
  //                   ).animate(animation),
  //                   child: SlideTransition(
  //                     position: Tween<Offset>(
  //                       begin: Offset.zero,
  //                       end: const Offset(1.0, 0.0),
  //                     ).animate(secondaryAnimation),
  //                     child: child,
  //                   ),
  //                 );
  //               },
  //             ),
  //           );
  //         },
  //         child: Column(
  //           //mainAxisSize: MainAxisSize.max,
  //           children: [
  //             Align(
  //               alignment: AlignmentDirectional(0.15, 0),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(22),
  //                 child: Image.network(
  //                   // ignore: prefer_interpolation_to_compose_strings
  //                   "https://admin.koinoniaconnect.org/" + songs.musicImage,
  //                   width: 100,
  //                   height: 100,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               child: Align(
  //                 alignment: AlignmentDirectional(0, 0),
  //                 child: Padding(
  //                     padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
  //                     child: Text(
  //                       songs.artists![0].artistName,
  //                       style: FlutterFlowTheme.of(context).bodyText1.override(
  //                             fontFamily: 'Urbanist',
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                     )),
  //               ),
  //             ),
  //             Container(
  //                 child: Text(
  //               songs.musicTitle,
  //               style: FlutterFlowTheme.of(context).bodyText1.override(
  //                     fontFamily: 'Urbanist',
  //                     color: Color(0xFFA7A7A7),
  //                     fontSize: 10,
  //                     fontWeight: FontWeight.normal,
  //                   ),
  //             ))
  //           ],
  //         ),
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
        title: Align(
          alignment: AlignmentDirectional(-0.2, 0),
          child: Text(
            'Ministers',
            style: FlutterFlowTheme.of(context).title2.override(
                  fontFamily: 'Poppins',
                  color: Color(0xFF090F13),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlutterFlowAdBanner(
                width: MediaQuery.of(context).size.width,
                height: 50,
              ),
              Container(
                width: MediaQuery.of(context).size.width > 600
                    ? MediaQuery.of(context).size.width
                    : 375,
                height: 375,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.asset(
                      'assets/images/Group_8_Copy.png',
                    ).image,
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, -0.4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(53),
                        child: Image.network(
                          // ignore: prefer_interpolation_to_compose_strings

                          // "https://admin.koinoniaconnect.org/" + widget.artstimage,
                          "https://admin.koinoniaconnect.org/" +
                              widget.artstimage,
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.95, 0.75),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (widget.userid == '3') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please login ')));
                          } else {
                            _isFollowing = !_isFollowing;
                            if (_isFollowing) {
                              // Follow logic
                              await followminister(
                                  widget.userid, widget.artistid);
                              print('followed');
                            } else {
                              // Unfollow logic
                              await unfollow(widget.artistid);
                              print('unfollowed');
                            }
                          }
                        },
                        text: _isFollowing ? 'Unfollow' : 'Follow',
                        options: FFButtonOptions(
                          width: 90,
                          height: 30,
                          color: Color(0xFFF15C00),
                          textStyle:
                              FlutterFlowTheme.of(context).subtitle2.override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.95, 0.50),
                      child: FFButtonWidget(
                        onPressed: () {
                          songs.length == 0
                              ? null
                              : Navigator.of(context).push(
                                  PageRouteBuilder(
                                    transitionDuration:
                                        Duration(milliseconds: 300),
                                    pageBuilder:
                                        (ctx, animation, secondaryAnimation) =>
                                            ministermusicplayer(
                                      allSongs: songs,
                                      music: songs[0],
                                      userid: widget.userid,
                                      mid: widget.artistid,
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
                                );
                        },
                        text: 'Play',
                        options: FFButtonOptions(
                          width: 90,
                          height: 30,
                          color: Color(0xFFF15C00),
                          textStyle:
                              FlutterFlowTheme.of(context).subtitle2.override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.89, 0.49),
                      child: Text(
                        widget.artistname,
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Urbanist',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    /*
                    Align(
                      alignment: AlignmentDirectional(-0.93, 0.66),
                      child: Text(
                        '12 Following',
                        style: FlutterFlowTheme.of(context).bodyText1,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.18, 0.67),
                      child: Text(
                        '232 Followers',
                        style: FlutterFlowTheme.of(context).bodyText1,
                      ),
                    ),
                    */
                    Align(
                      alignment: AlignmentDirectional(-0.9, 0.75),
                      child: Text(
                        'Top Tracks',
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              color: Colors.black,
                              fontFamily: 'Urbanist',
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ministermusic(widget.artistid, widget.artistname,
                    widget.artstimage, widget.userid),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
