import 'dart:async';

import 'package:agilie_flutter_payments/base_widgets.dart';
import 'package:agilie_flutter_payments/data/ds/local/local_genres_ds.dart';
import 'package:agilie_flutter_payments/data/ds/local/local_moview_ds.dart';
import 'package:agilie_flutter_payments/data/ds/remote/remote_genres_ds.dart';
import 'package:agilie_flutter_payments/data/ds/remote/remote_movie_ds.dart';
import 'package:agilie_flutter_payments/data/genres_repository.dart';
import 'package:agilie_flutter_payments/data/movie_repository.dart';
import 'package:agilie_flutter_payments/model/models.dart';
import 'package:agilie_flutter_payments/vm/moview_detail_vm.dart';
import 'package:flutter/material.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  MovieDetailPage(this.movieId);

  @override
  State createState() {
    return MovieDetailDefaultState(MovieDetailsVm(
        MovieRepository(
          RemoteMovieDs(),
          LocalMovieDs(),
        ),
        GenresRepository(
          RemoteGenresDs(),
          LocalGenresDs(),
        ),
        movieId));
  }
}

class MovieDetailDefaultState extends BaseState<MovieDetailPage> {
  MovieDetailsVm _movieDetailsVm;

  MovieDetailDefaultState(this._movieDetailsVm);

  StreamController<Tuple2<Movie, MovieDetail>> _streamController;

  @override
  void dispose() {
    _streamController.close();
    _streamController = null;
    _movieDetailsVm = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _streamController =
        StreamController<Tuple2<Movie, MovieDetail>>.broadcast();
    _movieDetailsVm.initVm(_streamController);
  }

  final textStyle = TextStyle(color: Colors.white, fontSize: 14.0);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
          stream: _movieDetailsVm.moviesStream,
          builder: (context, data) {
            if (!data.hasData) return Text("Loading");
            Tuple2<Movie, MovieDetail> movie = data.data;
            return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: screenSize().height / 4,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          movie.item1.title,
                          style: textStyle,
                        ),
                        background: Image.network(
                          BIG_IMAGE_ENDPOINT + movie.item2.backdropPath,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ];
                },
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getHeadInfoRow(movie.item1, movie.item2),
//                Text("Cast"),
//                Text("LongCastRow, LongCastRow, LongCastRow, LongCastRow, LongCastRow, LongCastRow, LongCastRow, LongCastRow, LongCastRow, LongCastRow, LongCastRow, LongCastRow, LongCastRow, LongCastRow, "),
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        "Description",
                        style: textStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 4),
                      child: Text(
                        movie.item2.overview,
                        style: textStyle,
                      ),
                    ),
                  ],
                ));
          }),
    );
  }

  static const String IMAGE_ENDPOINT = "https://image.tmdb.org/t/p/w154";
  static const String BIG_IMAGE_ENDPOINT = "https://image.tmdb.org/t/p/w780";

  Widget _getHeadInfoRow(Movie movie, MovieDetail movieDetail) {
    var genres = "";
    movie.genres.forEach((it) {
      genres = genres + "${it.name}, ";
    });
    if (genres.trim().isNotEmpty) {
      genres = genres.substring(0, genres.length - 2);
    }
    final padding = 6.0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Image.network(IMAGE_ENDPOINT + movie.poster),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.only(top: 8, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    child: Text(
                      genres,
                      style: textStyle,
                    ),
                    padding: EdgeInsets.only(bottom: padding),
                  ),
                  Padding(
                    child: Text(
                      movie.releaseDate.toString(),
                      style: textStyle,
                    ),
                    padding: EdgeInsets.only(bottom: padding),
                  ),
                  Padding(
                    child: Text(
                      movie.averageVote.toString(),
                      style: textStyle,
                    ),
                    padding: EdgeInsets.only(bottom: padding),
                  ),
                  InkWell(
                    child: Text(
                      movieDetail.homepage,
                      style: textStyle,
                    ),
                    onTap: () => {_launchURL(movieDetail.homepage)},
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            padding: EdgeInsets.only(right: 40, left: 40, top: 10, bottom: 10),
                            color: Colors.pink.shade400,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(10, 10))),
                            child: Text("Buy tickets", style: textStyle,),
                            onPressed: () {
                              InAppPayments
                                  .startCardEntryFlow(onCardNonceRequestSuccess: (
                                  result) {
                                InAppPayments.completeCardEntry();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
