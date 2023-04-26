import 'package:flutter/foundation.dart';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:koinonia/Api/Networkutils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../home_page/home_page_widget.dart';
import '../main.dart';
import '../model/users.dart';
import '../sign_in/sign_in_widget.dart';
import '../verify_email/verify_email_widget.dart';
import 'sign_up_model.dart';
import 'dart:convert';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:koinonia/sign_up/home.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

export 'sign_up_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);
  static final GlobalKey<_SignUpWidgetState> signUpWidgetKey = GlobalKey();

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  static final GlobalKey<_SignUpWidgetState> _key =
      GlobalKey<_SignUpWidgetState>();
  static final GlobalKey<_SignUpWidgetState> signupPageKey =
      GlobalKey<_SignUpWidgetState>();
  SignUpWidget signUpWidgetInstance = new SignUpWidget();

  late SignUpModel _model;
  String username = '';
  String lastname = '';
  String email = '';
  String password = '';
  bool _passwordsMatch = false;
  late SharedPreferences sharedPreferences;
  late List<Result> _future;
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _errorMessage = '';
  String userid = "";
  GoogleSignInUserData? _userData; // sign-in information?
  bool _isAuthorized = false; // has granted permissions?
  Future<void>? _initialization;

  GoogleSignInUserData? _currentUser;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignUpModel());
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;
      // However, in the web...

      // Now that we know that the user can access the required scopes, the app
      // can call the REST API.
      if (isAuthorized) {
        // _handleGetContact(account!);
      }
    });

    _model.textController1 = TextEditingController();
    _model.textController2 = TextEditingController();
    _model.textController3 = TextEditingController();
    _model.textController4 = TextEditingController();
    _model.textController5 = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      //  final GoogleSignInAccount? user = _currentUser;

      //  print(user!.displayName);
      //   print(user!.email);
      // print(user!.id);
    } catch (error) {
      print(error);
    }
  }

  Future<void> _ensureInitialized() {
    return _initialization ??=
        GoogleSignInPlatform.instance.initWithParams(const SignInInitParameters(
      clientId:
          '153323615895-fik4k6q93ab290alt1ufshi7srhrsv5s.apps.googleusercontent.com',
      scopes: <String>[
        'email',
      ],
    ))
          ..catchError((dynamic _) {
            _initialization = null;
          });
  }

  void _setUser(GoogleSignInUserData? user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _currentUser = user;
    });

    if (user != null) {
      final id = user.id;
      final newId = id.substring(0, id.length - 5);
      final name = user.displayName;
      final pic = user.photoUrl;
      final email = user.email;
      prefs.setString("firstname", name!);
      prefs.setString("email", email);

      prefs.setString("userid", newId);
      prefs.setString("profilepic", pic!);
      setState(() {
        userid = prefs.getString('userid')!;
      });
      await postSignuptwitter(
        newId,
        email,
        "newgogglelogin",
        name,
        " ",
      ).then((value) {
        print(_model.textController4.text);
        print(_model.textController1.text);
        print(_model.textController2.text);
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
    }
  } //

  Future<void> _handleSignIn2() async {
    try {
      await _ensureInitialized();
      _setUser(await GoogleSignInPlatform.instance.signIn());
    } catch (error) {
      //  final bool canceled =
      //     error is PlatformException && error.code == 'sign_in_canceled';
    }
  }

/*
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the user's Google account
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    return userCredential;
  }
*/
  Future<void> storeUserInfo(UserCredential userCredential) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstname', userCredential.user!.displayName ?? '');
    prefs.setString('email', userCredential.user!.email ?? '');
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

  Future<List<Result>> postSignuptwitter(
    String? userid,
    String? email,
    String? pass,
    String? username, //this is firstname
    String? lastname,
  ) async {
    final response = await http.post(
      Uri.parse("https://admin.koinoniaconnect.org/API/signupwithfacebook"),
      body: {
        'user_id': userid,
        'user_email': email,
        'user_password': pass,
        'firstname': username,
        'lastname': lastname,
        'user_profile_pic': 'defaultprofile.png',
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
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
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
        ).then((value) {
          print(_model.textController4.text);
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
          print(_model.textController4.text);
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
                fit: BoxFit.cover,
                image: Image.asset(
                  'assets/images/imageedit_1_5849557343.png',
                ).image,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: MediaQuery.of(context).size.width > 600
                      ? AlignmentDirectional(-0.87, -0.70)
                      : AlignmentDirectional(-0.95, -0.84),
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
                  alignment: AlignmentDirectional(-0.80, -0.55),
                  child: Text(
                    ' Sign up - to save playlists, likes \n albums  and access this across \n different devices',
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Urbanist',
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.80, -0.40),
                  child: Text(
                    'Hello, Sign Up To Continue',
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
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0.35),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width > 600
                                ? MediaQuery.of(context).size.width * 0.85
                                : MediaQuery.of(context).size.width * 0.90,
                            child: TextFormField(
                              controller: _model.textController1,
                              autofocus: false,
                              scrollPadding: EdgeInsets.only(bottom: 40),
                              textCapitalization: TextCapitalization.none,
                              obscureText: !_model.passwordVisibility1,
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
                                suffixIcon: InkWell(
                                  onTap: () => setState(
                                    () => _model.passwordVisibility1 =
                                        !_model.passwordVisibility1,
                                  ),
                                  focusNode: FocusNode(skipTraversal: true),
                                  child: Icon(
                                    _model.passwordVisibility1
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
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
                              validator: _model.textController1Validator
                                  .asValidator(context),
                              onSaved: (value) {
                                password = value!;
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.05, -0.25),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width > 600
                                ? MediaQuery.of(context).size.width * 0.85
                                : MediaQuery.of(context).size.width * 0.90,
                            child: TextFormField(
                              onSaved: (value) {
                                username = value!;
                              },
                              scrollPadding: EdgeInsets.only(bottom: 40),
                              controller: _model.textController2,
                              autofocus: false,
                              textCapitalization: TextCapitalization.none,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'First Name',
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
                              keyboardType: TextInputType.name,
                              validator: _model.textController2Validator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                        Align(
                          alignment: MediaQuery.of(context).size.width > 600
                              ? AlignmentDirectional(-0.80, 0.90)
                              : AlignmentDirectional(-0.54, 0.90),
                          child: Text(
                            'Already have an account?  ',
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Urbanist',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                        Align(
                          alignment: MediaQuery.of(context).size.width > 600
                              ? AlignmentDirectional(0.35, 0.80)
                              : AlignmentDirectional(0.32, 0.80),
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
                              await _handleSignIn2();
                            },
                          ),
                        ),
                        Align(
                          alignment: MediaQuery.of(context).size.width > 600
                              ? AlignmentDirectional(0.55, 0.80)
                              : AlignmentDirectional(0.6, 0.80),
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
                              ? AlignmentDirectional(0.75, 0.80)
                              : AlignmentDirectional(0.91, 0.80),
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
                            onPressed: () async {
                              await twitterlogin();
                            },
                          ),
                        ),
                        Align(
                          alignment: MediaQuery.of(context).size.width > 600
                              ? AlignmentDirectional(0, 0.90)
                              : AlignmentDirectional(0.7, 0.90),
                          child: FFButtonWidget(
                            onPressed: () => {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 300),
                                  pageBuilder:
                                      (ctx, animation, secondaryAnimation) =>
                                          SignInWidget(),
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
                            text: 'Login',
                            options: FFButtonOptions(
                              width: 80,
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-0.80, 0.80),
                          child: FFButtonWidget(
                            onPressed: () {
                              onpress().catchError((error) {
                                if (error is RangeError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(error.message),
                                      backgroundColor: Color(0xFFF15C00),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Email is already registered'),
                                      backgroundColor: Color(0xFFF15C00),
                                    ),
                                  );
                                }
                              });
                              print("signup pressed");
                            },
                            text: 'Sign Up',
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
                        Align(
                          alignment: AlignmentDirectional(0, -0.05),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width > 600
                                ? MediaQuery.of(context).size.width * 0.85
                                : MediaQuery.of(context).size.width * 0.90,
                            child: TextFormField(
                              scrollPadding: EdgeInsets.only(bottom: 40),
                              controller: _model.textController3,
                              autofocus: false,
                              textCapitalization: TextCapitalization.none,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'Last Name',
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
                              keyboardType: TextInputType.name,
                              validator: _model.textController3Validator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0, 0.15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width > 600
                                ? MediaQuery.of(context).size.width * 0.85
                                : MediaQuery.of(context).size.width * 0.90,
                            child: TextFormField(
                              onSaved: (value) {
                                email = value!;
                              },
                              scrollPadding: EdgeInsets.only(bottom: 40),
                              controller: _model.textController4,
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
                              validator: _model.textController4Validator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0, 0.55),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width > 600
                                ? MediaQuery.of(context).size.width * 0.85
                                : MediaQuery.of(context).size.width * 0.90,
                            child: TextFormField(
                              scrollPadding: EdgeInsets.only(bottom: 40),
                              controller: _model.textController5,
                              autofocus: false,
                              textCapitalization: TextCapitalization.none,
                              obscureText: !_model.passwordVisibility2,
                              decoration: InputDecoration(
                                //  errorText: _passwordsMatch
                                //    ? null
                                //  : 'Passwords do not match',
                                hintText: 'Confirm Password',
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
                                suffixIcon: InkWell(
                                  onTap: () => setState(
                                    () => _model.passwordVisibility2 =
                                        !_model.passwordVisibility2,
                                  ),
                                  focusNode: FocusNode(skipTraversal: true),
                                  child: Icon(
                                    _model.passwordVisibility2
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
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
                              validator: _model.textController5Validator
                                  .asValidator(context),
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
        ),
      ),
    );
  }

  Future<List<Result>> postSignup(
    String? email,
    String? pass,
    String? username, //this is firstname
    String? lastname,
  ) async {
    final response = await http.post(
      Uri.parse("https://admin.koinoniaconnect.org/API/" + 'signup'),
      body: {
        'user_email': email,
        'user_password': pass,
        'firstname': username,
        'lastname': lastname,
        'user_profile_pic': "uploads/user/defaultprofile.png",
      },
    );

    if (response.statusCode == 200) {
      final List music = json.decode(response.body);
      final List result = jsonDecode(response.body);
      if (result[0] == 'error') {
        setState(() {
          _errorMessage = result[1];
        });
        throw RangeError(_errorMessage);
      }
      return music.map((json) => Result.fromJson(json)).toList();
    }
    throw Exception();
  }

  onpress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    } else if (_model.textController4.text == "" &&
        _model.textController1.text == "" &&
        _model.textController2.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xFFF15C00),
          content: Text(
            'Fill all fields correctly.!',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Urbanist',
            ),
          )));
      return;
    }

    _formKey.currentState?.save();
    await postSignup(
      _model.textController4.text,
      _model.textController1.text,
      _model.textController2.text,
      _model.textController3.text,
    ).then((value) {
      print(_model.textController4.text);
      print(_model.textController1.text);
      print(_model.textController2.text);

      setState(() {
        _future = value!;
      });
    });

    try {
      // ignore: unnecessary_null_comparison
      if (_future[0] == null) {
        print('object');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('check Your credetials!')));
        return;
      }
    } on RangeError catch (_) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User is Already Registered!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    // MyData.myName = _future.result[0].userId;
    // MyData.myImage = _future.result[0].userProfilePic;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // prefs.setBool("isfirst", false);
    // prefs.setString("name", _future.result[0].userId);
    //prefs.setString("email", _future.result[0].userEmail);
    prefs.setString("firstname", _future[0].userName);
    prefs.setString("userid", _future[0].userId);
    prefs.setString("profilepic", "defaultprofile.png");
    setState(() {
      userid = prefs.getString('userid')!;
    });

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (ctx, animation, secondaryAnimation) => VerifyEmailWidget(
          prevModel: _model,
          Email: _model.textController4.text,
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
  }
}
