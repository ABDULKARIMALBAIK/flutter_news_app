import 'dart:async';
import 'dart:html';
import 'dart:io' as io;

import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/State/state_managment.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_riverpod/all.dart';

import 'dart:ui' as ui;

class MyNewDetail extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _MyNewDetailState();
  
}

class _MyNewDetailState extends State<MyNewDetail>{

  double progress = 0;
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   if(io.Platform.isAndroid)
  //     WebView.platform = SurfaceAndroidWebView();
  // }
  //
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(0xFFA51234)));

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(icon: Icon(Icons.arrow_back), color: Colors.black, alignment: Alignment.topLeft, onPressed: () => Navigator.pop(context))
                  ],
                ),
                Expanded(
                  child: EasyWebView(
                    src: context.read(urlState).state,
                    onLoaded: () {
                      //Some Code
                    },),

                  //showWebView(),   //Old code
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showWebView() {

    if(kIsWeb){
      print('run web');
      IFrameElement iframeElement = IFrameElement()
        ..src = context.read(urlState).state
        ..style.border = 'none'
        ..onLoad.listen((event) {
          // perform Code...
        });

      //Ignore the error...
      ui.platformViewRegistry.registerViewFactory(
        'webpage', (int viewId) => iframeElement,
      );

      return Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: HtmlElementView(viewType: 'webpage'),
          ),
        ),
      );
    }

    else {
      return WebView(
        onWebViewCreated: (controller){
          _controller.complete(controller);
        },
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: context.read(urlState).state,);
    }
  }
  
}