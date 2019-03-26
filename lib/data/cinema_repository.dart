import 'package:agilie_flutter_payments/data/ds/abs_ds_cinema.dart';
import 'package:agilie_flutter_payments/model/models.dart';

class CinemaRepository {
  CinemaDs _remoteDs;

  CinemaRepository(this._remoteDs);

  Future<List<Cinema>> getCinemasList() async {
    return _remoteDs.getCinemas;
  }
}
