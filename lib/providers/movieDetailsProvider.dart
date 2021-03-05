// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';
// import 'package:provider/provider.dart';
// import '../models/movieDetailsModel.dart';

// class MovieDetailsProvider with ChangeNotifier {
//   MovieDetailsModel details;

//   Future<MovieDetailsModel> fetchMovieDetails(String movieID) async {
//     var url =
//         'https://api.themoviedb.org/3/movie/$movieID?api_key=34a9c8f2da697801997f9d61c4dd82cd&language=en-US';

//     try {
//       final response = await http.get(url);
//       final extractedData = json.decode(response.body);

//       details = MovieDetailsModel.fromJson(extractedData);
//       notifyListeners();

//       return details;
//     } catch (error) {
//       details = null;
//       notifyListeners();
//       return null;
//     }
//   }
// }
