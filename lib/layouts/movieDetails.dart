import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/constants.dart';
import '../models/movieDetailsModel.dart';

class MovieDetails extends StatefulWidget {
  static const routeName = '/movieDetails';
  MovieDetails({Key key}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  String movieID;
  MovieDetails movieDetail;
  bool _initLoad = true;

  @override
  void didChangeDependencies() {
    // To make sure id is assigned only for one time (before initial render)
    if (_initLoad) {
      movieID = ModalRoute.of(context).settings.arguments;
      super.didChangeDependencies();
    }

    _initLoad = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _fetchMovieDetails(movieID),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return _movieDetails(snapshot.data);
              } else if (snapshot.hasError) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Somthing went wrong'),
                        FlatButton(
                          child: Text('Back'),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                    child: CupertinoActivityIndicator(
                  radius: 20.0,
                ));
              }
            }));
  }

  Future<MovieDetailsModel> _fetchMovieDetails(String movieID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var url = BASE_URL + '$movieID?api_key=' + API_KEY + '&language=en-US';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);

      var details = MovieDetailsModel.fromJson(extractedData);

      // Saving movie details
      await pref.setString(movieID, response.body);
      return details;
    } catch (error) {
      var cache = pref.getString(movieID);

      //if not found throw again
      if (cache == null) throw error;

      return MovieDetailsModel.fromJson(json.decode(cache));
    }
  }

  Widget _movieDetails(MovieDetailsModel movie) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.black45.withOpacity(0.7),
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(movie.title),
            background: CachedNetworkImage(
              imageUrl: IMAGE_URL + movie.posterPath,
              placeholder: (context, url) => SizedBox(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black45,
                ),
                width: 10,
                height: 10,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: double.infinity,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(16.0),
                  color: Colors.blue[200],
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: double.infinity,
                child: Text(
                  movie.overview,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Genres:',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blueAccent),
                ),
              ),
              Center(
                child: Wrap(
                    spacing: 8,
                    children: movie.genres.map((ele) {
                      return Chip(
                        labelPadding: EdgeInsets.all(2.0),
                        label: Text(
                          ele.name,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.black38,
                        elevation: 2.0,
                        shadowColor: Colors.grey[60],
                        padding: EdgeInsets.all(8.0),
                      );
                    }).toList()),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    text: TextSpan(
                        text: 'Popularity: ',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blueAccent),
                        children: <TextSpan>[
                          TextSpan(
                            text: movie.popularity.floor().toString(),
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                                color: Colors.blueAccent),
                          )
                        ]),
                  )),

              // Below size box is just for SliverAppBar demo
              // Scroll down to see
              SizedBox(
                height: 700,
              )
            ],
          ),
        ),
      ],
    );
  }
}
