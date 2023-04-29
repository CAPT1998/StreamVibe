import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:koinonia/home_page/playerforcategorymusic.dart';

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
import '../model/categorymusicmodel.dart';
import '../model/musics.dart';

import 'package:http/http.dart' as http;
import 'dart:async';

import '../playing/playercheck/categorymusicplayer.dart';
import '../playing/playercheck/musicplayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class categorymusic extends StatefulWidget {
  final String catid;
  final String catname;
  final String userid;
  categorymusic(
      {Key? key,
      required this.catid,
      required this.catname,
      required this.userid})
      : super(key: key);

  @override
  _AlbumsWidgetState createState() => _AlbumsWidgetState();
}

class getAllMusicsApi {
  static Future<List<Categorymusicmodel>> getallalbums(String id) async {
    print("HElloworld");

    final url = Uri.parse('https://admin.koinoniaconnect.org/API/getcatmusic');
    final response = await http.post(url, body: {
      'user_id': '1',
      'category_id': id,
    });

    if (response.statusCode == 200) {
      final List music = json.decode(response.body);

      return music.map((json) => Categorymusicmodel.fromJson(json)).toList();
      //artistinfo.map((json) => Artists.fromJson(json)).toList();
    }
    throw Exception();
  }
}

class _AlbumsWidgetState extends State<categorymusic> {
  List<Categorymusicmodel> allMusic = [];
  List<Categorymusicmodel> artistinfo = [];
  List allalbumimage = [];
  List allMusicsinfo = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List AllArtistsinfo = [];
  late String userid;

  Future init1() async {
    final music = await getAllMusicsApi.getallalbums(widget.catid);
    setState(() => this.allMusic = music);
    setState(() {
      this.artistinfo = music;
    });
    print("inside init1 category music");
    //  _model = createModel(context, () => AlbumsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

 

  @override
  void initState() {
    init1();
    super.initState();
    //sharedprefs();
    print("cat id is" + widget.catid);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  Widget buildAlbum(
    Categorymusicmodel music,
  ) =>
      Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
          child: Container(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 300),
                  pageBuilder: (ctx, animation, secondaryAnimation) =>
                      categoryplayer(
                    allSong: allMusic,
                    music: music,
                    cid: widget.catid,
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
                ));
              },
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                //  mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              // ignore: prefer_interpolation_to_compose_strings
                              "https://admin.koinoniaconnect.org/" +
                                  music.musicImage,
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            )),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Text(
                            music.musicTitle,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign
                                .center, // optional, to center the text
                          ),
                        ),
                        Text(
                          music.artists![0].artistName,
                          // music.musicTitle,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFFA7A7A7),
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                  ),
                        )
                      ]),
                ],
              ),
            ),
          ));

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
            onPressed: () => Navigator.of(context).pop()),
        title: Align(
          alignment: AlignmentDirectional(-0.2, 0),
          child: Text(
            widget.catname,
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
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.builder(
                itemCount: allMusic.length,
                itemBuilder: (context, index) {
                  final Musics = allMusic[index];

                  //final Artists = artistinfo[index];

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
