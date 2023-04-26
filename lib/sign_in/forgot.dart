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

import 'forgot2.dart';

class forgot extends StatefulWidget {
  const forgot({
    Key? key,
  }) : super(key: key);

  @override
  _EnterverficationcodeWidgetState createState() =>
      _EnterverficationcodeWidgetState();
}

class _EnterverficationcodeWidgetState extends State<forgot> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final TextEditingController emailcontroller = TextEditingController();
  bool _isVisible = false;
  final _formKey = GlobalKey<FormState>();
  String? _Email = "";
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

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  updateuserstatus() async {
    final url =
        Uri.parse('https://admin.koinoniaconnect.org/API/emailverification');
    final response = await http
        .post(url, body: {'user_email': emailcontroller, 'status': '1'});
  }

  String? _senderName = 'Forgot password for koinonia connect?';
  String? _senderEmail = 'koinonia@connect.com';
  //String? _Email = emailcontroller.text;
  sendotp() async {
    String? _otpLength = '5';
    String baseUrl =
        "http://flutter.rohitchouhan.com/email-otp/authhandler.php";
    String url =
        "$baseUrl?app_name=$_senderName&app_email=$_senderEmail&user_email=$_Email&otp_length=$_otpLength";
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    print(response.body);
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (jsonDecode(response.body)['status'] == true) {
          _otp = json['otp'].toString();
          print(_otp);
          return true;
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  verifyotp() async {
    if (_Email!.isEmpty || _otp.toString().isEmpty) {
      print("❌ The email or otp is empty. ❌");
      return false;
    } else if (_otp == _otpcontroller.text) {
      //updateuserstatus();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      //prefs.setBool('isLoggedIn', true);
      //prefs.setString("profilepic", "defaultprofile.png");

      print("✅ Verified successfully");
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (ctx, animation, secondaryAnimation) => forgot2(
            email: _Email!,
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
    } else {
      print("❌ Invalid OTP");
      print(_otp);
      //  print(_model.textController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.transparent,
          //padding: EdgeInsets.only(bottom: 40),
          content: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Text(
                'Wrong OTP entered!',
                style: TextStyle(
                  color: Color(0xFFF15C00),
                  fontFamily: 'Urbanist',
                  fontSize: 15,
                ),
              ))));
    }
    return false;
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
            width: double.infinity,
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
                    'Recover Account',
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
                        controller: emailcontroller,
                        autofocus: false,
                        scrollPadding: EdgeInsets.only(bottom: 40),
                        onChanged: (value) {
                          _Email = value;
                        },
                        textCapitalization: TextCapitalization.none,
                        obscureText: false,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: ' Enter email address',
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
                      _toggleVisibility(),
                      sendotp(),
                    },
                    text: 'Send Otp ',
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(37, 380, 37, 0),
                  child: Visibility(
                    visible: _isVisible,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: TextFormField(
                              scrollPadding: EdgeInsets.only(bottom: 40),

                              controller: _otpcontroller,
                              autofocus: false,
                              textCapitalization: TextCapitalization.none,
                              obscureText: false,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Enter otp',
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                              // textAlign: TextAlign.justify,
                              maxLines: null,
                              keyboardType: TextInputType.number,

                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]'))
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF15C00),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Do something with the text input
                                String text = _otpcontroller.text;
                                print(text);
                                verifyotp();
                              }
                            },
                            child: Text('Submit'),
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
