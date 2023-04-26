import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../Api/Networkutils.dart';
import '../flutter_flow/flutter_flow_ad_banner.dart';
import '../flutter_flow/flutter_flow_audio_player.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../ministers/allministerwidget.dart';
import '../ministers/ministers_widget.dart';
import '../model/viewArtist.dart';
import 'following_model.dart';
export 'following_model.dart';
import 'package:http/http.dart' as http;

class FollowingWidget extends StatefulWidget {
  String userid;
  FollowingWidget({Key? key, required this.userid}) : super(key: key);

  @override
  _FollowingWidgetState createState() => _FollowingWidgetState();
}

class getuserfollowedartist {
  static Future<List<ViewArtistItem>> userfollowedartists(String userid) async {
    final url = Uri.parse(
        'https://admin.koinoniaconnect.org/API/getuserfollowedartist');
    final response = await http.post(url, body: {
      'user_id': userid,
    });

    if (response.statusCode == 200) {
      final List followedartist = json.decode(response.body);

      return followedartist
          .map((json) => ViewArtistItem.fromJson(json))
          .toList();
    }
    throw Exception();
  }
}

class _FollowingWidgetState extends State<FollowingWidget> {
  late FollowingModel _model;
  List artist = [];
  String userid = ' ';
  late Networkutils networkutils;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init1();
    sharedprefs();
    networkutils = Networkutils();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<void> sharedprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid")!;
    });
    print("current_user_id is " + userid);
  }

  Future showExitPopup(BuildContext context, id) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text('Unfollow  minister?'),
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
                await unfollow(id);
                Navigator.of(context).pop();

                SnackBar(
                  backgroundColor: Color(0xFFF15C00),
                  content: Text('Track Removed!'),
                );
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> unfollow(String id) async {
    await networkutils.unfollowminister(widget.userid, id);
    setState(() {});
  }

  @override
  void dispose() {
    //_model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  Future init1() async {
    final artist =
        await getuserfollowedartist.userfollowedartists(widget.userid);
    setState(() => this.artist = artist);
    print("hello world");
  }

  Widget buildfollowing(ViewArtistItem followingartist) => Container(
        child: GestureDetector(
          onLongPress: () async {
            await showExitPopup(context, followingartist.artistId);
          },
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (ctx, animation, secondaryAnimation) =>
                    MinistersWidget(
                        followingartist.artistId,
                        followingartist.artistName,
                        followingartist.artistImage,
                        userid),
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
                padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(
                    // ignore: prefer_interpolation_to_compose_strings
                    "https://admin.koinoniaconnect.org/" +
                        followingartist.artistImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Text(
                            followingartist.artistName,
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
                          followingartist.artistCategory,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
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
          alignment: AlignmentDirectional(-0.3, 0),
          child: Text(
            'Following ',
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
        centerTitle: false,
        elevation: 2,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0x23FFFFFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                        child: TextFormField(
                          //controller: _model.textController,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.textController',
                            Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Search a song, singer or albums',
                            hintStyle: TextStyle(
                                color: Color(0x80707070),
                                fontFamily: "Urbanist",
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(
                              Icons.search,
                              color: Color(0xFFF15C00),
                              size: 25,
                            ),
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Urbanist',
                                    color: Color(0xFF707070),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                          // validator: _model.textControllerValidator
                          // .asValidator(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.95, 0.49),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 5, 0, 4),
                    child: FFButtonWidget(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 300),
                            pageBuilder: (ctx, animation, secondaryAnimation) =>
                                allministerwidget(
                              userid: widget.userid,
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
                      },
                      text: 'Ministers',
                      options: FFButtonOptions(
                        width: 90,
                        height: 55,
                        color: Color(0xFFF15C00),
                        textStyle:
                            FlutterFlowTheme.of(context).subtitle2.override(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
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
                       
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: artist.length,
                itemBuilder: (context, index) {
                  final followingartists = artist[index];

                  return buildfollowing(followingartists);
                },
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // crossAxisCount: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
