import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../flutter_flow/flutter_flow_icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:koinonia/Api/Networkutils.dart';
import '../home_page/home_page_widget.dart';
import '../main.dart';
import '../model/users.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:koinonia/sign_up/sign_up_widget.dart';
import '../src/services/login_service.dart';
import 'forgot.dart';
import 'sign_in_model.dart';
export 'sign_in_model.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  //final GlobalKey<_SignUpWidgetState> _signupPageKey = SignUpWidget._key;

  late SignInModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  TextEditingController _passcontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  late SharedPreferences sharedPreferences;
  late List<Users> _data;
  String userid = "";
  late List<Result> _future;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => SignInModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    _passcontroller = TextEditingController();
    _emailcontroller = TextEditingController();

    _unfocusNode.dispose();
    super.dispose();
  }

  buildguestaccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userid", '3');

    setState(() {
      userid = prefs.getString("userid")!;
    });

    prefs.setString("profilepic", 'defaultprofile.png');
    prefs.setString("firstname", "Guest");
    prefs.setString("email", "guest@koinonia.com");
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> _signInWithGoogle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      final id = user!.uid;
      final name = user.displayName;
      final email = user.email;
      int uidHash = user!.uid.hashCode;
      BigInt uidBigInt = BigInt.from(uidHash.abs());
      final integersOnly = RegExp(r'\d+')
          .allMatches(id)
          .map((match) => int.parse(match.group(0)!))
          .join('');
      final pic = user.photoURL;
      prefs.setString("firstname", user.displayName!);
      prefs.setString("email", user.email!);
      prefs.setString("userid", integersOnly.toString());
      prefs.setString("profilepic", user.photoURL!);
      setState(() {
        userid = prefs.getString('userid')!;
      });

      await postSignuptwitter(
        integersOnly.toString(),
        prefs.getString('email'),
        "googlelogin",
        prefs.getString('firstname'),
        " ",
        prefs.getString('profilepic'),
      ).then((value) {
        print(prefs.getString('userid'));
        print(prefs.getString('email'));
        print(prefs.getString('firstname'));

        setState(() {
          _future = value!;
        });
      });

      prefs.setBool('isLoggedIn', true);
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (ctx, animation, secondaryAnimation) => NavBarPage(
            initialPage: 'HomePage',
            userid: userid,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
      if (kDebugMode) {
        print("Signed in as user:  ${user?.displayName}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while signing in with Google: $e");
      }
    }
  }

  Future twitterlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final twitterLogin = TwitterLogin(
      /// Consumer API keys
      apiKey: 'xIZZSQniByh7b9Zy8ZfCk8gP1',

      /// Consumer API Secret keys
      apiSecretKey: 'iTkUxLzvDn3BcU1MR0jijbbD8iyKJ7WpVhpF3hQI2DbumGAVFw',

      /// Registered Callback URLs in TwitterApp
      /// Android is a deeplink
      /// iOS is a URLScheme
      redirectURI: 'koinonia://',
    );

    /// Forces the user to enter their credentials
    /// to ensure the correct users account is authorized.
    /// If you want to implement Twitter account switching, set [force_login] to true
    /// login(forceLogin: true);
    final authResult = await twitterLogin.login();
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        //

        print('====== Login success ======');
        print(authResult.authToken);
        print(authResult.user!.id);
        print(authResult.user!.name);

        print(authResult.user!.screenName);
        print(authResult.user!.thumbnailImage);
        print(authResult.user!.email);
        prefs.setString("firstname", authResult.user!.name);
        prefs.setString("email", authResult.user!.email);
        prefs.setString("userid", authResult.user!.id.toString());
        prefs.setString("profilepic", authResult.user!.thumbnailImage);
        setState(() {
          userid = prefs.getString('userid')!;
        });
        await postSignuptwitter(
          prefs.getString('userid'),
          prefs.getString('email'),
          "twitterlogin",
          prefs.getString('firstname'),
          " ",
          prefs.getString('profilepic'),
        ).then((value) {
          // print(_model.textController4.text);
          print(_model.textController1.text);
          print(_model.textController2.text);

          setState(() {
            _future = value!;
          });
        });
        prefs.setBool('isLoggedIn', true);
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (ctx, animation, secondaryAnimation) => NavBarPage(
              initialPage: 'HomePage',
              userid: userid,
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
        break;
      case TwitterLoginStatus.cancelledByUser:
        // cancel
        print('====== Login cancel ======');
        break;
      case TwitterLoginStatus.error:
      case null:
        // error
        print('====== Login error ======');
        break;
    }
  }

  Future<List<Result>> postSignuptwitter(
    String? userid,
    String? email,
    String? pass,
    String? username, //this is firstname
    String? lastname,
    String? pic,
  ) async {
    final response = await http.post(
      Uri.parse("https://admin.koinoniaconnect.org/API/signupwithfacebook"),
      body: {
        'user_id': userid,
        'user_email': email,
        'user_password': pass,
        'firstname': username,
        'lastname': lastname,
        'user_profile_pic': pic,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final List music = json.decode(response.body);
      final List result = jsonDecode(response.body);

      return music.map((json) => Result.fromJson(json)).toList();
    }
    throw Exception();
  }

  onpress() async {
    if (_emailcontroller.text == "" && _passcontroller == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xFFF15C00),
          content: Text(
            'Please fill the required fields!',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Urbanist',
            ),
          )));
      return;
    }

    await Networkutils()
        .postlogin(
      _emailcontroller.text,
      _passcontroller.text,
    )
        .then((value) {
      setState(() {
        _data = value!;
      });
    });
    try {
      if (_data[0].userId == null) {
        print('object');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color(0xFFF15C00),
            content: Text(
              'check Your credetials!',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Urbanist',
              ),
            )));
        return;
      } else if (_data[0].status == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color(0xFFF15C00),
            content: Text(
              'Email not verified!',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Urbanist',
              ),
            )));
        return;
      }
    } on RangeError catch (_) {
      // Navigator.of(context).pop();
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xFFF15C00),
          content: Text(
            'Check Your credetials!',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Urbanist',
            ),
          )));
    }

    print("status is : " + _data[0].status);
    print(_data[0].userProfilePic);
    // MyData.myName = _data[0].userId;
    // MyData.myImage = _data[0].userProfilePic;
    print("object");
    print(_data[0].userId);
    // print(MyData.myImage);
    // await datasave();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("isfirst", false);
    setState(() {
      userid = prefs.getString('userid')!;
    });
    prefs.setString("userid", _data[0].userId);
    prefs.setString("profilepic", _data[0].userProfilePic);

    prefs.setString("email", _data[0].userEmail);
    prefs.setString("firstname", _data[0].firstname);
    prefs.setBool('isLoggedIn', true);

    print(prefs.getString('firstname'));
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (ctx, animation, secondaryAnimation) =>
            NavBarPage(initialPage: 'HomePage', userid: userid),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
  }

  facebookLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();
        print('facebook_login_data:-');
        print(userData);
        final id = userData['id'];
        final name = userData['name'];
        final email = userData['email'];

        final pic = userData['picture']['data']['url'];
        print('User ID: $id');
        prefs.setString("firstname", name);
        prefs.setString("email", email);
        prefs.setString("userid", id);
        prefs.setString("profilepic", pic);
        setState(() {
          userid = prefs.getString('userid')!;
        });
        await postSignupfacebook(
          prefs.getString('userid'),
          prefs.getString('email'),
          "fblogin",
          prefs.getString('firstname'),
          " ",
          prefs.getString('profilepic'),
        ).then((value) {
          //print(_model.textController4.text);
          print(_model.textController1.text);
          print(_model.textController2.text);

          setState(() {
            _future = value!;
          });
        });
        prefs.setBool('isLoggedIn', true);
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (ctx, animation, secondaryAnimation) => NavBarPage(
              initialPage: 'HomePage',
              userid: userid,
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
      }
    } catch (error) {
      print(error);
    }
  }

  Future<List<Result>> postSignupfacebook(
    String? userid,
    String? email,
    String? pass,
    String? username, //this is firstname
    String? lastname,
    String? pic,
  ) async {
    final response = await http.post(
      Uri.parse("https://admin.koinoniaconnect.org/API/signupwithfacebook"),
      body: {
        'user_id': userid,
        'user_email': email,
        'user_password': pass,
        'firstname': username,
        'lastname': lastname,
        'user_profile_pic': pic,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final List music = json.decode(response.body);
      final List result = jsonDecode(response.body);

      return music.map((json) => Result.fromJson(json)).toList();
    }
    throw Exception();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: Image.asset(
                    'assets/images/79696ac2eae0f3f18f77b6c86a9689a3_(1).png',
                  ).image,
                ),
              ),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                double width = constraints.maxWidth;
                double height = constraints.maxHeight;
                return Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor:
                          0.8, // set the width as 50% of the screen's width
                      child: Align(
                        alignment: AlignmentDirectional(-0.80, -0.8),
                        child: FFButtonWidget(
                          onPressed: () => {
                            buildguestaccount(),
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 300),
                                pageBuilder:
                                    (ctx, animation, secondaryAnimation) =>
                                        NavBarPage(
                                  initialPage: 'HomePage',
                                  userid: userid,
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Color(0xFFF15C00),
                                //elevation: 50,
                                duration: Duration(seconds: 1),
                                content: Text(
                                  'Logged in as Guest!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Urbanist',
                                  ),
                                ))),
                          },
                          text: 'Skip',
                          options: FFButtonOptions(
                            width: MediaQuery.of(context).size.width > 600
                                ? 60
                                : 50,
                            height: MediaQuery.of(context).size.width > 600
                                ? 30
                                : 24,
                            color: Color(0xFFF15C00),
                            textStyle:
                                FlutterFlowTheme.of(context).subtitle2.override(
                                      fontFamily: 'Urbanist',
                                      color: Colors.white,
                                      fontSize: 12,
                                      letterSpacing: 0.2,
                                      fontWeight: FontWeight.bold,
                                      //lineHeight: 1.6,
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
                    FractionallySizedBox(
                      widthFactor:
                          0.9, // set the width as 50% of the screen's width
                      child: Align(
                        alignment: MediaQuery.of(context).size.width > 600
                            ? AlignmentDirectional(-0.45, -0.8)
                            : AlignmentDirectional(-0.15, -0.8),
                        child: Text(
                          'get started immediately',
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Urbanist',
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                    // set the width as 50% of the screen's width
                    Align(
                      alignment: MediaQuery.of(context).size.width > 600
                          ? AlignmentDirectional(-0.87, -0.20)
                          : AlignmentDirectional(-0.93, -0.31),
                      child: IconButton(
                        icon: new Image.asset(
                          'assets/images/Koinonia connect Logo 1.png',
                          width: 60,
                        ),
                        iconSize: 50,
                        onPressed: () {},
                      ),
                    ),

                    Align(
                      alignment: MediaQuery.of(context).size.width > 600
                          ? AlignmentDirectional(-0.80, -0.07)
                          : AlignmentDirectional(-0.80, -0.1),
                      child: Text(
                        'The experience is better\n when you sign in.',
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Urbanist',
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.80, 0.06),
                      child: Text(
                        'Hello, Sign In To Continue',
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.92, 0.51),
                      child: Form(
                        key: _model.formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 0.38),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width > 600
                                    ? MediaQuery.of(context).size.width * 0.85
                                    : MediaQuery.of(context).size.width * 0.90,
                                child: TextFormField(
                                  controller: _passcontroller,
                                  autofocus: false,
                                  obscureText: true,
                                  scrollPadding: EdgeInsets.only(bottom: 40),
                                  textCapitalization: TextCapitalization.none,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Urbanist",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    filled: true,
                                    fillColor: Color(0x57FFFFFF),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Urbanist',
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  textAlign: TextAlign.justify,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _model.textController1Validator
                                      .asValidator(context),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 0.19),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width > 600
                                    ? MediaQuery.of(context).size.width * 0.85
                                    : MediaQuery.of(context).size.width * 0.90,
                                child: TextFormField(
                                  scrollPadding: EdgeInsets.only(bottom: 40),
                                  controller: _emailcontroller,
                                  autofocus: false,
                                  textCapitalization: TextCapitalization.none,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Your Email',
                                    hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Urbanist",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    filled: true,
                                    fillColor: Color(0x57FFFFFF),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Urbanist',
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  textAlign: TextAlign.justify,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _model.textController2Validator
                                      .asValidator(context),
                                ),
                              ),
                            ),
                            Align(
                              alignment: MediaQuery.of(context).size.width > 600
                                  ? AlignmentDirectional(-0.80, 0.88)
                                  : AlignmentDirectional(-0.50, 0.88),
                              child: Text(
                                'Don’t have an account?',
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .override(
                                      fontFamily: 'Urbanist',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            Align(
                              alignment: MediaQuery.of(context).size.width > 600
                                  ? AlignmentDirectional(0.45, 0.76)
                                  : AlignmentDirectional(0.41, 0.76),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30,
                                borderWidth: 1,
                                buttonSize: 60,
                                icon: FaIcon(
                                  FontAwesomeIcons.google,
                                  color: Color(0xFFFF296D),
                                  size: 30,
                                ),
                                showLoadingIndicator: true,
                                onPressed: () async {
                                  await _signInWithGoogle();
                                },
                              ),
                            ),
                            Align(
                              alignment: MediaQuery.of(context).size.width > 600
                                  ? AlignmentDirectional(0.65, 0.76)
                                  : AlignmentDirectional(0.73, 0.76),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30,
                                borderWidth: 1,
                                buttonSize: 60,
                                icon: FaIcon(
                                  FontAwesomeIcons.facebook,
                                  color: Color(0xFF0101FF),
                                  size: 30,
                                ),
                                onPressed: () async {
                                  await facebookLogin();
                                },
                              ),
                            ),
                            Align(
                              alignment: MediaQuery.of(context).size.width > 600
                                  ? AlignmentDirectional(0.85, 0.76)
                                  : AlignmentDirectional(1.02, 0.76),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30,
                                borderWidth: 1,
                                buttonSize: 60,
                                icon: FaIcon(
                                  FontAwesomeIcons.twitter,
                                  color: Color(0xFF4C78EF),
                                  size: 30,
                                ),
                                onPressed: () {
                                  twitterlogin();
                                },
                              ),
                            ),
                            Align(
                              alignment: MediaQuery.of(context).size.width > 600
                                  ? AlignmentDirectional(-0.2, 0.89)
                                  : AlignmentDirectional(0.7, 0.89),
                              child: FFButtonWidget(
                                onPressed: () => {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 300),
                                      pageBuilder: (ctx, animation,
                                              secondaryAnimation) =>
                                          SignUpWidget(),
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
                                text: 'Sign up for free',
                                options: FFButtonOptions(
                                  width: 117,
                                  height: 26,
                                  color: Color(0xFFF15C00),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .subtitle2
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    transitionDuration:
                                        Duration(milliseconds: 300),
                                    pageBuilder:
                                        (ctx, animation, secondaryAnimation) =>
                                            forgot(),
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
                              child: Align(
                                alignment: AlignmentDirectional(-0.80, 0.49),
                                child: Text(
                                  'Forgot Password',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Urbanist',
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: MediaQuery.of(context).size.width > 600
                                  ? AlignmentDirectional(-0.80, 0.73)
                                  : AlignmentDirectional(-0.85, 0.76),
                              child: FFButtonWidget(
                                onPressed: () {
                                  onpress();
                                },
                                text: 'Log in',
                                options: FFButtonOptions(
                                  width: 130,
                                  height: 50,
                                  color: Color(0xFFF15C00),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .subtitle2
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                      ),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              })),
        ),
      ),
    );
  }
}
