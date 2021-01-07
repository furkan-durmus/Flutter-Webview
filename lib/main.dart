import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Güney Botanik',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home', url: 'https://www.guneybotanik.com/'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.url});

  final String title;
  final String url;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebViewController _controller;

  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();
  //Make sure this function return Future<bool> otherwise you will get an error
  Future<bool> _onWillPop(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => launch("tel://05325668502"),
          backgroundColor: Color(0xff7DAF0D),
          child: Icon(
            Icons.call,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
            child: WebView(
          key: UniqueKey(),
          onWebViewCreated: (WebViewController webViewController) {
            _controllerCompleter.future.then((value) => _controller = value);
            _controllerCompleter.complete(webViewController);
          },
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.url,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('mailto:')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            } else {
              return NavigationDecision.navigate;
            }
          },
        )),
      ),
    );
  }
}
