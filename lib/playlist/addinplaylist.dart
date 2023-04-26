import 'dart:convert';

import 'package:koinonia/index.dart';
import 'package:koinonia/likedsongs.dart';
import 'package:koinonia/playlist/playlist_widget.dart';
import '../Api/Networkutils.dart';
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
import '../src/helpers/utils.dart';

class addinplaylist extends StatefulWidget {
  late final String playlistid;
  late final String userid;
  addinplaylist(this.playlistid, this.userid);

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

class _homepagealbumwidgetState extends State<addinplaylist> {
  List<Musics> music = [];
  List<Artists> artistinfo = [];
  List allalbumimage = [];
  List allMusicsinfo = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List AllArtistsinfo = [];
  late Networkutils networkutils;
  late String userid;

  Future init1() async {
    final music = await getAllMusicsApi.getallalbums();

    setState(() {
      this.music = music;
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
    networkutils = Networkutils();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  Future<void> addPlaylistMusic(
      String userid, String playlistid, String musicid) async {
    await networkutils.addMusicinPlaylist(userid, playlistid, musicid);
    // GetAllPlaylistSongsAPI.getallplaylistsongs(userid, playlistid);
    Utils.singlePlaylistRefreshIndicatorKey.currentState?.show();
    // init1();
    // setState(() {});
  }

  Future showExitPopup(BuildContext context, id) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add song'),
          content: Text('This song will be added to your playlist!'),
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
                await addPlaylistMusic(widget.userid, widget.playlistid, id);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Color(0xFFF15C00),
                    content: Text('Track added!'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildAlbum(
    Musics music,
  ) =>
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
        child: Container(
          child: InkWell(
            onTap: () async {
              await showExitPopup(
                context,
                music.musicId,
              );
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
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        iconTheme:
            IconThemeData(color: FlutterFlowTheme.of(context).customColor4),
        automaticallyImplyLeading: true,
        title: Align(
          alignment: AlignmentDirectional(-0.20, 0),
          child: Text(
            'Musics',
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
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
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
