import 'dart:convert';

import 'package:koinonia/index.dart';
import 'package:koinonia/likedsongs.dart';
import 'package:koinonia/playing/playercheck/musicplayer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ministers/ministers_widget.dart';
import '../flutter_flow/flutter_flow_ad_banner.dart';
import '../flutter_flow/flutter_flow_audio_player.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/musics.dart';
//import 'albums_model.dart';
//export 'albums_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'Api/Networkutils.dart';

class likedwidget extends StatefulWidget {
  final String userid;
  likedwidget({Key? key, required this.userid}) : super(key: key);

  @override
  _AlbumsWidgetState createState() => _AlbumsWidgetState();
}

class getuserlikedmusicApi {
  static Future<List<Musics>> getalluserlikedmusic(String userid) async {
    final url =
        Uri.parse('https://admin.koinoniaconnect.org/API/getuserlikedmusic');
    final response = await http.post(url, body: {
      'user_id': userid,
    });

    if (response.statusCode == 200) {
      final List likedmusic = json.decode(response.body);

      return likedmusic.map((json) => Musics.fromJson(json)).toList();
    }
    throw Exception();
  }
}

class _AlbumsWidgetState extends State<likedwidget> {
  List<Musics> allMusic = [];
  String userid = "";
  late Networkutils networkutils;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  Future init1() async {
    print("user id is" + userid);

    final music =
        await getuserlikedmusicApi.getalluserlikedmusic(widget.userid);
    setState(() => this.allMusic = music);
    print("hello world");
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void initState() {
    sharedprefs();

    init1();
    super.initState();
    networkutils = Networkutils();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future showExitPopup(BuildContext context, id) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are You Sure?'),
          content: Text('Are You Want to Remove Track!'),
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
                SnackBar(
                  backgroundColor: Color(0xFFF15C00),
                  content: Text('Track Removed!'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deletePlaylistMusic(String id) async {
    await networkutils.deletelikedmusic(widget.userid, id);
    setState(() {});
  }

  @override
  void dispose() {
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

  Widget buildAlbum(Musics music) => Container(
        child: GestureDetector(
          onLongPress: () async {
            await showExitPopup(context, music.musicId);
          },
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (ctx, animation, secondaryAnimation) =>
                    PlayingWidget2(
                  allMusicList: allMusic,
                  singleMusic: music,
                  userid: widget.userid,
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
          },
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(0.15, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(
                    // ignore: prefer_interpolation_to_compose_strings
                    "https://admin.koinoniaconnect.org/" + music.musicImage,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                  child: Text(
                    music.musicTitle,
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  )),
              Text(
                music.albumName ?? "Not set",
                style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Urbanist',
                      color: Color(0xFFA7A7A7),
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(
    BuildContext context,
  ) {
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
          alignment: AlignmentDirectional(-0.2, 0),
          child: Text(
            'Liked Tracks',
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
      body: widget.userid == "3"
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'You must be logged in to view Liked Tracks',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF15C00),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 300),
                          pageBuilder: (ctx, animation, secondaryAnimation) =>
                              SignInWidget(),
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
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            )
          : Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: allMusic.length,
                      itemBuilder: (context, index) {
                        final Musics = allMusic[index];

                        return buildAlbum(Musics);
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
