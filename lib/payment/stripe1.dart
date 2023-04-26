import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class pay extends StatefulWidget {
  const pay({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<pay> {
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Center(
        child: TextButton(
          child: const Text('Make Payment'),
          onPressed: () async {
            await makePayment();
          },
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('34', 'USD');
      log("paymentIntent:::::::::${paymentIntent}");
      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            // customFlow: true,

            merchantDisplayName: 'waqas',
            customerId: 'cus_NjsJj78KUlQoN6',
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
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
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

        paymentIntent = {};
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
                'Bearer sk_test_51MtoUbE6iO4b5Cp49FpPHogHkDfjCHtEslNF6YbXx7YeEgYLbyWPG3M89rsrjtCXPBX3FLjm9WFQFWu8sBJNASvA00fS0P53pd',
            'Content-Type': 'application/x-www-form-urlencoded',
          }),
          queryParameters: {
            'amount': calculateAmount(amount),
            'currency': currency,
            'customer': 'cus_NjsJj78KUlQoN6',
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
}
