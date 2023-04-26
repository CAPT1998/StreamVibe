import 'package:flutter/material.dart';
import 'package:koinonia/appconfi.dart';
import 'package:koinonia/model/package.dart';
import 'package:koinonia/payment/payment.dart';
import 'package:koinonia/staticData.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  List<PackagesItem> pckglist;
  int i;
  PaymentScreen(this.pckglist, this.i);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late AppConfig _appConfig;
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
                'Choice Payment Type',
                style: TextStyle(
                  fontSize: _appConfig.rHP(3),
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/payment-page.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: <Widget>[
            // Column(
            //   children: <Widget>[
            //     SizedBox(
            //         // height: _appConfig.rHP(20),
            //         ),
            //     GestureDetector(
            //       onTap: () {
            //         // Navigator.of(context).pushReplacement(new MaterialPageRoute(
            //         //     builder: (context) => new WbView(
            //         //         NetworkUtil.userid,
            //         //         widget.pckglist[widget.i].package_id,
            //         //         widget.pckglist[widget.i].total_package_price)));
            //       },
            //       child: Container(
            //         // height: _appConfig.rHP(21),
            //         child: Container(),
            //         color: Colors.transparent,
            //       ),
            //     )
            //   ],
            // ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(
                      builder: (context) => Payment(
                        '1',
                        widget.pckglist[widget.i].packageid,
                        widget.pckglist[widget.i].totalpackageprice,
                      ),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.09,
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Color.fromRGBO(0, 239, 215, 1),
                      //     Color.fromRGBO(153, 92, 228, 1),
                      //   ],
                      // ),
                      ),
                  child: Text(
                    widget.pckglist[widget.i].totalpackageprice,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
