import 'package:flutter/material.dart';
import 'package:koinonia/appconfi.dart';
import 'package:koinonia/staticData.dart';

// ignore: must_be_immutable
class SucessPayment extends StatelessWidget {
  late AppConfig _appConfig;
  @override
  Widget build(BuildContext context) {
    _appConfig = AppConfig(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/sucesss.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: _appConfig.rHP(68.5),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
              height: _appConfig.rHP(8),
              width: _appConfig.rWP(72),
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.all(Radius.circular(30)),
//                border: Border.all(color: Colors.red),
                  color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
