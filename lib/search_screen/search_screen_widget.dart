import 'dart:async';
//import 'package:image_network/image_network.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../model/musics.dart';
import '../playing/playercheck/musicplayer.dart';
import '../src/helpers/app_colors.dart';
import 'search_screen_model.dart';
export 'search_screen_model.dart';
import 'dart:convert';
import 'package:koinonia/model/searchsongs.dart';
import 'package:http/http.dart' as http;

class SearchScreenWidget extends StatefulWidget {
  String userid;
  SearchScreenWidget({Key? key, required this.userid}) : super(key: key);

  @override
  _SearchScreenWidgetState createState() => _SearchScreenWidgetState();
}

class SearchsongsApi {
  static Future<List<Musics>> getBooks(String query) async {
    final url = Uri.parse('https://admin.koinoniaconnect.org/API/getAllMusics');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List song = json.decode(response.body);

      return song.map((json) => Musics.fromJson(json)).where((song) {
        final musictitleLower = song.musicTitle.toLowerCase();
        final artistname = song.artists![0].artistName.toLowerCase();
        //final categoryNameLower = song.categoryId.toLowerCase();
        final albumnameLower = song.albumName ?? "not set".toLowerCase();

        final searchLower = query.toLowerCase();

        return musictitleLower.contains(searchLower) ||
            albumnameLower.contains(searchLower) ||
            artistname.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}

class _SearchScreenWidgetState extends State<SearchScreenWidget> {
  //late SearchScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List<Musics> allSong = [];
  bool fetching = false;
  String query = '';
  Timer? debouncer;

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        labelText: 'Enter search keyword',
        onChanged: searchBook,
      );
  Widget nothingfound() => Align(
        alignment: Alignment.center,
        child: Text('keyword could not be found',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(53, 111, 188, 0.34),
                fontFamily: "Urbanist",
                fontSize: 16,
                fontWeight: FontWeight.w700)),
      );

  Widget buildBook(Musics music) => Container(
        child: GestureDetector(
          onTap: () => {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (ctx, animation, secondaryAnimation) =>
                    PlayingWidget2(
                  allMusicList: allSong,
                  singleMusic: music,
                  userid: widget.userid,
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
            ),
          },
          child: Row(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 10, 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    "https://admin.koinoniaconnect.org/" + music.musicImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(children: [
                Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 20, 0, 0),
                        child: Text(
                          music.musicTitle,
                          style: TextStyle(
                              //decoration: TextDecoration,
                              fontFamily: "Urbanist",
                              fontSize: 12,
                              color: Color.fromRGBO(0, 0, 0, 1.0),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Text(
                        music.categoryName,
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Open Sans',
                              color: Color(0xFF919191),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ),
                  ],
                ),
              ]),
            ],
          ),
        ),
      );
  Future searchBook(String query) async => debounce(() async {
        final song = await SearchsongsApi.getBooks(query);

        if (!mounted) return;

        setState(() {
          fetching = true;
          this.query = query;
          this.allSong = song;
        });
      });
  Future init() async {
    final song = await SearchsongsApi.getBooks(query);
    fetching = false;
    setState(() => this.allSong = song);
  }

  void init1() async {
    final song = await SearchsongsApi.getBooks("");
    fetching = false;
    setState(() => this.allSong = song);
  }

  @override
  void dispose() {
    //_model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: true,
          title: Text(
            'Discover',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).title2.override(
                  fontFamily: 'Urbanist',
                  color: Color(0xFF150734),
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              buildSearch(),
              Expanded(
                child: ListView.builder(
                  itemCount: allSong.length,
                  itemBuilder: (context, index) {
                    final songs = allSong[index];

                    return (allSong.length == 0)
                        ? nothingfound()
                        : buildBook(songs);
                  },
                ),
              ),
            ],
          ),
        ),
      );
}

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String labelText;

  const SearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.labelText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();
  var userid;

  Future<void> sharedprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // username = prefs.getString('firstname')!;
      userid = prefs.getString("userid")!;
      // profilepic = prefs.getString("profilepic")!;
    });
    print("current_user_id is " + userid);
  }

  @override
  void initState() {
    super.initState();
    sharedprefs();
  }

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(
        color: Color.fromRGBO(112, 112, 112, 0.50),
        fontFamily: "Urbanist",
        fontWeight: FontWeight.w700,
        fontSize: 12);
    final stylelabel = TextStyle(
        color: Color.fromRGBO(112, 112, 112, 0.50),
        fontFamily: "Urbanist",
        fontWeight: FontWeight.w700,
        fontSize: 14);
    final style = widget.text.isEmpty ? stylelabel : styleActive;

    return WillPopScope(
      onWillPop: () {
        print(
            'Backbutton pressed (device or appbar button), do whatever you want.');
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (ctx, animation, secondaryAnimation) =>
                NavBarPage(initialPage: 'HomePage', userid: userid),
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
        //trigger leaving and use own data

        //we need to return a future
        return Future.value(false);
      },
      child: SizedBox(
        width: 800,
        child: Container(
          // width: 200,
          height: 100,
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              filled: true,
              fillColor: Color.fromRGBO(163, 158, 255, 0.10),

              suffixIcon: Icon(
                Icons.search,
                size: 25,
                color: Color(0xFFF15C00),
              ),
              /*suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: style.color),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
              */
              labelText: widget.labelText,
              labelStyle: style,

              floatingLabelBehavior: FloatingLabelBehavior.never,
              floatingLabelAlignment:
                  FloatingLabelAlignment.center, // border: InputBorder.none,
            ),
            style: style,
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}
