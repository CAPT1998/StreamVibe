import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/profilemodel.dart';
import 'profile_model.dart';
export 'profile_model.dart';
import 'package:http/http.dart' as http;

class profileinfoApi {
  static Future<List<Profilemodel>> getprofileinfo(String userid) async {
    final url =
        Uri.parse('https://admin.koinoniaconnect.org/API/viewprofileinfo');
    final response = await http.post(url, body: {
      'user_id': userid,
    });
    if (response.statusCode == 200) {
      final List pinfo = json.decode(response.body);

      return pinfo.map((json) => Profilemodel.fromJson(json)).toList();
    }
    throw Exception();
  }
}

class ProfileWidget extends StatefulWidget {
  final String userid;
  const ProfileWidget({Key? key, required this.userid}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;
  List record = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Profilemodel> pinfo = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());
    showprofileinfo();

    _model.textController1 = TextEditingController();
    _model.textController2 = TextEditingController();
    _model.textController3 = TextEditingController();
    _model.textController4 = TextEditingController();
    _model.textController5 = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future showprofileinfo() async {
    final pinfo = await profileinfoApi.getprofileinfo(
      widget.userid,
    );
    setState(() => this.pinfo = pinfo);
  }

  Widget buildform(Profilemodel pinfo) => Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Color(0x430F1113),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Container(
                      width: 60,
                      height: 60,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        children: [
                          ClipOval(
                            child: Image.network(
                              "https://admin.koinoniaconnect.org/" +
                                  pinfo.userProfilePic,
                              fit: BoxFit.scaleDown,
                              width: 60,
                              height: 60,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
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
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Form(
                          key: _model.formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Container(
                            width: 100,
                            height: 298.4,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0, 1.30),
                                  child: TextFormField(
                                    controller: _model.textController1,
                                    obscureText: false,
                                    readOnly: true,
                                    scrollPadding: EdgeInsets.only(bottom: 40),
                                    decoration: InputDecoration(
                                      hintText: pinfo.city,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodyText2
                                          .override(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF95A1AC),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFF1F4F8),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFF1F4F8),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFEBEBEB),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16, 16, 16, 16),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: Color(0xFF090F13),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    maxLines: null,
                                    validator: _model.textController1Validator
                                        .asValidator(context),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, -0.99),
                                  child: TextFormField(
                                    controller: _model.textController2,
                                    obscureText: false,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: pinfo.firstname,
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodyText2
                                          .override(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF95A1AC),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFF1F4F8),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFF1F4F8),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFEBEBEB),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16, 16, 16, 16),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: Color(0xFF090F13),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    maxLines: null,
                                    validator: _model.textController2Validator
                                        .asValidator(context),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, -0.42),
                                  child: TextFormField(
                                    controller: _model.textController3,
                                    autofocus: false,
                                    readOnly: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: pinfo.lastname,
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodyText2
                                          .override(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF95A1AC),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFF1F4F8),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFF1F4F8),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFEBEBEB),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16, 16, 16, 16),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: Color(0xFF090F13),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    maxLines: null,
                                    keyboardType: TextInputType.name,
                                    validator: _model.textController3Validator
                                        .asValidator(context),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 0.15),
                                  child: TextFormField(
                                    controller: _model.textController4,
                                    obscureText: false,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: pinfo.userEmail,
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodyText2
                                          .override(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF95A1AC),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                      suffixIcon: Icon(
                                        Icons.mark_email_read,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFF1F4F8),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFF1F4F8),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFEBEBEB),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16, 16, 16, 16),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: Color(0xFF090F13),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    maxLines: null,
                                    validator: _model.textController4Validator
                                        .asValidator(context),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 0.72),
                                  child: TextFormField(
                                    controller: _model.textController5,
                                    obscureText: false,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: pinfo.about,
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .bodyText2
                                          .override(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF95A1AC),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFF1F4F8),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFF1F4F8),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(38),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFEBEBEB),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16, 16, 16, 16),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: 'Urbanist',
                                          color: Color(0xFF090F13),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    maxLines: null,
                                    validator: _model.textController5Validator
                                        .asValidator(context),
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 52, 0, 12),
                  child: FFButtonWidget(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: 'Go Back',
                    options: FFButtonOptions(
                      width: 220,
                      height: 50,
                      color: Color(0xFFF15C00),
                      textStyle:
                          FlutterFlowTheme.of(context).bodyText2.override(
                                fontFamily: 'Lexend Deca',
                                color: Colors.white,
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
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF090F13),
            size: 30,
          ),
          onPressed: () => {Navigator.pop(context)},
        ),
        title: Align(
          alignment: AlignmentDirectional(-0.2, 0),
          child: Text(
            'Profile',
            style: FlutterFlowTheme.of(context).title2.override(
                  fontFamily: 'Poppins',
                  color: Color(0xFF090F13),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: pinfo.length,
                itemBuilder: (context, index) {
                  final form = pinfo[index];

                  return buildform(form);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
