import 'package:flutter/services.dart';
import 'package:koinonia/index.dart';
import 'package:koinonia/likedsongs.dart';
import 'package:koinonia/Api/Networkutils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:koinonia/src/widgets/custom_app_bar.dart';
import '../flutter_flow/flutter_flow_ad_banner.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../ministers/allministerwidget.dart';
import '../model/notifications.dart';
import '../model/viewAlbum.dart';
import '../payment/choosePlanScreen.dart';
import '../playing/newplayer.dart';
import '../playlist/getallplaylist_widget.dart';
import 'home_page_allcategory.dart';
import 'homepage_ministers.dart';
import 'homepage_categorywidget.dart';
import '../albums/albums_widget.dart';
import 'homepage_playlistwidget.dart';
import 'homepage_quickplay_widget.dart';
import 'homepage_recentlyadded_widget.dart';
import 'homepagealbumwidget.dart';
import 'home_page_model.dart';
import 'homepageallmusic.dart';
export 'home_page_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<getmsg> featuredmessage() async {
  final response = await http.get(
      Uri.parse('https://admin.koinoniaconnect.org/API/getfeaturedmessage'));

  // Appropriate action depending upon the
  // server response
  if (response.statusCode == 200) {
    return getmsg.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load featuredmessage');
  }
}

class getmsg {
  late String message;
  late String notification;

  getmsg({required this.message});
  getmsg.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    notification = json['notification'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['notifciation'] = this.notification;
    return data;
  }
}

