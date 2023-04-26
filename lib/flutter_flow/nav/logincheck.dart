import 'package:koinonia/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../sign_in/sign_in_widget.dart';

class logincheck extends StatefulWidget {
  const logincheck({Key? key}) : super(key: key);

  @override
  _OnboardingScreen1WidgetState createState() =>
      _OnboardingScreen1WidgetState();
}

class _OnboardingScreen1WidgetState extends State<logincheck> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String userid = "";
    String defaultValue = "3";

  @override
  void initState() {
    super.initState();
    check();
  }

  void check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('userid') ?? defaultValue;
    });
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
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
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              OnboardingScreen1Widget(),
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

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
