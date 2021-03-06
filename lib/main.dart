
import 'package:flutter/material.dart';

import './layouts/home_layout.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stackoverflow',
      routes: {
        Home.routeName : (context) => Home(),
       
      },
      
    );
  }
}