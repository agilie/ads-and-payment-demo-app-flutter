import 'dart:async';
import 'dart:convert';

import 'package:agilie_flutter_payments/data/ds/abs_ds_movie.dart';
import 'package:agilie_flutter_payments/errors.dart';
import 'package:agilie_flutter_payments/model/models.dart';
import 'package:http/http.dart' as http;

import 'tmdb_web_helper.dart' as tmdbHelper;

class RemoteMovieDs extends MovieDs {
  static RemoteMovieDs _instance = RemoteMovieDs._internal();

  factory RemoteMovieDs() {
    return _instance;
  }

  RemoteMovieDs._internal();

  @override
  Future<List<Movie>> get getMovies async {
    http.Response response =
        await tmdbHelper.get(tmdbHelper.getUpcomingMoviesUri());

    return (json.decode(response.body)["results"] as List).map((it) {
      return Movie.fromJson(it);
    }).toList();
  }

  @override
  Future<Movie> getMovie(int id) {
    return Future.error(NotImplementedException.inClass(this));
  }

  @override
  Future<MovieDetail> getMovieDetails(int id) async {
    http.Response response =
        await tmdbHelper.get(tmdbHelper.getMovieDetail(id));

    print("MovieDetails BODY ${response.body}");

    return MovieDetail.fromJson(json.decode(response.body));
  }

  @override
  Future<Function> saveMovies(List<Movie> movies) {
    return Future.error(NotImplementedException.inClass(this));
  }
}
