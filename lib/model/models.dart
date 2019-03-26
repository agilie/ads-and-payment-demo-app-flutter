import 'package:google_maps_flutter/google_maps_flutter.dart';

class Cinema {
  int id;
  String name;
  City city;
  LatLng coordinates;
  String logoUrl;

  Cinema(
    this.id,
    this.name,
    this.city,
    this.coordinates,
    this.logoUrl,
  );
}

class City {
  int id;
  String name;
  LatLng center;

  City(
    this.id,
    this.name,
    this.center,
  );
}

class Movie {
  int id;
  String title;
  String overview;

  List<int> genresIds;
  final List<MovieGenre> genres = List();

  set genres(List<MovieGenre> list) {
    genres.clear();
    genres.addAll(list);
  }

  DateTime releaseDate;
  double averageVote;
  String backDrop;
  String poster;

  Movie(this.id, this.title, this.overview, this.genresIds, this.releaseDate,
      this.averageVote, this.backDrop, this.poster);

  factory Movie.fromJson(Map<String, dynamic> jsonObj) {
    return new Movie(
        jsonObj["id"],
        jsonObj["title"],
        jsonObj["overview"],
        (jsonObj["genre_ids"] as List<dynamic>).map((it) {
          return it as int;
        }).toList(),
        DateTime.parse(jsonObj["release_date"].toString().replaceAll("-", "")),
        double.parse(jsonObj["vote_average"].toString()),
        jsonObj["backdrop_path"],
        jsonObj["poster_path"]);
  }
}

class MovieGenre {
  int id;
  String name;

  MovieGenre(this.id, this.name);

  factory MovieGenre.fromJson(Map<String, dynamic> json) {
    return MovieGenre(
      json["id"],
      json["name"],
    );
  }
}

class MovieDetail {
  int id;
  String title;
  String tagline;
  String overview;
  DateTime releaseDate;
  String homepage;
  String backdropPath;
  String posterPath;

  MovieDetail(this.id, this.title, this.tagline, this.overview,
              this.releaseDate, this.homepage, this.backdropPath,
              this.posterPath);

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      json["id"],
      json["title"],
      json["tagline"],
      json["overview"],
      DateTime.parse(json["release_date"].toString().replaceAll("-", "")),
      json["homepage"],
      json["backdrop_path"],
      json["poster_path"]
      );
  }

}
