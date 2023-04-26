import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:koinonia/playlist/playlist_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koinonia/src/widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api/Networkutils.dart';
import '../flutter_flow/flutter_flow_ad_banner.dart';
import '../flutter_flow/flutter_flow_audio_player.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../sign_in/sign_in_widget.dart';
import '../src/helpers/app_colors.dart';
import '../src/helpers/utils.dart';
import '../src/widgets/user_image_picker.dart';
import 'playlist_model.dart';
export 'playlist_model.dart';

class getallPlaylistWidget extends StatefulWidget {
  late final String userid;
  getallPlaylistWidget({Key? key, required this.userid}) : super(key: key);

  @override
  _PlaylistWidgetState createState() => _PlaylistWidgetState();
}

class getAllplaylistsAPI {
  static Future<List<Getplaylistmodel>> getallplaylist(String userid) async {
    //print("HElloworld");

    final url = Uri.parse('https://admin.koinoniaconnect.org/API/getPlaylists');
    final response = await http.post(url, body: {
      'user_id': userid,
    });

    if (response.statusCode == 200) {
      final List playlist = json.decode(response.body);
      final List artistinfo = json.decode(response.body);

      return playlist.map((json) => Getplaylistmodel.fromJson(json)).toList();
      //artistinfo.map((json) => Artists.fromJson(json)).toList();
    }
    throw Exception();
  }
}

