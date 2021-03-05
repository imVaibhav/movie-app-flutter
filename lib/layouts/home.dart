import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siplyAssignment/models/movieModel.dart';
import 'package:siplyAssignment/widget/movie_card.dart';
import '../providers/movieProvider.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _isLoading = false;
  var _initLoad = true;
  @override
  void didChangeDependencies() {
    // Display loading screen before fetching movies list

    if (_initLoad) {
      setState(() {
        _isLoading = true;
      });

      // Fetching list of movies
      Provider.of<MovieProvider>(
        context,
        listen: false,
      ).fetchMovies().then((_) => {
            setState(() {
              // To remove loading widget
              _isLoading = false;
            })
          });
    }
    _initLoad = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Text('R'),
          onPressed: () => {
            Provider.of<MovieProvider>(
              context,
              listen: false,
            ).fetchMovies().then((_) => {
                  setState(() {
                    // To remove loading widget
                    _isLoading = false;
                  })
                })
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[700],
          centerTitle: true,
          title: Text('Now Playing'),
        ),
        body: _isLoading
            //show spinner if fetching
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _displayList());
  }

  Widget _displayList() {
    // Later use lazy loading package
    return LazyLoadScrollView(
      scrollOffset: 200,
      onEndOfPage: () => Provider.of<MovieProvider>(
        context,
        listen: false,
      ).fetchMovies().then((_) => {
            setState(() {
              // To remove loading widget
              _isLoading = false;
            })
          }),
      child: ListView.builder(
        itemCount: Provider.of<MovieProvider>(context).movies.length,
        itemBuilder: (context, index) {
          return MovieCard(
              Provider.of<MovieProvider>(context).getElementAt(index));
        },
      ),
    );
  }
}
