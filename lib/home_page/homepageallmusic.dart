import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koinonia/index.dart';
import 'package:koinonia/likedsongs.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
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

class hompageallmusic extends StatefulWidget {
  String userid;
  hompageallmusic({Key? key, required this.userid}) : super(key: key);

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

class _homepagealbumwidgetState extends State<hompageallmusic> {
  List<Musics> allMusic = [];
  List<Artists> artistinfo = [];
  List allalbumimage = [];
  List allMusicsinfo = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List AllArtistsinfo = [];

  Future init1() async {
    final music = await getAllMusicsApi.getallalbums();
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
              Navigator.of(context).push(
                PageRouteBuilder(
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
                ),
              );
            },
            child: Column(
              //mainAxisSize: MainAxisSize.max,

              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        // ignore: prefer_interpolation_to_compose_strings
                        "https://admin.koinoniaconnect.org/" + music.musicImage,
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Text(
                        music.musicTitle,
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign:
                            TextAlign.center, // optional, to center the text
                      ),
                    ),
                  ],
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
      appBar:
          /*AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: FlutterFlowTheme.of(context).black600),
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Music',
              style: FlutterFlowTheme.of(context).title2.override(
                    fontFamily: 'Urbanist',
                    color: FlutterFlowTheme.of(context).black600,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(90, 0, 0, 0),
                child: FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: 'Upgrade',
                  options: FFButtonOptions(
                    width: MediaQuery.of(context).size.width * 0.26,
                    height: 30,
                    color: Color(0xFFF15C00),
                    textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(23),
                  ),
                ),
              ),
            ),
            new Expanded(
              flex: 1,
              child: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30,
                borderWidth: 1,
                buttonSize: 60,
                icon: FaIcon(
                  FontAwesomeIcons.solidBell,
                  color: Color(0xFFF15C00),
                  size: 25,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
            ),
          ],
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      */
          AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        iconTheme:
            IconThemeData(color: FlutterFlowTheme.of(context).customColor4),
        automaticallyImplyLeading: true,
        title: Align(
          alignment: AlignmentDirectional(-0.20, 0),
          child: Text(
            'Files',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).title2.override(
                  fontFamily: 'Poppins',
                  color: Color(0xFF150734),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      key: scaffoldKey,
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(30),
                scrollDirection: Axis.vertical,
                itemCount: allMusic.length,
                itemBuilder: (context, index) {
                  final Musics = allMusic[index];

                  //final Artists = artistinfo[index];

                  return buildAlbum(Musics, widget.userid);
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
