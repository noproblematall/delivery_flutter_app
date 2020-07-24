import 'package:flutter/material.dart';
import 'package:transporter/src/page/Home.dart';
import 'package:transporter/src/page/Login.dart';

void main() => runApp(MaterialApp(
      initialRoute: Login.routeName,
      routes: {
        Login.routeName: (context) => Login(),
        Home.routeName: (context) => Home(args: ModalRoute.of(context).settings.arguments)
      },
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}
