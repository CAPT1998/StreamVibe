import 'package:koinonia/index.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:auth_handler/auth_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class forgot2 extends StatefulWidget {
  final String email;
  forgot2({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _EnterverficationcodeWidgetState createState() =>
      _EnterverficationcodeWidgetState();
}

class _EnterverficationcodeWidgetState extends State<forgot2> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final TextEditingController passcontroller = TextEditingController();
  bool _isVisible = false;
  final _formKey = GlobalKey<FormState>();
  String? _pass = "";
  final TextEditingController _otpcontroller = TextEditingController();
  AuthHandler authHandler = AuthHandler();
  String? _recipientEmail;
  String? _otp;

  @override
  void initState() {
    super.initState();
    //_recipientEmail = widget.Email;
    // _otp = widget.otp;
    // print(widget.otp);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  void doupdate() async {
    print(widget.email);
    print(_pass);
    await updatePassword(widget.email, _pass!);
  }

  Future<void> updatePassword(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://admin.koinoniaconnect.org/API/update_password'),
      body: {'user_email': email, 'user_password': password},
    );
    if (response.statusCode == 200) {
      print('Password updated successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xFFF15C00),
          content: Text(
            'Password changed successfully!',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Urbanist',
            ),
          )));
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (ctx, animation, secondaryAnimation) => SignInWidget(),
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
      throw Exception('Failed to update password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          //onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(
                  'assets/images/entercode.png',
                ).image,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional(0, -0.77),
                  child: Text(
                    'Enter new password',
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Align(
                    alignment: AlignmentDirectional(0, -0.55),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(37, 0, 0, 0),
                      child: TextFormField(
                        controller: passcontroller,
                        autofocus: false,
                        scrollPadding: EdgeInsets.only(bottom: 40),
                        onChanged: (value) {
                          _pass = value;
                        },
                        textCapitalization: TextCapitalization.none,
                        obscureText: false,
                        textAlign: TextAlign.center,
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
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Urbanist',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                        // textAlign: TextAlign.justify,
                        maxLines: null,
                        // keyboardType: TextInputType.number,

                        // inputFormatters: [
                        // FilteringTextInputFormatter.allow(RegExp('[0-9]'))
//],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.02, -0.35),
                  child: FFButtonWidget(
                    onPressed: () => {
                      // _toggleVisibility(),
                      doupdate(),
                    },
                    text: 'Confirm ',
                    options: FFButtonOptions(
                      width: MediaQuery.of(context).size.width * 0.60,
                      height: 54,
                      color: Color(0xFFF15C00),
                      textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
                                fontFamily: 'Urbanist',
                                color: Colors.white,
                                fontSize: 16,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
