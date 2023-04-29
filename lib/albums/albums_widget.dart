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
import 'albums_model.dart';
export 'albums_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'albumsmusic.dart';

class AlbumsWidget extends StatefulWidget {
  final String userid;
  const AlbumsWidget({Key? key, required this.userid}) : super(key: key);

  @override
  _AlbumsWidgetState createState() => _AlbumsWidgetState();
}

class getAllMusicsApi {
  static Future<List<Albummodel>> getallalbums() async {
    print("HElloworld");

    final url = Uri.parse('https://admin.koinoniaconnect.org/API/getAllAlbums');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List music = json.decode(response.body);
      final List artistinfo = json.decode(response.body);

      return music.map((json) => Albummodel.fromJson(json)).toList();
      //artistinfo.map((json) => Artists.fromJson(json)).toList();
    }
    throw Exception();
  }
}

class _AlbumsWidgetState extends State<AlbumsWidget> {
  List<Albummodel> music = [];
  List<Artists> artistinfo = [];
  List allalbumimage = [];
  List allMusicsinfo = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List AllArtistsinfo = [];
  // FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future init1() async {
    final music = await getAllMusicsApi.getallalbums();
    setState(() => this.music = music);
    setState(() {
      this.artistinfo = artistinfo;
    });
    print("hello world");
    //  _model = createModel(context, () => AlbumsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void initState() {
    init1();
    super.initState();
    //  _logScreenView();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<void> _logScreenView() async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'screen_view',
      parameters: {
        'firebase_screen': "AlbumsWidget",
        'firebase_screen_class': "_AlbumsWidgetState",
      },
    );
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  Widget buildAlbum(
    Albummodel music,
  ) =>
      Container(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (ctx, animation, secondaryAnimation) =>
                    albummusic(music.albumId, widget.userid),
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
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      // ignore: prefer_interpolation_to_compose_strings
                      "https://admin.koinoniaconnect.org/" + music.albumImage,
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                    child: Text(
                      music.albumartistname,
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  Text(
                    music.albumName,
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Inter',
                          color: Color(0xFFA7A7A7),
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ],
              ),
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
            'Albums',
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
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                new Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: FlutterFlowAdBanner(
                      width: MediaQuery.of(context).size.width,
                      height: 69,
                      userid: widget.userid,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.builder(
                itemCount: music.length,
                itemBuilder: (context, index) {
                  final Musics = music[index];

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
