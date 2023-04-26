import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:koinonia/model/musics.dart';
import 'package:koinonia/src/widgets/custom_app_bar.dart';

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

import '../model/albummusicmode.dart';
import '../playing/playercheck/albumplayer.dart';
import '../playing/playercheck/musicplayer.dart';
import '../src/helpers/app_colors.dart';

class albummusic extends StatefulWidget {
  late final String albumid;
  String userid;
  albummusic(this.albumid, this.userid);
  @override
  _PlaylistWidgetState createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<albummusic> {
  List<Albummusicmodel> allSongs = [];
  String playlistid = "";
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late Networkutils networkutils;
  bool fetching = true;
  @override
  void initState() {
    super.initState();
    networkutils = Networkutils();

    init1();
    setState(() {
      playlistid = widget.albumid;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  getallalbumsongs(String albumuid) async {
    //print("HElloworld");

    final url = Uri.parse('https://admin.koinoniaconnect.org/API/viewAlbum');
    final response = await http.post(url, body: {
      'user_id': '1',
      'album_id': albumuid,
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      final data = jsonResponse['music_list'];

      setState(() {
        fetching = false;
        allSongs = List<Albummusicmodel>.from(
            data.map((json) => Albummusicmodel.fromJson(json)));
      });

      //artistinfo.map((json) => Artists.fromJson(json)).toList();
    }
    // throw Exception();
  }

  Future init1() async {
    await getallalbumsongs(widget.albumid);
    //setState(() => this.songs = playlistsongs);
    // setState(() {
    //   this.artistinfo = artistinfo;
    //});
    print("hello world");
    //model = createModel(context, () => AlbumsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    //_model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  Widget buildplaylistsongs(Albummusicmodel songs, id) => Container(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (ctx, animation, secondaryAnimation) =>
                    albumplayer(
                  allSongs: allSongs,
                  music: songs,
                  userid: id,
                  aid: widget.albumid,
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
                    "https://admin.koinoniaconnect.org/" + songs.musicImage,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    songs.musicTitle,
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center, // optional, to center the text
                  )),
              Text(
                songs.artists!.isEmpty
                    ? ""
                    : songs.artists![0].artistName ?? "",
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Album Tracks",
        elevation: 2, userid: widget.userid,
      ),
      body: fetching
          ? SpinKitRotatingCircle(
              color: AppColors.DARK_ORANGE,
              size: 50.0,
            )
          : allSongs.length == 0
              ? Center(
                  child: Text(
                    'Album\'s Empty',
                    style: TextStyle(
                      fontSize: 15,
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GridView.builder(
                    itemCount: allSongs.length,
                    itemBuilder: (context, index) {
                      final Playlistsongs = allSongs[index];

                      return buildplaylistsongs(Playlistsongs, widget.userid);
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                  ),
                ),
    );
  }
}
