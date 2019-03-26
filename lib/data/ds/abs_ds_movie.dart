import 'package:agilie_flutter_payments/model/models.dart';

abstract class MovieDs {

  Future<List<Movie>> get getMovies;

  Future<Movie> getMovie(int id);

  Future<MovieDetail> getMovieDetails(int id);

  Future<void> saveMovies(List<Movie> movies);

}