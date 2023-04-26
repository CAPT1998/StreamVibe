import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:koinonia/playlist/playlist_widget.dart';
import 'package:image_picker/image_picker.dart';
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

import '../src/helpers/utils.dart';

class homepageplaylistwidget extends StatefulWidget {
  String userid;
  homepageplaylistwidget({Key? key, required this.userid}) : super(key: key);

  @override
  _PlaylistWidgetState createState() => _PlaylistWidgetState();
}

class getAllplaylistsAPI {
  static Future<List<Getplaylistmodel>> getallplaylist(String userid) async {
    //print("HElloworld");

    final url = Uri.parse('https://admin.koinoniaconnect.org/API/getPlaylists');
    final response = await http.post(url, body: {
      'user_id': userid,
    });

    if (response.statusCode == 200) {
      final List playlist = json.decode(response.body);
      final List artistinfo = json.decode(response.body);

      return playlist.map((json) => Getplaylistmodel.fromJson(json)).toList();
      //artistinfo.map((json) => Artists.fromJson(json)).toList();
    }
    throw Exception();
  }
}

class _PlaylistWidgetState extends State<homepageplaylistwidget> {
  List<Getplaylistmodel> playlist = [];
  final textcontroller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late Networkutils networkutils;
  late XFile pickedImage;
    bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
   // sharedprefs();

    init1();
    networkutils = Networkutils();

 WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoaded = true;
      });
    });  
    
    }



  init1() async {
    print("before getplaylistall the userid is " + widget.userid);
    final playlist = await getAllplaylistsAPI.getallplaylist(widget.userid);
    if (!mounted) return;

    setState(() => this.playlist = playlist);
  }

  @override
  void dispose() {
    //_model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  Widget buildAlbum(Getplaylistmodel playlist) => Container(
        child: InkWell(
          onTap: () {

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlaylistWidget(
                  playlist.imagesslist,
                  playlist.userPlaylistName,
                  playlist.userPlaylistId,
                  widget.userid,
                ),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://admin.koinoniaconnect.org/uploads/movie/" +
                            playlist.userPlaylistImage,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Text(
                        playlist.userPlaylistName,
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Urbanist',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                      )),
                ],
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body:_isLoaded

       ?RefreshIndicator(
        key: Utils.homepagePlaylistRefreshIndicatorKey,

        color:  Colors.black12.withOpacity(0.0),
        backgroundColor: Colors.black12.withOpacity(0.0),
        strokeWidth: 0,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        edgeOffset: 0,
        notificationPredicate: (_){return false;},
        displacement: 0,
        onRefresh: () {
          // Replace this delay with the code to be executed during refresh
          // and return a Future when code finishs execution.
          // return Future<void>.delayed(const Duration(seconds: 3));
          return init1();
        },
         child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: playlist.length,
                  itemBuilder: (context, index) {
                    final playlist1 = playlist[index];

                    return buildAlbum(playlist1);
                  },
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //crossAxisCount: 2),
                ),
              ),
            ],
          ),
      ),
       )
      :Container()
    );
  }
}
