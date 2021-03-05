import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:siplyAssignment/utility/constants.dart';
import '../models/movieModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> movies = [];

  Future<void> fetchMovies() async {
    // Make network call and store it in _movies list
    // Calculate page no by dividing current list length by total items per page
    var page = 1;
    if (movies.length > 0) {
      page = (movies.length / 20).round() + 1;
    }
    // if request succuseful store it in localStorage
    //    - update localstoage

    // if not  Retrive from localstorage
    // store it in _movies list

    var url = BASE_URL +
        'now_playing?api_key=' +
        API_KEY +
        '&language=en-US&page=$page';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);

      if (extractedData['results'] == null) {
        return;
      }

      final List<Movie> tempList = [];
      extractedData['results'].forEach((element) {
        tempList.add(Movie.fromJSON(element));
      });

      movies = [...movies, ...tempList];
      notifyListeners();

      _writeToLocalStorage();
    } catch (error) {
      if (movies.isEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Fetching list from storage if not found then empty list
        var list = prefs.getStringList('movie_list') ?? [];

        list.forEach((element) {
          print(element);
          movies.add(Movie.fromJsonString(element));
        });
      }
      notifyListeners();
    }
  }

  Movie getElementAt(int index) {
    return movies[index];
  }

  void _writeToLocalStorage() async {
    // Remove the old list
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('movie_list');
    var list = movies.map((item) {
      return item.toString();
    }).toList();

    //Adding refreshed list
    prefs.setStringList('movie_list', list);
  }
}
