import 'dart:convert';

class Movie {
  String title, discription, id, releaseDate, posterURL;

  Movie(
      this.discription, this.id, this.posterURL, this.releaseDate, this.title);
  Movie.fromJSON(Map<String, dynamic> json) {
    title = json['title'];
    discription = json['overview'];
    id = json['id'].toString();
    releaseDate = json['release_date'];
    posterURL = json['poster_path'];
  }

  String toString() {
    return '{"title": "${title.replaceAll('"', '\\"')}","id": "$id","release_date": "$releaseDate","poster_path":"$posterURL","overview": "${discription.replaceAll('"', '\\"')}"}';
  }

  Movie.fromJsonString(String input) {
    Map<String, dynamic> map = json.decode(input);

    title = map['title'];
    discription = map['overview'];
    id = map['id'];
    releaseDate = map['release_date'];
    posterURL = map['poster_path'];
  }
  Map<String, dynamic> toJSONEncodable() {
    Map<String, dynamic> map = new Map();
    map['title'] = title;
    map['overview'] = title;
    map['id'] = title;
    map['release_date'] = title;
    map['poster_path'] = title;
    return map;
  }
}
