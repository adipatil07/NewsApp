import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class ArticleView extends StatefulWidget{
  final String blogurl;
  ArticleView({required this.blogurl});
  @override
  _ArticleViewState createState()=> _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView>{
  ///final Completer<WebViewController> _completer = Completer<WebViewController>();
  late WebViewController controller;
 /// final controller = WebViewController()..setJavaScriptMode(JavaScriptMode.disabled)..loadRequest("https://pub.dev/documentation/webview_flutter/latest/webview_flutter/WebViewWidget-class.html" as Uri);
  @override
  void initState() {
    super.initState();
    // Initialize the controller in the initState method
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.blogurl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("Flutter"),
        Text("News",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
            ),
          ],
        ),
          actions: <Widget>[
            Opacity(opacity: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.save),
            ),)
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        child: WebViewWidget(controller: controller),
      )
    );

  }
}