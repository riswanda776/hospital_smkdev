import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FeedbackWebview extends StatefulWidget {
  @override
  _FeedbackWebviewState createState() => _FeedbackWebviewState();
}

class _FeedbackWebviewState extends State<FeedbackWebview> {
  String webUrl =
      "https://docs.google.com/forms/d/e/1FAIpQLSewEjiqay2ZQGwmN7rqt5Igw3QTN_-fsOnoBdtnjpAJBHW2JQ/viewform?usp=sf_link";

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Feedback", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Get.back(),
        ),
      ),
      body: WebView(
        initialUrl: webUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
