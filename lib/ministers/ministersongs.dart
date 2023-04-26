import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:koinonia/model/musics.dart';

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

import '../flutter_flow/flutter_flow_widgets.dart';
import '../model/albummusicmode.dart';
import '../model/ministermusicmodel.dart';
import '../playing/playercheck/ministermusicplayer.dart';
import '../playing/playercheck/musicplayer.dart';
import '../src/helpers/app_colors.dart';

class ministermusic extends StatefulWidget {
  late final String artistid;
  final String artstimage;
  final String artistname;
  final String userid;

  ministermusic(this.artistid, this.artistname, this.artstimage, this.userid);
  @override
  _PlaylistWidgetState createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<ministermusic> {
  List<Ministermusicmodel> allSongs = [];
  List<Ministermusicmodel> song = [];

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
      playlistid = widget.artistid;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  getallalbumsongs(String albumuid) async {
    //print("HElloworld");

    final url = Uri.parse('https://admin.koinoniaconnect.org/API/viewArtist');
    final response = await http.post(url, body: {
      'user_id': '1',
      'artist_id': widget.artistid,
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      final data = jsonResponse['music_list'];

      setState(() {
        fetching = false;
        allSongs = List<Ministermusicmodel>.from(
            data.map((json) => Ministermusicmodel.fromJson(json)));
      });

      //artistinfo.map((json) => Artists.fromJson(json)).toList();
    }
    //throw Exception();
  }

  Future init1() async {
    await getallalbumsongs(widget.artistid);
    // setState(() => this.song = song);
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

  Widget buildplaylistsongs(Ministermusicmodel songs, id) => Container(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (ctx, animation, secondaryAnimation) =>
                    ministermusicplayer(
                  allSongs: allSongs,
                  music: songs,
                  userid: id,
                  mid: widget.artistid,
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
          child: Row(
            //mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  20,
                  0,
                  10,
                  10,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(
                    // ignore: prefer_interpolation_to_compose_strings
                    "https://admin.koinoniaconnect.org/" + songs.musicImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    songs.musicTitle.split(" ").length > 4
                        ? songs.musicTitle.split(" ").take(6).join(" ") + ".."
                        : songs.musicTitle,
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: songs.musicTitle.split(" ").length > 3 ? 2 : 1,

                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center, // optional, to center the text
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return

        //alignment: AlignmentDirectional(0.18, 0.67),
        fetching
            ? SpinKitWave(
                color: AppColors.DARK_ORANGE,
                size: 50.0,
              )
            : allSongs.length == 0
                ? Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Text(
                      'Sorry, There is no track available for this Singer!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFF15C00),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: allSongs.length,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final Playlistsongs = allSongs[index];

                      return buildplaylistsongs(Playlistsongs, widget.userid);
                    },
                    //gridDelegate:
                    //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  );
  }
}
