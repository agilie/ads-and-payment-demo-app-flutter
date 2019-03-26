import 'dart:async';

import 'package:agilie_flutter_payments/data/movie_repository.dart';
import 'package:agilie_flutter_payments/model/models.dart';

class MoviesListVm {
  Stream<List<Movie>> moviesStream;
  MovieRepository _movieRepository;

  MoviesListVm(this._movieRepository);

  initVm(StreamController<List<Movie>> streamController) async {
    moviesStream = streamController.stream;
    _movieRepository.getMovies().then((list) {
      streamController.add(list);
    });
  }

}
