import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siplyAssignment/utility/constants.dart';

import '../models/movieDetailsModel.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieDetails extends StatefulWidget {
  static const routeName = '/movieDetails';
  MovieDetails({Key key}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  String movieID;
  MovieDetails movieDetail;
  static const image_url = 'https://image.tmdb.org/t/p/w500/';

  @override
  void initState() {
    // Future.delayed(Duration.zero, () {
    //   movieID = ModalRoute.of(context).settings.arguments;
    //   // Provider.of<MovieDetailsProvider>(context).fetchMovieDetails(movieID);
    // });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    movieID = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
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
                return CupertinoActivityIndicator();
              }
            }));
  }

  Widget show(MovieDetailsModel movie) {
    return Center(child: Text(movie.title));
  }

  Future<MovieDetailsModel> _fetchMovieDetails(String movieID) async {
    var url = BASE_URL + '$movieID?api_key=' + API_KEY + '&language=en-US';

    final response = await http.get(url);
    final extractedData = json.decode(response.body);

    var details = MovieDetailsModel.fromJson(extractedData);
    return details;
  }

  Widget _movieDetails(MovieDetailsModel movie) {
    //var movie = Provider.of<MovieDetailsProvider>(context).details;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.black45.withOpacity(0.7),
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(movie.title),
            background: CachedNetworkImage(
              imageUrl: image_url + movie.posterPath,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: double.infinity,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SizedBox(height: 10),
              // Text(
              //   '\$${movie.popularity}',
              //   style: TextStyle(
              //     color: Colors.grey,
              //     fontSize: 20,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
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
            ],
          ),
        ),
      ],
    );
  }
}
