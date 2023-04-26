import 'dart:convert';

import 'package:koinonia/likedsongs.dart';
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
import '../model/viewAlbum.dart';

import 'package:http/http.dart' as http;
import 'dart:async';

import '../playing/playercheck/musicplayer.dart';
import '../playing/playing_widget.dart';

class homepagequickplay extends StatefulWidget {
  String userid;
   homepagequickplay({Key? key,required this.userid}) : super(key: key);

  @override
  _homepagealbumwidgetState createState() => _homepagealbumwidgetState();
}

class getAllMusicsApi {
  static Future<List<Musics>> getallalbums() async {
    //print("HElloworld");

    final url = Uri.parse('https://admin.koinoniaconnect.org/API/getAllMusics');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List music = json.decode(response.body);

      return music.map((json) => Musics.fromJson(json)).toList();
      //artistinfo.map((json) => Artists.fromJson(json)).toList();
    }
    throw Exception();
  }
}

class _homepagealbumwidgetState extends State<homepagequickplay> {
  List<Musics> allMusic = [];
  List<Artists> artistinfo = [];
  List allalbumimage = [];
  List allMusicsinfo = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List AllArtistsinfo = [];

  Future init1() async {
    final music = await getAllMusicsApi.getallalbums();
    if (!mounted) return;

    setState(() => this.allMusic = music);
    setState(() {
      this.artistinfo = artistinfo;
    });
    print("hello world");
    //  _model = createModel(context, () => AlbumsModel());
    if (!mounted) return;
  }

  @override
  void initState() {
    init1();
    allMusic.shuffle();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  Widget buildAlbum(Musics music, id) => Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
        child: Container(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (ctx, animation, secondaryAnimation) =>
                    PlayingWidget2(
                      allMusicList: allMusic,
                  singleMusic: music,
                  userid: id,
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
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.15, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      // ignore: prefer_interpolation_to_compose_strings
                      "https://admin.koinoniaconnect.org/" + music.musicImage,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: AlignmentDirectional(0, -0.15),
                    child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                        child: Text(
                          music.musicTitle,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                // reverse: true,
                scrollDirection: Axis.horizontal,
                itemCount: allMusic.length,
                itemBuilder: (context, index) {
                  final Musics = allMusic[index];

                  //final Artists = artistinfo[index];

                  return buildAlbum(Musics, widget.userid);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
