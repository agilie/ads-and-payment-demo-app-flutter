import 'package:agilie_flutter_payments/model/models.dart';

abstract class GenresDs {

  Future<List<MovieGenre>> get allGenres;

  Future<List<MovieGenre>> getGenresForIds(List<int> ids);

  Future<void> saveGenres(List<MovieGenre> movies);
}