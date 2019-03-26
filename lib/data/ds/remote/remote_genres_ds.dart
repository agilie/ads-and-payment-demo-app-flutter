import 'dart:async';
import 'dart:convert';

import 'package:agilie_flutter_payments/data/ds/abs_genre_ds.dart';
import 'package:agilie_flutter_payments/errors.dart';
import 'package:agilie_flutter_payments/model/models.dart';
import 'package:http/http.dart' as http;

import 'tmdb_web_helper.dart' as tmdbHelper;

class RemoteGenresDs extends GenresDs {
  static RemoteGenresDs _instance = RemoteGenresDs._internal();

  factory RemoteGenresDs() {
    return _instance;
  }

  RemoteGenresDs._internal();

  @override
  Future<List<MovieGenre>> get allGenres async {
    http.Response response = await tmdbHelper.get(tmdbHelper.getAllGenresUri());

    return (json.decode(response.body)["genres"] as List).map((it) {
      return MovieGenre.fromJson(it);
    }).toList();
  }

  @override
  Future<List<MovieGenre>> getGenresForIds(List<int> ids) {
    return Future.error(NotImplementedException.inClass(this));
  }

  @override
  Future<Function> saveGenres(List<MovieGenre> movies) {
    return Future.error(NotImplementedException.inClass(this));
  }
}
