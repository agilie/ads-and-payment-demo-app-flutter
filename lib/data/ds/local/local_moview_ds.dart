import 'dart:async';

import 'package:agilie_flutter_payments/data/ds/abs_ds_movie.dart';
import 'package:agilie_flutter_payments/errors.dart';
import 'package:agilie_flutter_payments/model/models.dart';

class LocalMovieDs extends MovieDs {
  List<Movie> movies = List();

  static LocalMovieDs _instance = LocalMovieDs._internal();
  factory LocalMovieDs() {
    return _instance;
  }
  LocalMovieDs._internal();

  @override
  Future<List<Movie>> get getMovies {
    return Future.error(NotImplementedException.inClass(this));
  }


  @override
  Future<MovieDetail> getMovieDetails(int id) {
    return Future.error(NotImplementedException.inClass(this));
  }

  @override
  Future<Movie> getMovie(int id) {
    return Future(() {
      return movies.firstWhere((movie) {
        return movie.id == id;
      }, orElse: () {
        throw NoItemError.noId(id);
      });
    });
  }

  @override
  Future<void> saveMovies(List<Movie> movies) {
    return Future.sync(() => this.movies.addAll(movies));
  }
}
