import 'dart:async';

import 'package:agilie_flutter_payments/base_widgets.dart';
import 'package:agilie_flutter_payments/data/ds/local/local_moview_ds.dart';
import 'package:agilie_flutter_payments/data/ds/remote/remote_movie_ds.dart';
import 'package:agilie_flutter_payments/data/movie_repository.dart';
import 'package:agilie_flutter_payments/model/models.dart';
import 'package:agilie_flutter_payments/screens/movie_details_screen.dart';
import 'package:agilie_flutter_payments/vm/movie_list_page_vm.dart';
import 'package:flutter/material.dart';

class MoviesListPage extends StatefulWidget {
  @override
  State createState() {
    return MoviesListBaseState(
      MoviesListVm(
        MovieRepository(
          RemoteMovieDs(),
          LocalMovieDs(),
        ),
      ),
    );
  }
}

class MoviesListBaseState extends BaseState<MoviesListPage> {
  MoviesListVm _moviesVm;

  StreamController<List<Movie>> streamController;

  MoviesListBaseState(this._moviesVm);

  @override
  void dispose() {
    print("Dispose");
    streamController.close();
    streamController = null;
    _moviesVm = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    streamController = StreamController<List<Movie>>.broadcast();
    _moviesVm.initVm(streamController);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: _getMoviesBodyList(),
        ),
      ),
    );
  }

  Widget _getMoviesBodyList() {
    return StreamBuilder<List<Movie>>(
        stream: _moviesVm.moviesStream,
        builder: (context, data) {
          if (data.hasData) {
            final movies = data.data;
            final size = screenSize();
            final aspectRatio = orientation() == Orientation.portrait
                ? size.width / (size.height - 82.0)
                : size.height / (size.width - 82.0);

            double width = 108.0;
            if (size.shortestSide >= 600) width = 108.0 * 2;

            return Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: GridView.builder(
                itemCount: movies.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: width,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 8,
                  childAspectRatio: aspectRatio,
                ),
                itemBuilder: (context, position) {
                  return _getMovieItemMultiChild(movies[position]);
                },
              ),
            );
          } else {
            return Text("No data");
          }
        });
  }

  static const String imageIdMoviePoster = "imageMoviePoster";
  static const String textIdMovieName = "textMovieNameId";
  static const String textIdMovieReleaseDate = "textMovieReleaseDateId";
  static const String rippleId = "rippleId";

  Widget _getMovieItemMultiChild(Movie movie) {
    return CustomMultiChildLayout(
      delegate: ItemMovieMultiChildDelegate(),
      children: <Widget>[
        LayoutId(
          id: imageIdMoviePoster,
          child: Image.network(
            "https://image.tmdb.org/t/p/w154" + movie.poster,
          ),
        ),
        LayoutId(
          id: textIdMovieName,
          child: Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        ),
        LayoutId(
          id: textIdMovieReleaseDate,
          child: Text(
            movie.releaseDate.year.toString(),
            style: TextStyle(color: Colors.white70),
          ),
        ),
        LayoutId(
          id: rippleId,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.lightBlue.withOpacity(0.3),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) {
                      return MovieDetailPage(movie.id);
                    },
                  ),
                );
                print("Movie tapped ${movie.title}");
              },
            ),
          ),
        )
      ],
    );
  }
}

class ItemMovieMultiChildDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final Size imageSize = layoutChild(
      MoviesListBaseState.imageIdMoviePoster,
      BoxConstraints.loose(size),
    );

    final baseImageXOffset = (size.width - imageSize.width) / 2;
    final baseImageYOffset = (size.height - imageSize.height) / 2;

    final Size movieNameSize = layoutChild(
      MoviesListBaseState.textIdMovieName,
      BoxConstraints.loose(Size(
          imageSize.width < 5 ? 0 : imageSize.width - 5, imageSize.height)),
    );

    final Size releaseNameSize = layoutChild(
        MoviesListBaseState.textIdMovieReleaseDate,
        BoxConstraints.loose(imageSize));

    layoutChild(MoviesListBaseState.rippleId, BoxConstraints.loose(imageSize));

    positionChild(MoviesListBaseState.imageIdMoviePoster,
        Offset(baseImageXOffset, baseImageYOffset));

    positionChild(MoviesListBaseState.rippleId,
        Offset(baseImageXOffset, baseImageYOffset));
    final releaseDateOffset =
        size.height - (baseImageYOffset * 2) - releaseNameSize.height - 5;

    positionChild(MoviesListBaseState.textIdMovieReleaseDate,
        Offset(baseImageXOffset + 5, releaseDateOffset));

    positionChild(
        MoviesListBaseState.textIdMovieName,
        Offset(baseImageXOffset + 5,
            releaseDateOffset - movieNameSize.height - 10));
  }

  @override
  bool shouldRelayout(ItemMovieMultiChildDelegate oldDelegate) => true;
}
