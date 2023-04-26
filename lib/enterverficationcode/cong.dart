import 'package:flutter/material.dart';

class cong extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
@override
init(){
Future.delayed(Duration(milliseconds: 100), () {
  // Do something
});
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
otp(){

}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Align(
          alignment: Alignment.center,
          child: Image.asset("assets/images/cong.png"),
          
        ),
      ),
    );
  }
}
