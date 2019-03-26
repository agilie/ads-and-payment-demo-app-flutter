import 'dart:async';

import 'package:agilie_flutter_payments/data/ds/abs_ds_movie.dart';
import 'package:agilie_flutter_payments/errors.dart';
import 'package:agilie_flutter_payments/model/models.dart';

class MovieRepository {
  MovieDs _remoteDs;
  MovieDs _localDs;


  MovieRepository(this._remoteDs, this._localDs);

  Future<List<Movie>> getMovies() {
    return _remoteDs.getMovies.then((it) {
      return _localDs.saveMovies(it).then((v) => it);
    });
  }

  Future<MovieDetail> getMovieDetail(int id) {
    return _remoteDs.getMovieDetails(id);
  }

  Future<Movie> getMovie(int id) {
    return _localDs.getMovie(id).catchError(
      (err) {
        if (err is NoItemError) {
          return getMovies().then(
            (movies) => movies.firstWhere(
                  (movie) => movie.id == id,
                  orElse: () {
                    throw NoItemError.noId(id);
                  },
                ),
          );
        } else
          throw err;
      },
    );
  }
}
