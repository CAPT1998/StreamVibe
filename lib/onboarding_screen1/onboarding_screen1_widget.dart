import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../sign_in/sign_in_widget.dart';
import 'onboarding_screen1_model.dart';
export 'onboarding_screen1_model.dart';

class OnboardingScreen1Widget extends StatefulWidget {
  const OnboardingScreen1Widget({Key? key}) : super(key: key);

  @override
  _OnboardingScreen1WidgetState createState() =>
      _OnboardingScreen1WidgetState();
}

class _OnboardingScreen1WidgetState extends State<OnboardingScreen1Widget> {
  late OnboardingScreen1Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingScreen1Model());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              image: DecorationImage(
                fit: MediaQuery.of(context).size.width > 600
                    ? BoxFit.cover
                    : BoxFit.fill,
                image: Image.asset(
                  'assets/images/onboard.png',
                ).image,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: MediaQuery.of(context).size.width > 600
                      ? AlignmentDirectional(-0.13, 0.95)
                      : AlignmentDirectional(-0.16, 0.80),
                  child: FFButtonWidget(
                    onPressed: () => {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 300),
                          pageBuilder: (ctx, animation, secondaryAnimation) =>
                              SignInWidget(),
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
                      ),
                    },
                    text: 'Next',
                    options: FFButtonOptions(
                      width: MediaQuery.of(context).size.width > 600
                          ? MediaQuery.of(context).size.width * 0.8
                          : MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.07,
                      color: Color(0xFFF15C00),
                      splashColor: Color(0x777089AF),
                      textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
                                fontFamily: 'Urbanist',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
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
      ),
    );
  }
}
