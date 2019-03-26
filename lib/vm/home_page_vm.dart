import 'dart:async';

import 'package:agilie_flutter_payments/data/cinema_repository.dart';
import 'package:agilie_flutter_payments/model/models.dart';

class HomePageVm {

  Stream<List<Cinema>> cinemaStream;
  CinemaRepository _repository;

  HomePageVm(this._repository, StreamController<List<Cinema>> streamController) {
    cinemaStream = streamController.stream;
    _repository.getCinemasList().then((cinema) {
      streamController.add(cinema);
    });
  }

}
