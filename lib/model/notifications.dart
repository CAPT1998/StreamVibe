import 'package:flutter/material.dart';

import '../home_page/home_page_widget.dart';

class notification extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<notification> {
  int _counter = 0;
  late Future<getmsg> futureAlbum;

  void initState() {
    super.initState();
    //  getalbums();

    //  _model = createModel(context, () => HomePageModel());
    //getmsg();
    futureAlbum = featuredmessage();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        automaticallyImplyLeading: true,
        title: Row(children: [
          Text(
            'Notifications',
            style: TextStyle(color: Colors.black),
          )
        ]),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          FutureBuilder<getmsg>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.data!.notification.isEmpty) {
                print(snapshot.data!.notification.isEmpty);
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 2.5,
                      horizontal: MediaQuery.of(context).size.width / 4,
                    ),
                    child: Text(
                      'No new Notification',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              } else if (snapshot.data!.notification.isNotEmpty) {
                return Container(
                  width: isTablet
                      ? MediaQuery.of(context).size.width * 0.6
                      : MediaQuery.of(context).size.width,
                  height: isTablet
                      ? MediaQuery.of(context).size.height * 0.8
                      : MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                    child: Text(
                      "-> " + snapshot.data!.notification,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ]),
      ),
    );
  }
}
