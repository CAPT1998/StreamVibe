import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:koinonia/src/services/login_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import 'package:flutter/services.dart';
import './setting/setting_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  late String _userId;

  String get userId => _userId;

  void setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _userId = prefs.getString("userid")!;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  HttpOverrides.global = MyHttpOverrides();
  Stripe.publishableKey =
      'pk_live_51MpflmDEUeImIb8o5f0GEXnFsIHDUWaibxrPSvsdunh0WJ66uZNNylpDooBj8CAFO4nv6IASk7xjK306qKjJKrHj00EylNbZjk';
  //await Stripe.instance.applySettings();

  //await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = '3';
  // await Firebase.initializeApp();

  await FlutterFlowTheme.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserModel()),
        //ChangeNotifierProvider(create: (_) => LoginService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String userid = "";
  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier();
    _router = createRouter(_appStateNotifier);

    Future.delayed(Duration(seconds: 2),
        () => setState(() => _appStateNotifier.stopShowingSplashImage()));
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(builder: (context, notifier, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Koinonia',
          localizationsDelegates: [
            FFLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: _locale,
          supportedLocales: const [Locale('en', '')],
          theme: ThemeData(brightness: Brightness.light),
          themeMode: Provider.of<ThemeNotifier>(context).themeMode,

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(color: Colors.white, fontFamily: "Urbanist"),
            ),
          ),
          //themeMode: _themeMode,
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
        );
      }),
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage, this.page, this.userid})
      : super(key: key);

  final String? initialPage;
  final Widget? page;
  final String? userid;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'HomePage';
  late Widget? _currentPage;
  late String? userid = "";
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.initState();
    sharedprefs();

    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  Future sharedprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'HomePage': HomePageWidget(
        userid: widget.userid!,
      ),
      'SearchScreen': SearchScreenWidget(userid: widget.userid!),
      'Library': LibraryWidget(),
      'Setting': SettingWidget(userid: userid!),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);
    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() {
            _currentPage = null;
            _currentPageName = tabs.keys.toList()[i];
          }),
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFF15C00),
          unselectedItemColor: Color(0x8A000000),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: new Image.asset(
                'assets/images/home.png',
                width: 40,
                height: 40,
              ),
              activeIcon: new Image.asset('assets/images/ahome.png',
                  width: 40, height: 40),
              // backgroundColor: Colors.green,
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: new Image.asset('assets/images/disc.png',
                  width: 40, height: 40),
              activeIcon: new Image.asset('assets/images/adisc.png',
                  width: 40, height: 40),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: new Image.asset('assets/images/lib.png',
                  width: 40, height: 40),
              activeIcon: new Image.asset('assets/images/alib.png',
                  width: 40, height: 40),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: new Image.asset('assets/images/sett.png',
                  width: 40, height: 40),
              activeIcon: new Image.asset('assets/images/asett.png',
                  width: 40, height: 40),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}
