import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class aboutus extends StatefulWidget {
  const aboutus({Key? key}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<aboutus> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://www.google.com'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webpage'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
