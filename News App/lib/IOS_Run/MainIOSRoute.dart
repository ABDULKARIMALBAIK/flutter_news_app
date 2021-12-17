import 'package:flutter/cupertino.dart';

class MainIosRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeOrange
      ),
      title: "News App",
      debugShowCheckedModeBanner: true,
      home: MainIosPage(),
    );
  }

}

class MainIosPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MainIosPageState();
}

class _MainIosPageState extends State<MainIosPage>{
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold();
  }
}