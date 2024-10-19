import 'package:flutter/material.dart';
import 'package:readeth/widgets/app_drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Readeth',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xffFFF279),
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: AppDrawer(),
    );
  }
}
