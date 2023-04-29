import 'package:koinonia/enterverficationcode/enterverficationcode_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:auth_handler/auth_handler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../sign_up/sign_up_model.dart';
import 'verify_email_model.dart';
export 'verify_email_model.dart';

class VerifyEmailWidget extends StatefulWidget {
  final String Email;
  final SignUpModel prevModel;
  VerifyEmailWidget({Key? key, required this.prevModel, required this.Email})
      : super(key: key);

  @override
  _VerifyEmailWidgetState createState() => _VerifyEmailWidgetState();
}

class _VerifyEmailWidgetState extends State<VerifyEmailWidget> {
  late VerifyEmailModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final TextEditingController _otpcontroller = TextEditingController();
  AuthHandler authHandler = AuthHandler();
  bool fetching = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VerifyEmailModel());

    sendotp();
    _model.textController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  String? _otp;
  String? _senderName = 'koinonia';
  String? _senderEmail = 'mail@koinia.org';
  sendotp() async {
    String? _recipientEmail = widget.Email;
    String? _otpLength = '5';
    String baseUrl =
        "https://admin.koinoniaconnect.org/application/phpmailer_mobileapp/index.php";
    String url =
        "$baseUrl?appName=$_senderName&toMail=$_recipientEmail&otpLength=$_otpLength";
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    print(response.body);
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (jsonDecode(response.body)['status'] == "ok") {
          _otp = json['message'].toString();
          print(_otp);
          setState(() {
            _otp = this._otp;
            fetching = false;
          });
          return true;
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return fetching
        ? SpinKitWave(
            color: Color(0xFFF15C00),
            size: 50.0,
          )
        : Scaffold(
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
                      fit: BoxFit.fill,
                      image: Image.asset(
                        'assets/images/verifyemail.png',
                      ).image,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0.07),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                          child: SizedBox(
                            width: 300,
                            child: Text(
                              'Email verification is required. Tap Verify to continue',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .override(
                                    fontFamily: 'Urbanist',
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, 0.5),
                        child: Container(
                          height: MediaQuery.of(context).size.width > 600
                              ? 200
                              : 130,
                          width: MediaQuery.of(context).size.width > 600
                              ? 580
                              : 320,
                          child: TextFormField(
                            controller: _model.textController,
                            autofocus: false,
                            obscureText: false,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintStyle: FlutterFlowTheme.of(context).bodyText2,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(31),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(31),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(31),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(31),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Poppins',
                                      lineHeight: 10,
                                    ),
                            validator: _model.textControllerValidator
                                .asValidator(context),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.55, 0.45),
                        child: Image.asset(
                          'assets/images/Auto_Layout_Horizontal.png',
                          width: MediaQuery.of(context).size.width < 600
                              ? 70
                              : 140,
                          height: MediaQuery.of(context).size.width < 600
                              ? 70
                              : 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.20, 0.30),
                        child: Text(
                          'via Email:',
                          style:
                              FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF757575),
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.50, 0.45),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width < 600
                              ? 170
                              : 340,
                          child: Text(
                            widget.Email,
                            //textAlign: TextAlign.justify,
                            maxLines: 2,
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .override(
                                  fontFamily: 'Poppins',
                                  fontSize:
                                      MediaQuery.of(context).size.width < 600
                                          ? 13
                                          : 16,
                                  fontWeight: FontWeight.bold,
                                  lineHeight: 2,
                                ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, 0.85),
                        child: SizedBox(
                          width: 250,
                          child: FFButtonWidget(
                            onPressed: () => {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 300),
                                  pageBuilder:
                                      (ctx, animation, secondaryAnimation) =>
                                          EnterverficationcodeWidget(
                                              prevModel: widget.prevModel,
                                              Email: widget.Email,
                                              otp: _otp!),
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
                            text: 'Verify your email',
                            options: FFButtonOptions(
                              width: 322,
                              height: 54,
                              color: Color(0xFFF15C00),
                              textStyle: FlutterFlowTheme.of(context)
                                  .subtitle2
                                  .override(
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