class HomePageWidget extends StatefulWidget {
  final String userid;
  HomePageWidget({Key? key, required this.userid}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;
  String messag = "";
  late String userid;
  late Future<getmsg> futureAlbum;
  late SharedPreferences _prefs;

  List albumimage = [];
  List<Albummodel> music = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List<String> images = [
    ("assets/images/c1.png"),
    ("assets/images/c2.png"),
    ("assets/images/c3.png"),
    ("assets/images/c4.png"),
  ];

  final animationsMap = {
    'containerOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 1.ms),
        FadeEffect(
          curve: Curves.linear,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.linear,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(100, 0),
          end: Offset(0, 0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    userid = "";
    // sharedprefs();
    super.initState();
    _model = createModel(context, () => HomePageModel());
    //getmsg();
    futureAlbum = featuredmessage();

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
    print("in home the user id is " + widget.userid);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  Future sharedprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString("userid")!;
    print("basdasdasda" + user);
    setState(() {
      this.userid = user;
    });
    print("current_user_id is " + userid);
  }

  Widget buildAlbum(
    Albummodel music,
  ) =>
      Container(
        child: GestureDetector(
          onTap: () {
            /*  
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MinistersWidget(
                  album.albumId,
                  album.albumName,
                  album.albumImage,
                  '',
                  album.isLiked,
                  "Album",
                ),
              ),
            );*/
          },
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(0.15, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    // ignore: prefer_interpolation_to_compose_strings
                    "https://admin.koinoniaconnect.org/" + music.albumImage,
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
                        music.albumartistname,
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                      )),
                ),
              ),
              Container(
                  child: Text(
                music.albumName,
                style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Inter',
                      color: Color(0xFFA7A7A7),
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
              ))
            ],
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show alert dialog and wait for user response
        final shouldExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Close Koinonia?'),
            content: Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Color(0xFFF15C00),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF15C00),
                ),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    // If there are routes left to pop, pop the top route
                    SystemNavigator.pop(); // Close the app
                  } else {
                    // If there are no routes left to pop, close the app
                    // Close the app
                    SystemNavigator.pop();
                  }
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
        // If user confirms, exit the app
        return shouldExit ?? false;
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Home',
          elevation: 2, userid: widget.userid,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: FlutterFlowAdBanner(
                    width: MediaQuery.of(context).size.width,
                    height: 69,
                    userid: widget.userid,
                  ),
                ),
                /* // feature title
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-0.1, 0.1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 15, 0, 0),
                        child: Text(
                          'Featured Message',
                          textAlign: TextAlign.end,
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Urbanist',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),

                // concert box image
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 9, 10, 0),
                  child: Container(
                    //child: Center(child: Text('test'),),
                    width: MediaQuery.of(context).size.width,
                    height: 227,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: FutureBuilder<getmsg>(
                            future: futureAlbum,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!.message,
                                  style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              return Text("loading...");
                            },
                          ),
                        ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 100, 20, 0),
                                child: FFButtonWidget(
                                  onPressed: () {
                                    print('Button pressed ...');
                                  },
                                  text: 'Concert',
                                  options: FFButtonOptions(
                                    width: 100,
                                    color: Color(0xFFF15C00),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .subtitle2
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
*/
                // Our product row
                /*       Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                          child: Text(
                            'Our Products',
                            textAlign: TextAlign.end,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      //color: Colors.black,
                                      fontFamily: 'Urbanist',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                              child: TextButton(
                                onPressed: () => {},
                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFFF15C00),
                                  //disabledForegroundColor : Colors.grey, // Disable color
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),

                // Our product list
                GestureDetector(
                  onTap: () => {}, //when user taps on our prodcts
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.99,
                    height: 80,
                    decoration: BoxDecoration(
                        color:
                            FlutterFlowTheme.of(context).secondaryBackground),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Stack(
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(
                            'assets/images/buy.png',
                          )
                        ],
                      ),
                    ),
                  ),
                ),
*/
                // recently added titles row
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // recently added text
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                          child: Text(
                            'Recently Added',
                            textAlign: TextAlign.end,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Urbanist',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),

                      // recently added see all
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                              child: TextButton(
                                onPressed: () => {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 300),
                                      pageBuilder: (ctx, animation,
                                              secondaryAnimation) =>
                                          hompageallmusic(
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
                                  ),
                                },
                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFFF15C00),
                                  //disabledForegroundColor : Colors.grey, // Disable color
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),

                // recently added music list
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.99,
                    height: 120,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: homepagerecentlyadded(userid: widget.userid),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // minister title row
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                          child: Text(
                            'Ministers',
                            textAlign: TextAlign.end,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Urbanist',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),

                      // minister see all text
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                              child: TextButton(
                                onPressed: () => {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 300),
                                      pageBuilder: (ctx, animation,
                                              secondaryAnimation) =>
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
                                  ),
                                },
                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFFF15C00),
                                  //disabledForegroundColor : Colors.grey, // Disable color
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),

                // minister music list
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 140,
                    decoration: BoxDecoration(
                        color:
                            FlutterFlowTheme.of(context).secondaryBackground),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child:
                                homepageministerwidget(userid: widget.userid),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Quick play titles row

                // quick play music list

                // ALbum titles
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 1, 0, 0),
                          child: Text(
                            'Albums',
                            textAlign: TextAlign.end,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Urbanist',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                              child: TextButton(
                                onPressed: () => {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 300),
                                      pageBuilder: (ctx, animation,
                                              secondaryAnimation) =>
                                          AlbumsWidget(userid: widget.userid),
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
                                  ),
                                },
                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFFF15C00),
                                  //disabledForegroundColor : Colors.grey, // Disable color
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                // album music list
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width > 600
                      ? 180
                      : MediaQuery.of(context).size.height * 0.23,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          //  onTap: () => context.go('/albums'),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.20,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  child: homepagealbumwidget(
                                      userid: widget.userid),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                widget.userid == "3"
                    ? Container()
                    :
                    //playlist titles
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                child: Text(
                                  'Playlists',
                                  textAlign: TextAlign.end,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Urbanist',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 20, 0),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 300),
                                            pageBuilder: (ctx, animation,
                                                    secondaryAnimation) =>
                                                getallPlaylistWidget(
                                                    userid: widget.userid),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
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
                                      child: Text(
                                        'See all',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Color(0xFFF15C00),
                                        //disabledForegroundColor : Colors.grey, // Disable color
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),

                widget.userid == "3"
                    ? SizedBox.shrink()
                    :
                    //play list music
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.20,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                        child: homepageplaylistwidget(
                                            userid: widget.userid),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                // categories titles
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                          child: Text(
                            'Categories',
                            textAlign: TextAlign.end,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Urbanist',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 300),
                                      pageBuilder: (ctx, animation,
                                              secondaryAnimation) =>
                                          homepageallcategorywidget(),
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
                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFFF15C00),
                                  //disabledForegroundColor : Colors.grey, // Disable color
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),

                // categories music lists
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 130,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Row(children: [
                      Expanded(
                        child: homepagecategorywidget(),
                      )
                    ]),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: FlutterFlowAdBanner(
                    width: MediaQuery.of(context).size.width,
                    height: 69,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
