import 'dart:collection';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

const TMDB_BASE_URL = "api.themoviedb.org";
const URL_UPCOMING_MOVIES = "/3/movie/upcoming";
const URL_ALL_GENRES = "/3/genre/movie/list";
const THEMOVIEDB_API_KEY = "d84eed920d17ea08fe8bc112a2dbd1f6";
const URL_MOVIE_DETAILS = "/3/movie";

Request getUpcomingMoviesRequest() {
  return Request("GET", Uri.parse("$TMDB_BASE_URL/$URL_UPCOMING_MOVIES"));
}

Uri getUpcomingMoviesUri() {
  final query = new HashMap<String, String>();
  query["api_key"] = THEMOVIEDB_API_KEY;
  return Uri.http("$TMDB_BASE_URL", "$URL_UPCOMING_MOVIES", query);
}

Uri getMovieDetail(int movieId) {
  final query = new HashMap<String, String>();
  query["api_key"] = THEMOVIEDB_API_KEY;
  return Uri.http("$TMDB_BASE_URL", "$URL_MOVIE_DETAILS/$movieId", query);
}

Uri getAllGenresUri() {
  final query = new HashMap<String, String>();
  query["api_key"] = THEMOVIEDB_API_KEY;
  return Uri.http("$TMDB_BASE_URL", "$URL_ALL_GENRES", query);
}

Future<Response> get(url, {Map<String, String> headers}) {
  return http.get(url, headers: headers).then((response) {
    if (response.statusCode < 200 || response.statusCode > 299) {
      throw Exception(
          "Failed request ${response.request.url}.\nCode == ${response.statusCode}\nReason == ${response.reasonPhrase}");
    } else
      return response;
  });
}
