import 'dart:convert';

import 'package:koinonia/likedsongs.dart';
import '../ministers/ministers_widget.dart';
import '../flutter_flow/flutter_flow_ad_banner.dart';
import '../flutter_flow/flutter_flow_audio_player.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/categorymodel.dart';
import '../model/musics.dart';
import '../model/viewAlbum.dart';

import 'package:http/http.dart' as http;
import 'dart:async';

import '../model/viewArtist.dart';
import 'categorymusics.dart';

class homepagecategorywidget extends StatefulWidget {
  const homepagecategorywidget({Key? key}) : super(key: key);

  @override
  _homepagealbumwidgetState createState() => _homepagealbumwidgetState();
}

class getAllcategoryApi {
  static Future<List<Categorymodel>> getallalbums() async {
    //print("HElloworld");

    final url =
        Uri.parse('https://admin.koinoniaconnect.org/API/getAllCategories');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List music = json.decode(response.body);

      return music.map((json) => Categorymodel.fromJson(json)).toList();
      //artistinfo.map((json) => Artists.fromJson(json)).toList();
    }
    throw Exception();
  }
}

class _homepagealbumwidgetState extends State {
  List<Categorymodel> category = [];
  List<Artists> artistinfo = [];
  List allalbumimage = [];
  List allMusicsinfo = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List AllArtistsinfo = [];
  List<String> images = [
    "assets/images/c1.png",
    "assets/images/c2.png",
    "assets/images/c3.png",
    "assets/images/c4.png",
    "assets/images/c1.png",
    "assets/images/c2.png",
    "assets/images/c3.png",
    "assets/images/c4.png",
  ];
  Future init1() async {
    final category = await getAllcategoryApi.getallalbums();
    if (!mounted) return;

    setState(() => this.category = category);
    setState(() {
      this.artistinfo = artistinfo;
    });
    print("hello world");
    //  _model = createModel(context, () => AlbumsModel());
    if (!mounted) return;
  }

  @override
  void initState() {
    init1();
    super.initState();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  Widget buildAlbum(Categorymodel music, int) => Padding(
        padding: MediaQuery.of(context).size.width > 600
            ? EdgeInsetsDirectional.fromSTEB(0, 0, 10, 100)
            : EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
        child: Container(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 300),
                  pageBuilder: (ctx, animation, secondaryAnimation) =>
                      categorymusic(
                          catid: music.categoryId, catname: music.categoryName),
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
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                //  borderRadius: BorderRadius.circular(10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    // ignore: prefer_interpolation_to_compose_strings
                    "https://admin.koinoniaconnect.org/" + music.categoryImage,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 4
                      : 2, // Change crossAxisCount to 4 on larger screens
                  childAspectRatio:
                      MediaQuery.of(context).size.width > 600 ? 0.8 : 1.9,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                // scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemCount: category.length > 2
                    ? 2
                    : category
                        .length, // Limit to 2 if there are more than 2 items
                itemBuilder: (context, index) {
                  final Musics = category[index];

                  //final Artists = artistinfo[index];

                  return buildAlbum(Musics, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
