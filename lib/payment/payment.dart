import 'dart:async';

import 'package:flutter/material.dart';
import 'package:koinonia/Api/Networkutils.dart';
import 'package:koinonia/appconfi.dart';
import 'package:koinonia/payment/sucesspayment.dart';

// ignore: must_be_immutable
class Payment extends StatefulWidget {
  String userid, pkgid, totlprice;

  Payment(this.userid, this.pkgid, this.totlprice);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  //final flutterWebViewPlugin = FlutterWebviewPlugin();

  String selectedUrl =
      'http://appiconmakers.com/demoMusicPlayer/API/getStripePaymentScreen';

  final _history = [];
  // ignore: unused_field
  late StreamSubscription<String> _onUrlChanged;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late AppConfig _appConfig;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
