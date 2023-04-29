import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:koinonia/model/notifications.dart';
import 'package:koinonia/payment/choosePlanScreen.dart';
import 'package:koinonia/setting/aboutus.dart';
import 'package:koinonia/setting/termsandprivacy.dart';
import 'package:koinonia/sign_in/sign_in_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Api/Networkutils.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../model/musics.dart';
import '../model/profilemodel.dart';
import '../playing/playing_widget.dart';
import '../profile/editprofile_widget.dart';
import '../profile/profile_widget.dart';
import '../src/helpers/app_colors.dart';
import 'setting_model.dart';
export 'setting_model.dart';
import 'package:http/http.dart' as http;

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

class SettingWidget extends StatefulWidget {
  final String userid;
  SettingWidget({Key? key, required this.userid}) : super(key: key);

  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  late SettingModel _model;
  late String username;
  String userid = "";
  late String profilepic;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  late bool isDarkMode;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Profilemodel> pinfo = [];
  List<Profilemodel> pinfo2 = [];
  bool fetching = true;
    late Networkutils networkutils;

  @override
  void initState() {
    super.initState();
    username = "";
    isDarkMode = false;
    profilepic = "";
    sharedprefs();
    getprofileinfo(widget.userid);
    print("profile pic link is " + userid);
    _model = createModel(context, () => SettingModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  getprofileinfo(String userid) async {
    final url =
        Uri.parse('https://admin.koinoniaconnect.org/API/viewprofileinfo');
    final response = await http.post(url, body: {'user_id': userid});
    if (response.statusCode == 200) {
      final List pinfo = json.decode(response.body);
      var jsonResponse = json.decode(response.body);

      final data = jsonResponse[0];

      setState(() {
        fetching = false;
        pinfo2 = pinfo.map((json) => Profilemodel.fromJson(json)).toList();
      });
      //return
    }
  }
  void checkdownloadallowed() async {
    await networkutils.downloads(widget.userid);
    setState(() {});
    if (Networkutils.download == 1) {
      print("premium user");
    } else {
      print("free user");
    }
  }
  Future<void> sharedprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('firstname')!;
      userid = prefs.getString("userid")!;
      profilepic = prefs.getString("profilepic")!;
    });
    print("current_user_id is " + userid);
  }

  clearprefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  void onPressedFunction(BuildContext context) {
    ThemeMode mode = Theme.of(context).brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
    // Use the mode object to access the current theme mode.
    // Set the new theme mode using the Provider package.
    Provider.of<ThemeNotifier>(context, listen: false).setThemeMode(mode);
    print("Dark mode");
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return WillPopScope(
      onWillPop: () {
        print(
            'Backbutton pressed (device or appbar button), do whatever you want.');
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (ctx, animation, secondaryAnimation) =>
                NavBarPage(initialPage: 'HomePage', userid: userid),
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
        //trigger leaving and use own data

        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).customColor4),
          automaticallyImplyLeading: true,
          title: Align(
            alignment: AlignmentDirectional(-0.2, 0),
            child: Text(
              'Settings',
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
        body: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          child: fetching
              ? SpinKitWave(
                  color: AppColors.DARK_ORANGE,
                  size: 50.0,
                )
              : pinfo2.length == 0
                  ? Text("No user found")
                  : Scaffold(
                      backgroundColor: Colors.white,
                      body: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? EdgeInsetsDirectional.fromSTEB(
                                                  5, 5, 0, 0)
                                              : EdgeInsetsDirectional.fromSTEB(
                                                  10, 5, 0, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 60,
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                ),
                                                child: Stack(
                                                  clipBehavior: Clip.hardEdge,
                                                  children: [
                                                    ClipOval(
                                                      child: Image.network(
                                                        "https://admin.koinoniaconnect.org/" +
                                                            '${pinfo2[0].userProfilePic}',
                                                        fit: BoxFit.scaleDown,
                                                        width: 100,
                                                        height: 60,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object
                                                                    exception,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          // Show fallback image when an error occurs
                                                          return Image.asset(
                                                              'assets/images/defaultprofile.png');
                                                        },
                                                      ),
                                                    ),
                                                    // Optional: Show a loading indicator while the image is loading
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0, 0.1),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(10, 0, 0, 0),
                                                  child: Text(
                                                    ' ${pinfo2[0].firstname}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .title1
                                                        .override(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-0.65, 0.20),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            15, 0, 0, 0),
                                        child: (widget.userid == '3')
                                            ? Container() // if userid is 3, return an empty container to hide the button
                                            : FFButtonWidget(
                                                onPressed: () => {
                                                  print(
                                                      "on editprofile the userid is" +
                                                          userid),
                                                  if (userid == '3')
                                                    {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Please Login"),
                                                            content: Text(
                                                                "You cannot edit the guest account's profile."),
                                                            actions: <Widget>[
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xFFF15C00),
                                                                ),
                                                                child:
                                                                    Text("OK"),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    }
                                                  else
                                                    {
                                                      Navigator.of(context)
                                                          .push(
                                                        PageRouteBuilder(
                                                          transitionDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      300),
                                                          pageBuilder: (ctx,
                                                                  animation,
                                                                  secondaryAnimation) =>
                                                              EditProfileWidget(
                                                                  userid:
                                                                      userid),
                                                          transitionsBuilder:
                                                              (context,
                                                                  animation,
                                                                  secondaryAnimation,
                                                                  child) {
                                                            return SlideTransition(
                                                              position:
                                                                  new Tween<
                                                                      Offset>(
                                                                begin:
                                                                    const Offset(
                                                                        1.0,
                                                                        0.0),
                                                                end:
                                                                    Offset.zero,
                                                              ).animate(
                                                                      animation),
                                                              child:
                                                                  SlideTransition(
                                                                position: Tween<
                                                                    Offset>(
                                                                  begin: Offset
                                                                      .zero,
                                                                  end:
                                                                      const Offset(
                                                                          1.0,
                                                                          0.0),
                                                                ).animate(
                                                                    secondaryAnimation),
                                                                child: child,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    },
                                                },
                                                text: 'Edit Profile',
                                                icon: Icon(
                                                  Icons.edit,
                                                  size: 10,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 110,
                                                  height: 30,
                                                  color: Color(0xFFF15C00),
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .subtitle2
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          GestureDetector(
                            onTap: () => {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 300),
                                  pageBuilder:
                                      (ctx, animation, secondaryAnimation) =>
                                          ChoosePlanScreen(
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
                            child: Networkutils.download == 1 ?Container(): Container(
                              child: FractionallySizedBox(
                                widthFactor: 1.08,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width > 600
                                          ? 400
                                          : 200,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: MediaQuery.of(context).size.width >
                                                600
                                            ? BoxFit.cover
                                            : BoxFit.cover,
                                        image: Image.asset(
                                          'assets/images/Premium Subscription.png',
                                          //height: 200,
                                        ).image,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(2, 0, 2, 2),
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    GestureDetector(
                                      onTap: () => {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 300),
                                            pageBuilder: (ctx, animation,
                                                    secondaryAnimation) =>
                                                ProfileWidget(userid: userid),
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
                                        ),
                                      },
                                      child: (widget.userid == '3')
                                          ? Container() // if userid is 3, return an empty container to hide the button
                                          : Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.98,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(11,
                                                                      0, 0, 0),
                                                          child: Icon(
                                                            Icons
                                                                .person_outline,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .customColor4,
                                                            size: 24,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(24, 0,
                                                                    0, 0),
                                                        child: Text(
                                                          'Profile',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Urbanist',
                                                              ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.9, 0),
                                                          child: Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color: Colors.black,
                                                            size: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                    /*
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 1, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.98,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(11, 0, 0, 0),
                                                child: Icon(
                                                  Icons.notifications_none,
                                                  color: Colors.black,
                                                  size: 24,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => {
                                                  Navigator.of(context).push(
                                                    PageRouteBuilder(
                                                      transitionDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  300),
                                                      pageBuilder: (ctx,
                                                              animation,
                                                              secondaryAnimation) =>
                                                          notification(),
                                                      transitionsBuilder:
                                                          (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) {
                                                        return SlideTransition(
                                                          position:
                                                              new Tween<Offset>(
                                                            begin: const Offset(
                                                                1.0, 0.0),
                                                            end: Offset.zero,
                                                          ).animate(animation),
                                                          child:
                                                              SlideTransition(
                                                            position: Tween<
                                                                Offset>(
                                                              begin:
                                                                  Offset.zero,
                                                              end: const Offset(
                                                                  1.0, 0.0),
                                                            ).animate(
                                                                secondaryAnimation),
                                                            child: child,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                },
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(24, 0, 0, 0),
                                                  child: Text(
                                                    'Notifications',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily:
                                                              'Urbanist',
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.9, 0),
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.black,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  */
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 1, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              {
                                                const url =
                                                    'https://www.koinoniaconnect.com/terms';
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              }
                                              ;
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.98,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                shape: BoxShape.rectangle,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                11, 0, 0, 0),
                                                    child: Icon(
                                                      Icons.verified_user,
                                                      color: Colors.black,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                24, 0, 0, 0),
                                                    child: Text(
                                                      'Terms and Privacy',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyText1
                                                          .override(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'Urbanist',
                                                          ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.9, 0),
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 1, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.98,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(11, 0, 0, 0),
                                                  child: Icon(
                                                    Icons.star_outline_sharp,
                                                    color: Colors.black,
                                                    size: 24,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(24, 0, 0, 0),
                                                  child: Text(
                                                    'Rate  us',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText1
                                                        .override(
                                                          fontFamily:
                                                              'Urbanist',
                                                        ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.9, 0),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.black,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 1, 0, 0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          const url =
                                              'https://www.koinoniaconnect.com/about';
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.98,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                shape: BoxShape.rectangle,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                11, 0, 0, 0),
                                                    child: Icon(
                                                      Icons.error_outline,
                                                      color: Colors.black,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                24, 0, 0, 0),
                                                    child: Text(
                                                      'About us',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Urbanist',
                                                              ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.9, 0),
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    /*
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 1, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.98,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(11, 0, 0, 0),
                                                child: FaIcon(
                                                  FontAwesomeIcons.language,
                                                  color: Colors.black,
                                                  size: 24,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(24, 0, 0, 0),
                                                child: Text(
                                                  'Language',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Urbanist',
                                                      ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.9, 0),
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.black,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  */
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [],
                                      ),
                                    ),
                                    FFButtonWidget(
                                      onPressed: () => {
                                        clearprefs(),
                                        _googleSignIn.disconnect(),
                                        FacebookAuth.i.logOut(),
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 300),
                                            pageBuilder: (ctx, animation,
                                                    secondaryAnimation) =>
                                                SignInWidget(),
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
                                        ),
                                      },
                                      text: widget.userid == '3'
                                          ? 'Log In'
                                          : 'Log Out',
                                      options: FFButtonOptions(
                                        width: 90,
                                        height: 40,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyText2
                                            .override(
                                              fontFamily: 'Lexend Deca',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                        elevation: 3,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
