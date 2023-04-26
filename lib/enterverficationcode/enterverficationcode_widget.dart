import 'dart:convert';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../model/users.dart';
import '../sign_up/sign_up_model.dart';
import 'cong.dart';
import 'enterverficationcode_model.dart';
export 'enterverficationcode_model.dart';
import 'package:auth_handler/auth_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EnterverficationcodeWidget extends StatefulWidget {
  final String Email;
  final String otp;
  SignUpModel prevModel;
   EnterverficationcodeWidget(
      {Key? key, required this.Email,required this.prevModel, required this.otp})
      : super(key: key);

  @override
  _EnterverficationcodeWidgetState createState() =>
      _EnterverficationcodeWidgetState();
}

class _EnterverficationcodeWidgetState
    extends State<EnterverficationcodeWidget> {
  late EnterverficationcodeModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final TextEditingController _otpcontroller = TextEditingController();
  AuthHandler authHandler = AuthHandler();
  String? _recipientEmail;
  String? _otp;
  String _errorMessage = '';
  String userid = "";
  late List<Result> _future;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EnterverficationcodeModel());
    _recipientEmail = widget.Email;
    _otp = widget.otp;
    print("widget.otp: ${widget.otp}");
    _model.textController = TextEditingController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  updateuserstatus() async {
    final url =
        Uri.parse('https://admin.koinoniaconnect.org/API/emailverification');
    final response =
        await http.post(url, body: {'user_email': widget.Email, 'status': '1'});
  }

  String? _senderName = 'koinonia connect';
  String? _senderEmail = 'koinonia@connect.com';
  sendotp() async {
    String? _otpLength = '5';
    String baseUrl =
        "http://flutter.rohitchouhan.com/email-otp/authhandler.php";
    String url =
        "$baseUrl?app_name=$_senderName&app_email=$_senderEmail&user_email=$_recipientEmail&otp_length=$_otpLength";
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    print(response.body);
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (jsonDecode(response.body)['status'] == true) {
          _otp = json['otp'].toString();
setState(() {
  
});
          return true;
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
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

  verifyotp() async {

    if (_recipientEmail!.isEmpty || _otp.toString().isEmpty) {
      print("❌ The email or otp is empty. ❌");
      return false;
    } else if (_otp == _model.textController.text) {
      updateuserstatus();
      SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
        userid =prefs.getString('userid')!;
    });
      prefs.setBool('isLoggedIn', true);
      prefs.setString("profilepic", "defaultprofile.png");


      // await postSignup(
      //   widget.prevModel.textController4.text,
      //   widget.prevModel.textController1.text,
      //   widget.prevModel.textController2.text,
      //   widget.prevModel.textController3.text,
      // ).then((value) {
      //   print(widget.prevModel.textController4.text);
      //   print(widget.prevModel.textController1.text);
      //   print(widget.prevModel.textController2.text);

      //   setState(() {
      //     _future = value!;
      // //   });
      // // });

      // try {
      //   // ignore: unnecessary_null_comparison
      //   if (_future[0] == null) {
      //     print('object');
      //     ScaffoldMessenger.of(context)
      //         .showSnackBar(SnackBar(content: Text('check Your credetials!')));
      //     return;
      //   }
      // } on RangeError catch (_) {
      //   return ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('User is Already Registered!'),
      //       backgroundColor: Colors.redAccent,
      //     ),
      //   );
      // }
      // MyData.myName = _future.result[0].userId;
      // MyData.myImage = _future.result[0].userProfilePic;
      // prefs.setBool("isfirst", false);
      // prefs.setString("name", _future.result[0].userId);
      //prefs.setString("email", _future.result[0].userEmail);
      // prefs.setString("firstname", _future[0].userName);
      // prefs.setString("userid", _future[0].userId);
      prefs.setString("profilepic", "defaultprofile.png");
      // setState(() {
      //   userid =prefs.getString('userid')!;
      // });
      // print(prefs.getString('username'));



      print("✅ Verified successfully");
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (ctx, animation, secondaryAnimation) => cong(),
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
      return Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (ctx, animation, secondaryAnimation) =>
                NavBarPage(initialPage: 'HomePage', userid: userid,),
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
      });
    } else {
      print("❌ Invalid OTP");
      print(_otp);
      print(_model.textController.text);
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
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Container(
            width: double.infinity,
          height: double.infinity,
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
                  alignment: AlignmentDirectional(0, -0.57),
                  child: Text(
                    'Code has been send to\n' + widget.Email,
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
                    alignment: AlignmentDirectional(0, -0.35),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(37, 0, 0, 0),
                      child: TextFormField(
                        controller: _model.textController,
                        autofocus: false,
                        textCapitalization: TextCapitalization.none,
                        obscureText: false,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '      Enter Verfication code',
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
                        keyboardType: TextInputType.number,
                        validator:
                            _model.textControllerValidator.asValidator(context),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.02, -0.10),
                  child: FFButtonWidget(
                    onPressed: () => {
                      verifyotp(),
                    },
                    text: 'Verify ',
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
