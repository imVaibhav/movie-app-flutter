import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utility/constants.dart';
import '../models/movieModel.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context)
            .pushNamed('/movieDetails', arguments: movie.id.toString())
      },
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(0.0),
                child: new Container(
                  margin: const EdgeInsets.all(16.0),
                  child: new Container(
                    width: 70.0,
                    height: 70.0,
                    child: CachedNetworkImage(
                      imageUrl: IMAGE_URL + movie.posterURL,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ),
              new Expanded(
                  child: new Container(
                margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: new Column(
                  children: [
                    new Text(
                      movie.title,
                      style: new TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    new Padding(padding: const EdgeInsets.all(2.0)),
                    new Text(
                      movie.discription,
                      maxLines: 3,
                      style: new TextStyle(
                          color: const Color(0xff8785A4), fontFamily: 'Roboto'),
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              )),
            ],
          ),
          new Container(
            width: double.infinity,
            height: 0.5,
            color: const Color(0x000000).withOpacity(1),
            margin: const EdgeInsets.all(16.0),
          )
        ],
      ),
    );
  }
}
