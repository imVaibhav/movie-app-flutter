import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:siplyAssignment/utility/constants.dart';
import '../models/movieModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> movies = [];

  Future<void> fetchMovies() async {
    // Make network call and store it in movies list
    // Calculate next page by dividing current list length by total items in page
    var page = 1;
    if (movies.length > 0) {
      page = (movies.length / 20).round() + 1;
    }

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

      // update movies list
      movies = [...movies, ...tempList];
      notifyListeners();

      // Update localStorage
      _writeToLocalStorage();
    } catch (error) {
      // Request Failed
      // Retrieve list from localstorage
      // store it in movies list
      if (movies.isEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        
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
