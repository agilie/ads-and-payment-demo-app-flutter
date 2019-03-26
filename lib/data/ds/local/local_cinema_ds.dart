import 'package:agilie_flutter_payments/model/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:agilie_flutter_payments/data/ds/abs_ds_cinema.dart';

class LocalCinemaDs implements CinemaDs {
  List<Cinema> cinemas;

  @override
  Future<List<Cinema>> get getCinemas {
    return Future.value(cinemas);
  }

  LocalCinemaDs() {
    this.cinemas = new List();
    City city = new City(1, "Dnipro", LatLng(48.46666667, 35.01805556));

    cinemas.add(Cinema(
      1,
      "Dafi",
      city,
      LatLng(48.4253882, 35.0218291),
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWzozSu9xQA06DF9GLb-JzPQ5Z8i3db4wmG9IOiRf1TojOl7U3",
    ));
    cinemas.add(Cinema(
      2,
      "Most-Kino",
      city,
      LatLng(48.466846, 35.0510719),
      "https://gorod.dp.ua/pic/placeimages/07/3096/logo.jpg",
    ));

    cinemas.add(Cinema(
      3,
      "Multiplex",
      city,
      LatLng(48.5285775, 35.0327343),
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1glN6vsZA3wGDSbTo4jNdZsyB9VzqGT19of2TyZaeUBbhy9RO",
    ));
  }
}
