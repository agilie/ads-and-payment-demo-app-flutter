import 'dart:async';

import 'package:agilie_flutter_payments/data/ds/abs_genre_ds.dart';
import 'package:agilie_flutter_payments/errors.dart';
import 'package:agilie_flutter_payments/model/models.dart';

class LocalGenresDs extends GenresDs {
  static LocalGenresDs _instance = LocalGenresDs._internal();


  factory LocalGenresDs() {
    return _instance;
  }

  LocalGenresDs._internal();

  final List<MovieGenre> genres = List();

  @override
  Future<List<MovieGenre>> get allGenres {
    return Future.sync(() => genres);
  }

  @override
  Future<List<MovieGenre>> getGenresForIds(List<int> ids) {
    return Future(() {
      if (!ids.every(
        (id) {
          return genres.any((it) {
            return it.id.compareTo(id) == 0;
          });
        },
      )) {
        return Future.error(NoItemError(
            "local storage does not contain all of required genres"));
      }
      return genres.where((it) => ids.contains(it.id)).toList();
    });
  }

  @override
  Future<void> saveGenres(List<MovieGenre> movies) {
    return Future(() {
      this.genres.addAll(movies);
      return 0;
    });
  }
}
