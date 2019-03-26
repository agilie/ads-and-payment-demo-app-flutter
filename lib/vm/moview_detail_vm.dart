import 'dart:async';

import 'package:agilie_flutter_payments/data/genres_repository.dart';
import 'package:agilie_flutter_payments/data/movie_repository.dart';
import 'package:agilie_flutter_payments/model/models.dart';
import 'package:tuple/tuple.dart';

class MovieDetailsVm {
  MovieRepository _movieRepository;
  GenresRepository _genresRepository;

  int movieId;
  Stream<Tuple2<Movie, MovieDetail>> moviesStream;

  Movie movie;

  MovieDetailsVm(this._movieRepository, this._genresRepository, this.movieId);

  initVm(StreamController<Tuple2<Movie, MovieDetail>> streamController) async {
    moviesStream = streamController.stream;

    _postMovieDetailPair(
      await _movieRepository.getMovie(movieId),
      await _movieRepository.getMovieDetail(movieId),
      streamController,
    );
  }

  void _postMovieDetailPair(Movie movie, MovieDetail movieDetail,
      StreamController<Tuple2<Movie, MovieDetail>> streamController) {
    _genresRepository.getGenresForIds(movie.genresIds).then((genres) {
      movie.genres = genres;
      streamController.add(Tuple2(movie, movieDetail));
    });
  }
}