class _PlaylistWidgetState extends State<getallPlaylistWidget> {
  List<Getplaylistmodel> playlist = [];
  final textcontroller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late Networkutils networkutils;
  late File pickedImage;
  String userid = "";
  bool _isTextFieldValid = false;
  bool _isImageSelected = false;
  bool fetching = true;
  @override
  void initState() {
    super.initState();
    sharedprefs();

    init1();

    networkutils = Networkutils();
    // WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<void> sharedprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid")!;
    });
    print("current_user_id is " + userid);
  }

  init1() async {
    print("before getplaylistall the userid is " + userid);

    final playlist = await getAllplaylistsAPI.getallplaylist(widget.userid);
    if (mounted) {
      setState(() {
        fetching = false;
        this.playlist = playlist;
      });
    }
  }

  void toast() {
    SnackBar(
      content: Text(
        'Name and image cannot be empty',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFFF15C00),
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: StadiumBorder(),
      width: 200,
      duration: Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
    );
  }

  Future deletePopup(BuildContext context, id) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Playlist'),
          content: Text('This will delete the playlist!'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // ignore: deprecated_member_use
            ElevatedButton(
              style: ButtonStyle(),
              child: Text(
                'Ok',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                await deleteplaylist(id);
                Utils.allPlayListRefreshIndicatorKey.currentState?.show();
                Utils.homepagePlaylistRefreshIndicatorKey.currentState?.show();
                Navigator.of(context).pop();
                // Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Color(0xFFF15C00),
                    content: Text('Playlist Deleted!'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteplaylist(String pid) async {
    await networkutils.deleteplaylist(widget.userid, pid);
    init1();
    setState(() {});
  }

  @override
  void dispose() {
    //_model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  Widget buildAlbum(Getplaylistmodel model) => Container(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlaylistWidget(
                  model.imagesslist,
                  model.userPlaylistName,
                  model.userPlaylistId,
                  userid,
                ),
              ),
            );
          },
          onLongPress: () async {
            await deletePopup(context, model.userPlaylistId);
          },
          child: Row(
            //mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(
                    "https://admin.koinoniaconnect.org/uploads/movie/" +
                        model.userPlaylistImage,
                    // errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Text(
                  model.userPlaylistName,
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
  void addTx(File pickedImage) async {
    List<int> imageBytes = await pickedImage.readAsBytes();
    String baseimage = base64Encode(imageBytes);

    final entertitle = textcontroller.text;
    _formkey.currentState?.validate();
    if (entertitle.isEmpty) {
      return;
    }
    final url =
        Uri.parse('https://admin.koinoniaconnect.org/API/createPlayList');
    final response = await http.post(url, body: {
      'user_id': widget.userid,
      'user_playlist_name': entertitle,
      'user_playlist_image': baseimage,
    });
    if (response.statusCode == 200) {
      final List playlist1 = json.decode(response.body);
    }
    Navigator.of(context).pop();
    Utils.allPlayListRefreshIndicatorKey.currentState?.show();
    Utils.homepagePlaylistRefreshIndicatorKey.currentState?.show();
    SnackBar(
      backgroundColor: Color(0xFFF15C00),
      content: Text('Song added!'),
    );
    print(response.body);
  }

  void addTx2() async {
    // List<int> imageBytes = await pickedImage.readAsBytes();
    //String baseimage = base64Encode(imageBytes);

    final entertitle = textcontroller.text;
    _formkey.currentState?.validate();
    if (entertitle.isEmpty) {
      return;
    }
    final url =
        Uri.parse('https://admin.koinoniaconnect.org/API/createPlayList');
    final response = await http.post(url, body: {
      'user_id': widget.userid,
      'user_playlist_name': entertitle,
      'user_playlist_image': "",
    });
    if (response.statusCode == 200) {
      final List playlist1 = json.decode(response.body);
    }
    Navigator.of(context).pop();
    SnackBar(
      backgroundColor: Color(0xFFF15C00),
      content: Text('Track added!'),
    );
    print(response.body);
  }
  // void onpress() async {
  //   final ImagePicker _picker = ImagePicker();
  //   pickedImage = (await _picker.pickImage(source: ImageSource.gallery))!;
  //   setState(() {
  //     pickedImage = this.pickedImage;
  //   });
  //   if (pickedImage != null) {
  //     setState(() {
  //       // Check if an image is selected
  //       _isImageSelected = true;
  //     });
  //   }
  // }

  Future showExitPopup(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Playlist'),
          content: Text('Name and image cannot be empty'),
          actions: <Widget>[
            // ignore: deprecated_member_use
            ElevatedButton(
              style: ButtonStyle(),
              child: Text(
                'Ok',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // File? userImage;
  getImage(img) {
    pickedImage = img;
    _isImageSelected = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
          child: Text('Add'),
          elevation: 12,
          backgroundColor: Color(0xFFF15C00),
          foregroundColor: Colors.white,
          onPressed: () {
            if (widget.userid == "3") {
              var snackBar = SnackBar(
                content: Text(
                  'Please Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF15C00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                shape: StadiumBorder(),
                width: 200,
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              showModalBottomSheet(
                backgroundColor: Color(0xFFF15C00),
                isScrollControlled: true,
                context: context,
                builder: (ctx) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Create New Playlist',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    // alignment: Alignment.topRight,
                                    child: UserImagePicker(
                                      imgFunction: getImage,
                                      avatar: Icons.camera_enhance_sharp,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 65,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              autofocus: false,
                              scrollPadding: EdgeInsets.only(bottom: 40),
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Enter playlist name',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () async {
                                    if (_isTextFieldValid && _isImageSelected) {
                                      print(_isImageSelected);
                                      print(_isTextFieldValid);
                                      addTx(pickedImage);
                                    } else if (_isTextFieldValid) {
                                      addTx2();
                                    } else {
                                      print(_isImageSelected);
                                      print(_isTextFieldValid);
                                      await showExitPopup(context);
                                    }
                                  },
                                  child: Icon(
                                    Icons.done,
                                    size: 25,
                                    color: Color(0xFFF15C00),
                                  ),
                                ),
                              ),
                              // onEditingComplete: onpress,
                              //onSaved: (_) => onpress(),
                              controller: textcontroller,
                              onChanged: (value) {
                                setState(() {
                                  // Check if the text field contains text
                                  _isTextFieldValid = value.isNotEmpty;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: CustomAppBar(
        userid: widget.userid,
        title: 'Your Playlist',
      ),
      body: widget.userid == "3"
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'You must be logged in to view Playlists',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF15C00),
                    ),
                    onPressed: () {
                      // handle login button press
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
                      );
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              key: Utils.allPlayListRefreshIndicatorKey,
              color: Colors.white,
              backgroundColor: Color(0xFFF15C00),
              strokeWidth: 4.0,
              edgeOffset: 10,
              onRefresh: () {
                return init1();
              },
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      fetching
                          ? SpinKitRotatingCircle(
                              color: AppColors.DARK_ORANGE,
                              size: 50.0,
                            )
                          : playlist.length > 0
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: playlist.length,
                                    itemBuilder: (context, index) {
                                      final playlist1 = playlist[index];

                                      return buildAlbum(playlist1);
                                    },
                                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    //crossAxisCount: 2),
                                  ),
                                )
                              : Text("There is no playlist"),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
