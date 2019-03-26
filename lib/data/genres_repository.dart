import 'package:agilie_flutter_payments/data/ds/abs_genre_ds.dart';
import 'package:agilie_flutter_payments/errors.dart';
import 'package:agilie_flutter_payments/model/models.dart';

class GenresRepository {
  GenresDs _localDs;
  GenresDs _remoteDs;

  GenresRepository(this._remoteDs, this._localDs);

  Future<List<MovieGenre>> getGenresForIds(List<int> ids) {
    return _localDs.getGenresForIds(ids).catchError((err) {
      if (err is NoItemError) {
        return _remoteDs.allGenres
            .then((genres) => _localDs.saveGenres(genres).then((v) {
                  return _localDs.getGenresForIds(ids);
                }));
      } else
        throw err;
    });
  }
}
