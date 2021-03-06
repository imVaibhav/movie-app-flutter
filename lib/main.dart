import 'package:flutter/material.dart';
import './layouts/home.dart';
import './layouts/movieDetails.dart';
import './layouts/splashScreen.dart';
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
        ),
      ],
      child: MaterialApp(
        title: 'IMDb',
        routes: {
          Home.routeName: (context) => Home(),
          MovieDetails.routeName: (context) => MovieDetails(),
        },
        home: SplashScreen(),
      ),
    );
  }
}
