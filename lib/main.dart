import 'package:flutter/material.dart';
import './layouts/home.dart';
import 'package:provider/provider.dart';
import 'providers/movieProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieProvider(),
        )
      ],
      child: MaterialApp(
        title: 'IMDb',
        routes: {
          // '/': (context) => SpalshScreen(),
          Home.routeName: (context) => Home(),
          // '/movieDetails': (context) => MovieDetails(),
        },
        // home: Scaffold(
        //   appBar: AppBar(
        //     title: Text('Material App Bar'),
        //   ),
        //   body: Center(
        //     child: Container(
        //       child: Text('Hello World'),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
