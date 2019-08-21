import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/home_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QRReader',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) =>HomePage(),

      },
      //tema centrazilado afecta a toda la aplicacion
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
    );
  }
}