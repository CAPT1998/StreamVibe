import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:koinonia/model/musics.dart';
import 'package:koinonia/src/helpers/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api/Networkutils.dart';
import '../flutter_flow/flutter_flow_ad_banner.dart';
import '../flutter_flow/flutter_flow_audio_player.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../home_page/homepageallmusic.dart';
import '../model/playlistsongsmodel.dart';
import '../playing/playercheck/musicplayer.dart';
import '../playing/playercheck/playlistplayer.dart';
import '../src/helpers/utils.dart';
import 'addinplaylist.dart';
import 'playlist_model.dart';
export 'playlist_model.dart';

class PlaylistWidget extends StatefulWidget {
  late final String userid;
  late final List image;
  late final String playlistName;
  late final String playlistId;
  PlaylistWidget(this.image, this.playlistName, this.playlistId, this.userid);
  @override
  _PlaylistWidgetState createState() => _PlaylistWidgetState();
}

class GetAllPlaylistSongsAPI {
  static Future<List<Platylistmusic>> getallplaylistsongs(
      String userid, String playlistid) async {
    //print("HElloworld");

    final url =
        Uri.parse('https://admin.koinoniaconnect.org/API/getPlaylistMusic');
    final response = await http.post(url, body: {
      'user_id': userid,
      'user_playlist_id': playlistid,
    });

    if (response.statusCode == 200) {
      final List playlistmusic = json.decode(response.body);
      //final List artistinfo = json.decode(response.body);

      return playlistmusic
          .map((json) => Platylistmusic.fromJson(json))
          .toList();
      //artistinfo.map((json) => Artists.fromJson(json)).toList();
    }
    throw Exception();
  }
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  List<Platylistmusic> allPlaylistSongs = [];
  String playlistid = "";
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late Networkutils networkutils;
  late String userid;
  bool fetching = true;
  @override
  void initState() {
    super.initState();
    networkutils = Networkutils();
    userid = "";
    init1();
    sharedprefs();
    setState(() {
      playlistid = widget.playlistId;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future init1() async {
    final playlistsongs = await GetAllPlaylistSongsAPI.getallplaylistsongs(
        widget.userid, widget.playlistId);
    setState(() {
      fetching = false;
      this.allPlaylistSongs = playlistsongs;
    });
    // setState(() {
    //   this.artistinfo = artistinfo;
    //});
    print(
        "hello world, this.allPlaylistSongs = ${this.allPlaylistSongs.length}");
    //model = createModel(context, () => AlbumsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future showExitPopup(BuildContext context, id) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are You Sure?'),
          content: Text('Are You Want to Remove this music from playlist!'),
          actions: <Widget>[
            TextButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // ignore: deprecated_member_use
            ElevatedButton(
              style: ButtonStyle(),
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                await deletePlaylistMusic(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deletePlaylistMusic(String id) async {
    await networkutils.deleteMusic(id);
    init1();
    setState(() {});
  }

  sharedprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid")!;
    });
    print("current_user_id is " + userid);
  }

  @override
  void dispose() {
    //_model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  Widget buildplaylistsongs(Platylistmusic playlistsongs, id) {
    print("inside buildplaylistsongs");
    print("inside playlistsongs length: ${playlistsongs}");

    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: InkWell(
        onLongPress: () async {
          await showExitPopup(context, playlistsongs.musicId);
        },
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (ctx, animation, secondaryAnimation) => playlistplayer(
              allSongs: allPlaylistSongs,
              music: playlistsongs,
              userid: id,
              pid: widget.playlistId,
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
          ));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          //mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  // ignore: prefer_interpolation_to_compose_strings
                  "https://admin.koinoniaconnect.org/" +
                      playlistsongs.musicImage,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                // mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: Text(
                          playlistsongs.musicTitle,
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                        ),
                      ),
                      Text(
                        playlistsongs.artists![0].artistName,
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Open Sans',
                              color: Color(0xFF919191),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ],
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
          alignment: AlignmentDirectional(-0.20, 0),
          child: Text(
            'Playlist',
            style: FlutterFlowTheme.of(context).title2.override(
                  fontFamily: 'Poppins',
                  color: Color(0xFF090F13),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      body: RefreshIndicator(
        key: Utils.singlePlaylistRefreshIndicatorKey,
        color: Colors.white,
        backgroundColor: Color(0xFFF15C00),
        strokeWidth: 4.0,
        edgeOffset: 10,
        // displacement: 40,
        onRefresh: () {
          // Replace this delay with the code to be executed during refresh
          // and return a Future when code finishs execution.
          // return Future<void>.delayed(const Duration(seconds: 3));
          return init1();
        },
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FlutterFlowAdBanner(
                  width: 100,
                  height: 70,
                  userid: widget.userid,
                ),
                SizedBox(
                  width: 466.2,
                  height: 250,
                  //decoration: BoxDecoration(
                  // color: Colors.white,

                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                        child: Align(
                          alignment: AlignmentDirectional(0, -0.82),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              'assets/images/imageedit_2_5667739343.gif',
                              width: 360,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.69, 0.50),
                        child: Text(
                          widget.playlistName,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      /*   Align(
                        alignment: AlignmentDirectional(-0.69, -0.42),
                        child: Text(
                          'Playlist By Anamwp',
                          style: FlutterFlowTheme.of(context).bodyText1.override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ), */
                      Align(
                        alignment: allPlaylistSongs.length > 0
                            ? AlignmentDirectional(0.52, 0.55)
                            : AlignmentDirectional(0.8, 0.55),
                        child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30,
                          borderWidth: 1,
                          buttonSize: 60,
                          icon: Icon(
                            Icons.add_circle_outline_outlined,
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 300),
                                pageBuilder:
                                    (ctx, animation, secondaryAnimation) =>
                                        addinplaylist(
                                  widget.playlistId,
                                  widget.userid,
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Color(0xFFF15C00),
                                content: Text('Tap a Track to add it'),
                              ),
                            );
                          },
                        ),
                      ),
                      allPlaylistSongs.length == 0
                          ? SizedBox.shrink()
                          : Align(
                              alignment: AlignmentDirectional(0.8, 0.55),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30,
                                borderWidth: 1,
                                buttonSize: 60,
                                icon: FaIcon(
                                  FontAwesomeIcons.playCircle,
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBtnText,
                                  size: 25,
                                ),
                                onPressed: allPlaylistSongs.length == 0
                                    ? null
                                    : () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 300),
                                            pageBuilder: (ctx, animation,
                                                    secondaryAnimation) =>
                                                playlistplayer(
                                              allSongs: allPlaylistSongs,
                                              music: allPlaylistSongs[0],
                                              userid: widget.userid,
                                              pid: widget.playlistId,
                                            ),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
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
                              ),
                            ),
                      Align(
                        alignment: AlignmentDirectional(-0.85, 0.95),
                        child: Text(
                          'Your Songs',
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Inter',
                                    fontSize: 21,
                                    fontWeight: FontWeight.w500,
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
                                      addinplaylist(
                                widget.playlistId,
                                widget.userid,
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tap a Track to add it'),
                            ),
                          ),
                        },
                        child: Align(
                          alignment: AlignmentDirectional(0.79, 0.95),

                          // style: TextButton.styleFrom(
                          //   foregroundColor: Color(0xFFF15C00),
                          //   //disabledForegroundColor : Colors.grey, // Disable color
                          // ),
                          child: Text(
                            'Add Song',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFF15C00),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20, top: 20),
                  child: fetching
                      ? SpinKitWave(
                          color: AppColors.DARK_ORANGE,
                          size: 50.0,
                        )
                      : allPlaylistSongs.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: allPlaylistSongs.length,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                print(
                                    "allPlaylistSongs length: ${allPlaylistSongs.length}");
                                final Playlistsongs = allPlaylistSongs[index];

                                return buildplaylistsongs(
                                    Playlistsongs, widget.userid);
                              },
                            )
                          : Text(
                              'Playlist is empty!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFFF15C00),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
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
