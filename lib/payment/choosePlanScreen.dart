import 'package:flutter/material.dart';
import 'package:koinonia/Api/Networkutils.dart';
import 'package:koinonia/appconfi.dart';
import 'package:koinonia/model/package.dart';
import 'package:koinonia/payment/paymentscreen.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import '../enterverficationcode/enterverficationcode_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChoosePlanScreen extends StatefulWidget {
  final String userid; // declare userid as a parameter

  const ChoosePlanScreen({Key? key, required this.userid})
      : super(key: key); // define constructor
  @override
  _ChoosePlanScreenState createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  late AppConfig _appConfig;
  bool isone = false, istwo = false, isthre = false, isfour = true;
  Map<String, dynamic>? paymentIntent;

  int i = 3;

  String rate = "\$ ";
  String id = "";
  String mrate = "\$ 4.99";
  void selection(int i) {
    if (i == 1) {
      isone = true;
      isthre = false;
      istwo = false;
      isfour = false;
      rate = pckglist[0].packageprice;
      mrate = pckglist[0].totalpackageprice;
      id = pckglist[0].packageid;
    } else if (i == 2) {
      isone = false;
      isthre = false;
      istwo = true;
      isfour = false;
      rate = pckglist[1].packageprice;
      mrate = pckglist[1].totalpackageprice;
      id = pckglist[1].packageid;
    } else if (i == 3) {
      isone = false;
      isthre = true;
      istwo = false;
      isfour = false;
      rate = pckglist[2].packageprice;
      mrate = pckglist[2].totalpackageprice;
      id = pckglist[2].packageid;
    } else if (i == 4) {
      isone = false;
      isthre = false;
      istwo = false;
      isfour = true;
      rate = pckglist[3].packageprice;
      mrate = pckglist[3].totalpackageprice;
    }
    setState(() {});
  }

  late Networkutils networkutils;
  @override
  void initState() {
    super.initState();
    networkutils = Networkutils();
    getpackage();
  }

// ignore: deprecated_member_use
  List<PackagesItem> pckglist = [];

  void getpackage() async {
    await networkutils.getpackage();
    pckglist = Packages.myPackgelist;
    setState(() {
      rate = pckglist[3].packageprice;
      mrate = pckglist[3].totalpackageprice;
      id = pckglist[3].packageid;
    });
  }

  Future<void> updatePaymentAndExpiry(String userId, String pkgid) async {
    var url = Uri.parse(
        'https://admin.koinoniaconnect.org/API/updatePaymentAndExpiry');
    var response = await http.post(url, body: {
      'package_id': pkgid,
      'user_id': widget.userid,
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> makePayment() async {
    String price = rate.replaceAll(RegExp(r'[^0-9]'), '');

    try {
      paymentIntent = await createPaymentIntent(price, 'USD');
      log("paymentIntent:::::::::${paymentIntent}");
      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            // customFlow: true,

            merchantDisplayName: 'Koinonia user payment',
            // customerId: 'cus_NjsJj78KUlQoN6',
            paymentIntentClientSecret: paymentIntent!['client_secret'],
          ))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) =>  AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));
        updatePaymentAndExpiry(widget.userid, id);
        Future.delayed(Duration(seconds: 2));
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Enjoy unlimited Streaming and Downloading without ads'),
            duration: Duration(seconds: 2),
          ),
        );
        // paymentIntent = {};
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('DErrrrrr$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    print("In Price");
    final dio = Dio();

    try {
      print("In Try");

      var response = await dio.post("https://api.stripe.com/v1/payment_intents",
          // url("https://api.stripe.com/v1/prices"),
          // queryParameters: {},
          options: Options(headers: {
            'Authorization':
                'Bearer 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',
            'Content-Type': 'application/x-www-form-urlencoded',
          }),
          queryParameters: {
            'amount': calculateAmount(amount),
            'currency': currency,
            //'customer': 'cus_NjsJj78KUlQoN6',
            'payment_method_types[]': 'card',
          });

      if (response.statusCode == 200) {
        print(response.data);

        print("Ram::::::::::::Success");
      } else {
        print(response.data);
      }
      return response.data;
    } catch (e) {
      print("In Try");

      print(e);
      print("Ram::::::::::::False");
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  @override
  Widget build(BuildContext context) {
    _appConfig = AppConfig(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Choose Plan',
                style: TextStyle(
                  fontSize: _appConfig.rHP(3),
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: _appConfig.rHP(47),
                ),
                Container(
                  height: _appConfig.rHP(38),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              selection(1);
                              i = 0;
                            },
                            child: Container(
                              child: !isone
                                  ? Image.asset(
                                      "assets/images/year_1.png",
                                      height: _appConfig.rHP(10),
                                      width: _appConfig.rWP(40),
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      "assets/images/year_1_pressed.png",
                                      height: _appConfig.rHP(10),
                                      width: _appConfig.rWP(40),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              selection(2);
                              i = 1;
                            },
                            child: Container(
                              child: !istwo
                                  ? Image.asset(
                                      "assets/images/month_6.png",
                                      height: _appConfig.rHP(10),
                                      width: _appConfig.rWP(40),
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      "assets/images/pressed6.png",
                                      height: _appConfig.rHP(10),
                                      width: _appConfig.rWP(40),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              selection(3);
                              i = 2;
                            },
                            child: Container(
                              child: !isthre
                                  ? Image.asset(
                                      "assets/images/month_3.png",
                                      height: _appConfig.rHP(10),
                                      width: _appConfig.rWP(40),
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      "assets/images/month_3_pressed.png",
                                      height: _appConfig.rHP(10),
                                      width: _appConfig.rWP(40),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              selection(4);
                              i = 3;
                            },
                            child: Container(
                              child: !isfour
                                  ? Image.asset(
                                      "assets/images/month_1.png",
                                      height: _appConfig.rHP(10),
                                      width: _appConfig.rWP(40),
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      "assets/images/month_1_pressed.png",
                                      height: _appConfig.rHP(10),
                                      width: _appConfig.rWP(40),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Your Total Cost is " + rate,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: AlignmentDirectional(0, 0.85),
                            child: SizedBox(
                              width: 250,
                              child: FFButtonWidget(
                                onPressed: () async {
                                  if (widget.userid == '3') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Please login'),
                                    ));
                                  } else {
                                    await makePayment();
                                  }
                                },
                                text: 'Pay',
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
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
