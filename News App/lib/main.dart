import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/Android_Run/MainAndroidRoute.dart';
import 'package:news_app/IOS_Run/MainIOSRoute.dart';
import 'package:news_app/Web_Run/MainWebRoute.dart';
import 'package:news_app/Windows_Run/MainWindowsRoute.dart';

void main() {
  runApp(checkPlatform());
}

Widget checkPlatform() {
  if(kIsWeb)
    return ProviderScope(child: MainWebRoute());
  else if(Platform.isAndroid)
    return ProviderScope(child: MainAndroidRoute());
  else if(Platform.isIOS)
    return  ProviderScope(child: MainIosRoute());
  else if(Platform.isWindows)
    return  ProviderScope(child: MainWindowsRoute());
}