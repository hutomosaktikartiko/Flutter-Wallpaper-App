import 'package:flutter/material.dart';
import 'package:wallyapp/config/config.dart';
import 'package:wallyapp/pages/sign_in_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: primaryColor,
          fontFamily: "productsans"),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignInPage(),
    );
  }
}
